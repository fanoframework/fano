{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpwebProcessorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableIntf,
    RunnableWithDataNotifIntf,
    ProtocolProcessorIntf,
    ReadyListenerIntf,
    DataAvailListenerIntf,
    EnvironmentIntf,
    CloseableIntf,
    StreamIdIntf,
    StreamAdapterIntf,
    fphttpserver,
    FpwebResponseAwareIntf,
    FpwebSvrConfigTypes;

type

    (*!-----------------------------------------------
     * Class which can process request from Free Pascal
     * built-in web server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFpwebProcessor = class(TInterfacedObject, IProtocolProcessor, IRunnable, IRunnableWithDataNotif)
    private
        fStdIn : IStreamAdapter;
        fRequestReadyListener : IReadyListener;
        fDataListener : IDataAvailListener;
        fSvrConfig : TFpwebSvrConfig;
        fMimeLoaded : boolean;
        fConnection : IFpwebResponseAware;

        fHttpSvr : TFpHttpServer;

        function initHttpServer(const svrConfig : TFpwebSvrConfig) : TFpHttpServer;

        function buildEnv(
            const request : TFPHttpConnectionRequest
        ): ICGIEnvironment;

        procedure handleStaticFileRequest(
            const aFileName : string;
            var request : TFPHttpConnectionRequest;
            var response : TFPHttpConnectionResponse
        );

        procedure handleNotFoundRequest(
            Sender: TObject;
            var request : TFPHttpConnectionRequest;
            var response : TFPHttpConnectionResponse
        );

        procedure handleRequest(
            Sender: TObject;
            var request : TFPHttpConnectionRequest;
            var response : TFPHttpConnectionResponse
        );

    public
        constructor create(
            const conn : IFpwebResponseAware;
            const svrConfig : TFpwebSvrConfig
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
    fpmimetypes,
    FpwebParamKeyValuePairImpl,
    KeyValueEnvironmentImpl,
    NullStdInImpl,
    NullStreamAdapterImpl,
    StreamAdapterImpl;

    constructor TFpwebProcessor.create(
        const conn : IFpwebResponseAware;
        const svrConfig : TFpwebSvrConfig
    );
    begin
        fConnection := conn;
        fStdIn := nil;
        fRequestReadyListener := nil;
        fDataListener := nil;
        fSvrConfig := svrConfig;
        fHttpSvr := initHttpServer(fSvrConfig);
    end;

    destructor TFpwebProcessor.destroy();
    begin
        fHttpSvr.free();
        fDataListener := nil;
        fRequestReadyListener := nil;
        fStdIn := nil;
        fConnection := nil;
        inherited destroy();
    end;

    function TFpwebProcessor.initHttpServer(const svrConfig : TFpwebSvrConfig) : TFpHttpServer;
    var aSvr : TFpHttpServer;
    begin
        aSvr := TFpHttpServer.create(nil);
        aSvr.threaded := fSvrConfig.threaded;
        aSvr.Port := fSvrConfig.port;
        //aSvr.address := fSvrConfig.host;
        aSvr.onRequest := @handleRequest;
        fMimeLoaded := false;
        if fileExists(fSvrConfig.MimeTypesFile) then
        begin
            MimeTypes.LoadFromFile(fSvrConfig.MimeTypesFile);
            fMimeLoaded := true;
        end;
        result := aSvr;
    end;

    procedure TFpwebProcessor.handleStaticFileRequest(
        const aFileName : string;
        var request : TFPHttpConnectionRequest;
        var response : TFPHttpConnectionResponse
    );
    var fStream : TStream;
    begin
        fStream := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite);
        try
            if fMimeLoaded then
            begin
                response.ContentType := MimeTypes.GetMimeType(extractFileExt(aFileName));
            end else
            begin
                response.ContentType := 'application/octet-stream';
            end;
            response.ContentLength := fstream.size;
            response.ContentStream := fStream;
            response.SendContent;
            response.ContentStream := nil;
        finally
            fStream.Free;
        end;
    end;

    function TFpwebProcessor.buildEnv(
        const request : TFPHttpConnectionRequest
    ): ICGIEnvironment;
    var
        fpwebData : TFpwebData;
    begin
        fpwebData.request := request;
        fpwebData.serverConfig := fSvrConfig;
        result := TKeyValueEnvironment.create(
            TFpwebParamKeyValuePair.create(fpwebData)
        );
    end;

    procedure TFpwebProcessor.handleNotFoundRequest(
        Sender: TObject;
        var request : TFPHttpConnectionRequest;
        var response : TFPHttpConnectionResponse
    );
    var fpwebEnv : ICGIEnvironment;
    begin
        fConnection.response := response;
        fpwebEnv := buildEnv(request);

        fRequestReadyListener.ready(
            //we will not use socket stream as we will have our own IStdOut
            //that write output with TFpHttpServer
            TNullStreamAdapter.create(),
            fpwebEnv,
            TStreamAdapter.create(TStringStream.create(request.content))
        );
    end;

    procedure TFpwebProcessor.handleRequest(
        Sender: TObject;
        var request : TFPHttpConnectionRequest;
        var response : TFPHttpConnectionResponse
    );
    var isStaticFileRequest : boolean;
        fname : string;
        method : string;
        url : string;
    begin
        url := request.url;
        method := request.method;

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
            handleStaticFileRequest(fname, request, response);
        end else
        begin
            handleNotFoundRequest(sender, request, response);
        end;
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    function TFpwebProcessor.process(
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
    function TFpwebProcessor.getStdIn() : IStreamAdapter;
    begin
        result := fStdIn;
    end;

    (*!------------------------------------------------
     * set listener to be notified when request is ready
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TFpwebProcessor.setReadyListener(const listener : IReadyListener) : IProtocolProcessor;
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
    function TFpwebProcessor.expectedSize(const buff : IStreamAdapter) : int64;
    begin
        //not relevant as TFPHttpServer does all protocol data parsing
        result := 0;
    end;

    (*!------------------------------------------------
     * run it
     *-------------------------------------------------
     * @return current instance
     *-------------------------------------------------*)
    function TFpwebProcessor.run() : IRunnable;
    begin
        try
            fHttpSvr.active := true;
            result := self;
        except
            on e: ESocketError do
            begin
                fHttpSvr.active := false;
                writeln('Exception: ', e.ClassName);
                writeln('Message: ', e.Message);
            end;
        end;
    end;

    (*!------------------------------------------------
    * set instance of class that will be notified when
    * data is available
    *-----------------------------------------------
    * @param dataListener, class that wish to be notified
    * @return true current instance
    *-----------------------------------------------*)
    function TFpwebProcessor.setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;
    begin
        fDataListener := dataListener;
        result := self;
    end;

end.
