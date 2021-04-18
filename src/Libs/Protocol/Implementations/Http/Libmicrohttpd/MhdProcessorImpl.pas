{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MhdProcessorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    libmicrohttpd,
    StreamAdapterIntf,
    CloseableIntf,
    RunnableIntf,
    RunnableWithDataNotifIntf,
    ProtocolProcessorIntf,
    StreamIdIntf,
    ReadyListenerIntf,
    DataAvailListenerIntf,
    EnvironmentIntf,
    MhdConnectionAwareIntf,
    MhdSvrConfigTypes;

type

    (*!-----------------------------------------------
     * Class which can process request from libmicrohttpd web server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMhdProcessor = class(TInterfacedObject, IProtocolProcessor, IRunnable, IRunnableWithDataNotif)
    private
        fSvrConfig : TMhdSvrConfig;
        fRequestReadyListener : IReadyListener;
        fDataListener : IDataAvailListener;
        fStdIn : IStreamAdapter;
        fConnectionAware : IMhdConnectionAware;

        procedure resetInternalVars();
        procedure waitUntilTerminate();

        function buildEnv(
            aconnection : PMHD_Connection;
            aurl : pcchar;
            amethod : pcchar;
            aversion : pcchar
        ): ICGIEnvironment;

        function handleReq(
            aconnection : PMHD_Connection;
            aurl : pcchar;
            amethod : pcchar;
            aversion : pcchar;
            aupload_data : pcchar;
            aupload_data_size : psize_t;
            aptr : ppointer
        ): cint;

        function handleFileNotFoundReq(
            aconnection : PMHD_Connection;
            aurl : pcchar;
            amethod : pcchar;
            aversion : pcchar;
            aupload_data : pcchar;
            aupload_data_size : psize_t;
            aptr : ppointer
        ): cint;

        function handleStaticFileReq(
            aconnection : PMHD_Connection;
            aurl : pcchar;
            amethod : pcchar;
            aversion : pcchar;
            aupload_data : pcchar;
            aupload_data_size : psize_t;
            aptr : ppointer
        ): cint;

        function tryRun() : IRunnable;
    public
        constructor create(
            const aConnectionAware : IMhdConnectionAware;
            const svrConfig : TMhdSvrConfig
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
    BaseUnix,
    SysUtils,
    TermSignalImpl,
    KeyValueEnvironmentImpl,
    MhdParamKeyValuePairImpl,
    StreamAdapterImpl,
    NullStreamAdapterImpl,
    FileUtils;

    constructor TMhdProcessor.create(
        const aConnectionAware : IMhdConnectionAware;
        const svrConfig : TMhdSvrConfig
    );
    begin
        inherited create();
        fConnectionAware := aConnectionAware;
        fSvrConfig := svrConfig;
        fRequestReadyListener := nil;
        fDataListener := nil;
        fStdIn := nil;
    end;

    destructor TMhdProcessor.destroy();
    begin
        resetInternalVars();
        inherited destroy();
    end;

    procedure TMhdProcessor.resetInternalVars();
    begin
        fRequestReadyListener := nil;
        fDataListener := nil;
        fStdIn := nil;
        fConnectionAware := nil;
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    function TMhdProcessor.process(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    ) : boolean;
    begin
        //intentationally does nothing, because libmicrohttpd
        //already does stream parsing so this is not relevant
        result := true;
    end;

    (*!------------------------------------------------
     * get StdIn stream for complete request
     *-----------------------------------------------*)
    function TMhdProcessor.getStdIn() : IStreamAdapter;
    begin
        result := fStdIn;
    end;

    (*!------------------------------------------------
     * set listener to be notified weh request is ready
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TMhdProcessor.setReadyListener(const listener : IReadyListener) : IProtocolProcessor;
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
    function TMhdProcessor.expectedSize(const buff : IStreamAdapter) : int64;
    begin
        result := 0;
    end;

    procedure TMhdProcessor.waitUntilTerminate();
    var fds : TFDSet;
    begin
        fds := default(TFDSet);
        fpfd_zero(fds);
        //terminatePipeIn will be ready for IO when application is terminated
        //see TermSignalImpl unit
        fpfd_set(terminatePipeIn, FDS);
        //wait forever until terminatePipeIn changes
        fpSelect(terminatePipeIn + 1, @fds, nil, nil, nil);
    end;

    //BaseUnix and libmicrohttpd both declared pcchar type
    //here any pcchar use libmicrohttpd.pcchar,
    //otherwise FPC complains about type mismatch
    function handleRequestCallback(
        acontext :  pointer;
        aconnection : PMHD_Connection;
        aurl : libmicrohttpd.pcchar;
        amethod : libmicrohttpd.pcchar;
        aversion : libmicrohttpd.pcchar;
        aupload_data : libmicrohttpd.pcchar;
        aupload_data_size : libmicrohttpd.psize_t;
        aptr : ppointer
    ): cint; cdecl;
    begin
        result := TMhdProcessor(acontext).handleReq(
            aconnection,
            aurl,
            amethod,
            aversion,
            aupload_data,
            aupload_data_size,
            aptr
        );
    end;

    function TMhdProcessor.buildEnv(
        aconnection : PMHD_Connection;
        aurl : libmicrohttpd.pcchar;
        amethod : libmicrohttpd.pcchar;
        aversion : libmicrohttpd.pcchar
    ): ICGIEnvironment;
    var
        mhdData : TMhdData;
    begin
        mhdData.connection := aconnection;
        mhdData.url := aurl;
        mhdData.method := amethod;
        mhdData.version := aversion;
        mhdData.serverConfig := fSvrConfig;
        result := TKeyValueEnvironment.create(
            TMhdParamKeyValuePair.create(mhdData)
        );
    end;

    function TMhdProcessor.handleReq(
        aconnection : PMHD_Connection;
        aurl : libmicrohttpd.pcchar;
        amethod : libmicrohttpd.pcchar;
        aversion : libmicrohttpd.pcchar;
        aupload_data : libmicrohttpd.pcchar;
        aupload_data_size : psize_t;
        aptr : ppointer
    ): cint;
    var bufStat: TStat;
        isStaticFileRequest : boolean;
        fname : string;
        method : string;
        url : string;
    begin
        url := string(pchar(aurl));
        method := string(pchar(amethod));
        fname := fSvrConfig.documentRoot + url;
        isStaticFileRequest := ((method = MHD_HTTP_METHOD_GET) or
            (method = MHD_HTTP_METHOD_HEAD)) and
            (url <> '/') and
            (0 = fpStat(pchar(fname), bufStat));

        if isStaticFileRequest then
        begin
            result := handleStaticFileReq(
                aconnection,
                aurl,
                amethod,
                aversion,
                aupload_data,
                aupload_data_size,
                aptr
            );
        end else
        begin
            result := handleFileNotFoundReq(
                aconnection,
                aurl,
                amethod,
                aversion,
                aupload_data,
                aupload_data_size,
                aptr
            );
        end;
    end;

    function TMhdProcessor.handleFileNotFoundReq(
        aconnection : PMHD_Connection;
        aurl : libmicrohttpd.pcchar;
        amethod : libmicrohttpd.pcchar;
        aversion : libmicrohttpd.pcchar;
        aupload_data : libmicrohttpd.pcchar;
        aupload_data_size : psize_t;
        aptr : ppointer
    ): cint;
    var
        mhdEnv : ICGIEnvironment;
        mhdStream : IStreamAdapter;
        mem : TMemoryStream;
    begin
        result := MHD_NO;
        if (aptr^ = nil) then
        begin
            //begin of request
            mem := TMemoryStream.create();
            if (aupload_data_size^ > 0) then
            begin
                mem.writeBuffer(aupload_data^, aupload_data_size^);
                aupload_data_size^ := 0;
            end;
            aptr^ := mem;
            result := MHD_YES;
        end else
        begin
            mem := TMemoryStream(aptr^);

            if (aupload_data_size^ = 0) then
            begin
                //request is complete
                //set seek position to beginning to avoid EReadError
                mem.position := 0;
                fConnectionAware.connection := aconnection;
                mhdEnv := buildEnv(aconnection, aurl, amethod, aversion);

                //wrap memory stream as IStreamAdapter and let
                //them free memory when finished
                mhdStream := TStreamAdapter.create(mem);

                fRequestReadyListener.ready(
                    //we will not use socket stream as we will have our own IStdOut
                    //that write output with libmicrohttpd
                    TNullStreamAdapter.create(),
                    mhdEnv,
                    mhdStream
                );
            end else
            begin
                mem.writeBuffer(aupload_data^, aupload_data_size^);
                aupload_data_size^ := 0;
            end;
            result := MHD_YES;
        end;
    end;

    function TMhdProcessor.handleStaticFileReq(
        aconnection : PMHD_Connection;
        aurl : libmicrohttpd.pcchar;
        amethod : libmicrohttpd.pcchar;
        aversion : libmicrohttpd.pcchar;
        aupload_data : libmicrohttpd.pcchar;
        aupload_data_size : psize_t;
        aptr : ppointer
    ): cint;
    const beginRequestMarker : cint = 0;
    var fd : cint;
        bufStat : TStat;
        response : PMHD_Response;
        fname : string;
    begin
        result := MHD_NO;
        if (@beginRequestMarker <> aptr^) then
        begin
            //this is begin of request, just skip processing
            aptr^ := @beginRequestMarker;
            exit(MHD_YES);
        end;

        fname := fSvrConfig.documentRoot + string(pchar(aurl));
        fpStat(pchar(fname), bufStat);
        fd := fpOpen(pchar(fname), O_RdOnly);
        response := MHD_create_response_from_fd(bufStat.st_size, fd);
        result := MHD_queue_response (aconnection, MHD_HTTP_OK, response);
        MHD_destroy_response (response);
    end;

    (*!------------------------------------------------
     * run it
     *-------------------------------------------------
     * @return current instance
     *-------------------------------------------------*)
    function TMhdProcessor.tryRun() : IRunnable;
    var
        svrDaemon : PMHD_Daemon;
        tlsKey, tlsCert : string;
        flags : cuint;
    begin
        flags := MHD_USE_EPOLL_INTERNALLY_LINUX_ONLY;
        if fSvrConfig.useIPv6 then
        begin
            if fSvrConfig.dualStack then
            begin
                flags := flags or MHD_USE_DUAL_STACK;
            end else
            begin
                flags := flags or MHD_USE_IPv6;
            end;
        end;

        if fSvrConfig.useTLS then
        begin
            tlsKey := readFile(fSvrConfig.tlsKey);
            tlsCert := readFile(fSvrConfig.tlsCert);
            svrDaemon := MHD_start_daemon(
                //TODO: MHD_USE_SSL is now deprecated and replaced with MHD_USE_TLS
                //but FreePascal header translation not yet support MHD_USE_TLS
                flags or MHD_USE_SSL,
                fSvrConfig.port,
                nil,
                nil,
                @handleRequestCallback,
                self,
                MHD_OPTION_CONNECTION_TIMEOUT,
                cuint(fSvrConfig.Timeout),
                MHD_OPTION_HTTPS_MEM_KEY,
                libmicrohttpd.pcchar(tlsKey),
                MHD_OPTION_HTTPS_MEM_CERT,
                libmicrohttpd.pcchar(tlsCert),
                MHD_OPTION_END
            );
        end else
        begin
            svrDaemon := MHD_start_daemon(
                flags,
                fSvrConfig.port,
                nil,
                nil,
                @handleRequestCallback,
                self,
                MHD_OPTION_CONNECTION_TIMEOUT,
                cuint(fSvrConfig.Timeout),
                MHD_OPTION_END
            );
        end;

        if svrDaemon <> nil then
        begin
            waitUntilTerminate();
            MHD_stop_daemon(svrDaemon);
        end;
        result := self;
    end;

    (*!------------------------------------------------
     * run it
     *-------------------------------------------------
     * @return current instance
     *-------------------------------------------------*)
    function TMhdProcessor.run() : IRunnable;
    begin
        try
            result := tryRun();
        except
            on e: Exception do
            begin
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
    function TMhdProcessor.setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;
    begin
        fDataListener := dataListener;
        result := self;
    end;
end.
