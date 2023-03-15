{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IndyProcessorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    RunnableIntf,
    RunnableWithDataNotifIntf,
    ProtocolProcessorIntf,
    ReadyListenerIntf,
    DataAvailListenerIntf,
    EnvironmentIntf,
    CloseableIntf,
    StreamIdIntf,
    StreamAdapterIntf,
    HttpSvrConfigTypes,
    IndyResponseAwareIntf,

    IdCustomHTTPServer,
    IdContext,
    IdSchedulerOfThreadPool,
    IdHTTPServer;

type

    (*!-----------------------------------------------
     * Class which can process request using Indy
     * TIdHTTPServer web server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TIndyProcessor = class(TInterfacedObject, IProtocolProcessor, IRunnable, IRunnableWithDataNotif)
    private
        fLock : TCriticalSection;
        fStdIn : IStreamAdapter;
        fRequestReadyListener : IReadyListener;
        fDataListener : IDataAvailListener;
        fSvrConfig : THttpSvrConfig;
        fMimeLoaded : boolean;
        fConnection : IIndyResponseAware;

        fHttpSvr : TIdHTTPServer;

        function initHttpServer(const svrConfig : THttpSvrConfig) : TIdHTTPServer;
        procedure initThreadPool(
            const aHttpSvr: TIdHTTPServer;
            const numThread : integer
        );
        procedure waitUntilTerminate();

        function buildEnv(
            const request: TIdHTTPRequestInfo
        ): ICGIEnvironment;

        procedure handleNotFoundRequest(
            ctx: TIdContext;
            request: TIdHTTPRequestInfo;
            response: TIdHTTPResponseInfo
        );

        procedure handleRequest(
            ctx: TIdContext;
            request: TIdHTTPRequestInfo;
            response: TIdHTTPResponseInfo
        );

    public
        constructor create(
            const lock : TCriticalSection;
            const conn : IIndyResponseAware;
            const svrConfig : THttpSvrConfig
        );
        destructor destroy(); override;

        (*!------------------------------------------------
         * process request stream
         *-----------------------------------------------*)
        function process(
            const stream : IStreamAdapter;
            const streamCloser : ICloseable;
            const streamId : IStreamId
        ) : boolean;

        (*!------------------------------------------------
         * get StdIn stream for complete request
         *-----------------------------------------------*)
        function getStdIn() : IStreamAdapter;

        (*!------------------------------------------------
         * set listener to be notified when request is ready
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function setReadyListener(const listener : IReadyListener) : IProtocolProcessor;

        (*!------------------------------------------------
         * get number of bytes of complete request based
         * on information buffer
         *-----------------------------------------------
         * @return number of bytes of complete request
         *-----------------------------------------------*)
        function expectedSize(const buff : IStreamAdapter) : int64;

        (*!------------------------------------------------
         * run it
         *-------------------------------------------------
         * @return current instance
         *-------------------------------------------------*)
        function run() : IRunnable;

        (*!------------------------------------------------
        * set instance of class that will be notified when
        * data is available
        *-----------------------------------------------
        * @param dataListener, class that wish to be notified
        * @return true current instance
        *-----------------------------------------------*)
        function setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;
    end;

implementation

uses

    Classes,
    SysUtils,
    ssockets,
    BaseUnix,
    SigTermImpl,
    IndyParamKeyValuePairImpl,
    KeyValueEnvironmentImpl,
    NullStdInImpl,
    NullStreamAdapterImpl,
    StreamAdapterImpl;

    constructor TIndyProcessor.create(
        const lock : TCriticalSection;
        const conn : IIndyResponseAware;
        const svrConfig : THttpSvrConfig
    );
    begin
        fLock := lock;
        fConnection := conn;
        fStdIn := nil;
        fRequestReadyListener := nil;
        fDataListener := nil;
        fSvrConfig := svrConfig;
        fHttpSvr := initHttpServer(fSvrConfig);
    end;

    destructor TIndyProcessor.destroy();
    begin
        fHttpSvr.free();
        fDataListener := nil;
        fRequestReadyListener := nil;
        fStdIn := nil;
        fConnection := nil;
        fLock := nil;
        inherited destroy();
    end;

    procedure TIndyProcessor.initThreadPool(
        const aHttpSvr: TIdHTTPServer;
        const numThread : integer
    );
    var
        aThreadPoolScheduler: TIdSchedulerOfThreadPool;
    begin
        aThreadPoolScheduler := TIdSchedulerOfThreadPool.Create(aHttpSvr);
        aThreadPoolScheduler.poolSize := numThread;
        aHttpSvr.scheduler := aThreadPoolScheduler;
        //aHttpSvr.maxConnections := numThread;
    end;

    function TIndyProcessor.initHttpServer(const svrConfig : THttpSvrConfig) : TIdHTTPServer;
    var aSvr : TIdHTTPServer;
        numThread : integer;
        amimeTypes : TStrings;
    begin
        aSvr := TIdHTTPServer.create(nil);
        aSvr.DefaultPort := fSvrConfig.port;
        //aSvr.address := fSvrConfig.host;
        aSvr.onCommandGet := @handleRequest;
        aSvr.onCommandOther := @handleRequest;

        if (fSvrConfig.threaded) then
        begin
            numThread := fSvrConfig.threadPoolSize;
            if (numThread = 0) then
            begin
                numThread := getCpuCount() * 16;
            end;
            initThreadPool(aSvr, numThread);
        end;

        fMimeLoaded := false;
        if fileExists(fSvrConfig.MimeTypesFile) then
        begin
            amimeTypes := TStringList.create();
            try
                amimeTypes.LoadFromFile(fSvrConfig.MimeTypesFile);
                aSvr.MimeTable.LoadFromStrings(amimeTypes);
                fMimeLoaded := true;
            finally
                amimeTypes.free();
            end;
        end;
        result := aSvr;
    end;

    function TIndyProcessor.buildEnv(
        const request: TIdHTTPRequestInfo
    ): ICGIEnvironment;
    var
        indyData : TIndyData;
    begin
        indyData.request := request;
        indyData.serverConfig := fSvrConfig;
        result := TKeyValueEnvironment.create(
            TIndyParamKeyValuePair.create(indyData)
        );
    end;

    procedure TIndyProcessor.handleNotFoundRequest(
        ctx: TIdContext;
        request: TIdHTTPRequestInfo;
        response: TIdHTTPResponseInfo
    );
    var aEnv : ICGIEnvironment;
        aStdInStream : IStreamAdapter;
    begin
        fLock.acquire();
        try
            fConnection.response := response;
            aEnv := buildEnv(request);
            if (request.postStream = nil) then
            begin
                aStdInStream := TNullStreamAdapter.create();
            end else
            begin
                aStdInStream := TStreamAdapter.create(request.postStream);
            end;

            fRequestReadyListener.ready(
                //we will not use socket stream as we will have our own IStdOut
                //that write output with TIdHTTPServer
                TNullStreamAdapter.create(),
                aEnv,
                aStdInStream
            );
        finally
            fLock.release();
        end;
    end;

    procedure TIndyProcessor.handleRequest(
        ctx: TIdContext;
        request: TIdHTTPRequestInfo;
        response: TIdHTTPResponseInfo
    );
    var isStaticFileRequest : boolean;
        fname : string;
        method : string;
        url : string;
    begin
        url := request.document;
        method := request.command;

        if (length(url) > 0) and (url[1] = '/') then
        begin
           delete(url, 1, 1);
        end;

        DoDirSeparators(url);
        fname := fSvrConfig.documentRoot + url;
        isStaticFileRequest := ((method = 'GET') or (method = 'HEAD')) and
            fileExists(fname);

        if isStaticFileRequest then
        begin
            response.serveFile(ctx, fname);
        end else
        begin
            handleNotFoundRequest(ctx, request, response);
        end;
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    function TIndyProcessor.process(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    ) : boolean;
    begin
        //intentationally does nothing, because TFPHttpServer
        //already does stream parsing so this is not relevant
        result := true;
    end;

    (*!------------------------------------------------
        * get StdIn stream for complete request
        *-----------------------------------------------*)
    function TIndyProcessor.getStdIn() : IStreamAdapter;
    begin
        result := fStdIn;
    end;

    (*!------------------------------------------------
     * set listener to be notified when request is ready
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TIndyProcessor.setReadyListener(const listener : IReadyListener) : IProtocolProcessor;
    begin
        fRequestReadyListener := listener;
        result := self;
    end;

    (*!------------------------------------------------
     * get number of bytes of complete request based
     * on information buffer
     *-----------------------------------------------
     * @return number of bytes of complete request
     *-----------------------------------------------*)
    function TIndyProcessor.expectedSize(const buff : IStreamAdapter) : int64;
    begin
        //not relevant as TFPHttpServer does all protocol data parsing
        result := 0;
    end;

    procedure TIndyProcessor.waitUntilTerminate();
    var fds : TFDSet;
    begin
        fds := default(TFDSet);
        fpfd_zero(fds);
        //terminatePipeIn will be ready for IO when application is terminated
        //see SigTermImpl unit
        fpfd_set(TSigTerm.terminatePipeIn, FDS);
        //wait forever until terminatePipeIn changes
        fpSelect(TSigTerm.terminatePipeIn + 1, @fds, nil, nil, nil);
    end;

    (*!------------------------------------------------
     * run it
     *-------------------------------------------------
     * @return current instance
     *-------------------------------------------------*)
    function TIndyProcessor.run() : IRunnable;
    begin
        result := self;
        fHttpSvr.active := true;
        //wait until we receive termination signal
        waitUntilTerminate();
        fHttpSvr.active := false;
    end;

    (*!------------------------------------------------
    * set instance of class that will be notified when
    * data is available
    *-----------------------------------------------
    * @param dataListener, class that wish to be notified
    * @return true current instance
    *-----------------------------------------------*)
    function TIndyProcessor.setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;
    begin
        fDataListener := dataListener;
        result := self;
    end;

end.
