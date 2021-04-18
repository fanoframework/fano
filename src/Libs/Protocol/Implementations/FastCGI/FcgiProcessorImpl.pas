{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit FcgiProcessorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    CloseableIntf,
    EnvironmentIntf,
    StreamAdapterIntf,
    ProtocolProcessorIntf,
    ReadyListenerIntf,
    StdInStreamAwareIntf,
    FcgiRequestManagerIntf,
    FcgiRequestIdAwareIntf,
    FcgiFrameParserIntf,
    StreamIdIntf;

type

    (*!-----------------------------------------------
     * FastCGI frame processor that parse FastCGI frame
     * and build CGI environment
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiProcessor = class(TInterfacedObject, IProtocolProcessor, IFcgiRequestIdAware, IStdInStreamAware)
    private
        fcgiParser : IFcgiFrameParser;
        fcgiRequestMgr : IFcgiRequestManager;
        fcgiRequestReadyListener : IReadyListener;

        //store request id that is ready to be served
        fCompleteRequestId : word;

        function processBuffer(
            const stream : IStreamAdapter;
            const streamCloser : ICloseable;
            const buffer : pointer;
            const bufferSize : ptrUint
        ) : boolean;

        (*!-----------------------------------------------
         * handle FCGI request with complete records
         *------------------------------------------------
         * @param requestId id of complete request
         * @param stream socket stream
         * @param streamClose, instance which can close stream
         *-----------------------------------------------*)
        procedure handleCompleteRequest(
            const requestId : word;
            const stream : IStreamAdapter;
            const streamCloser : ICloseable
        );
    public
        (*!-----------------------------------------------
         * constructor
         *------------------------------------------------
         * @param parser FastCGI frame parser
         * @param requestMgr, instance of request manager
         *-----------------------------------------------*)
        constructor create(
            const parser : IFcgiFrameParser;
            const requestMgr : IFcgiRequestManager
        );

        (*!-----------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!-----------------------------------------------
         * process stream and parse for FCGI records until stream
         * is exhausted
         *------------------------------------------------
         * @param stream socket stream
         * @param streamClose, instance which can close stream
         *-----------------------------------------------*)
        function process(
            const stream : IStreamAdapter;
            const streamCloser : ICloseable;
            const streamId : IStreamId
        ) : boolean;

        (*!------------------------------------------------
         * set listener to be notified weh request is ready
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function setReadyListener(const listener : IReadyListener) : IProtocolProcessor;

        (*!------------------------------------------------
         * get request id
         *-----------------------------------------------
         * @return request id
         *-----------------------------------------------*)
        function getRequestId() : word;

        (*!------------------------------------------------
        * get FastCGI StdIn stream for complete request
        *-----------------------------------------------*)
        function getStdIn() : IStreamAdapter;

        (*!------------------------------------------------
         * get number of bytes of complete request based
         * on information buffer
         *-----------------------------------------------
         * @return number of bytes of complete request
         *-----------------------------------------------*)
        function expectedSize(const buff : IStreamAdapter) : int64;
    end;

implementation

uses

    FcgiRecordIntf,
    KeyValuePairIntf,
    EnvironmentFactoryIntf,
    EInvalidFcgiRequestIdImpl,
    EInvalidFcgiHeaderLenImpl;

    (*!-----------------------------------------------
     * constructor
     *------------------------------------------------
     * @param parser FastCGI frame parser
     * @param requestMgr, instance of request manager
     *-----------------------------------------------*)
    constructor TFcgiProcessor.create(
        const parser : IFcgiFrameParser;
        const requestMgr : IFcgiRequestManager
    );
    begin
        inherited create();
        fcgiParser := parser;
        fcgiRequestMgr := requestMgr;
        fcgiRequestReadyListener := nil;
    end;

    (*!-----------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TFcgiProcessor.destroy();
    begin
        fcgiParser := nil;
        fcgiRequestMgr := nil;
        fcgiRequestReadyListener := nil;
        inherited destroy();
    end;

    (*!-----------------------------------------------
     * handle FCGI request with complete records
     *------------------------------------------------
     * @param requestId id of complete request
     * @param stream socket stream
     * @param streamClose, instance which can close stream
     *-----------------------------------------------*)
    procedure TFcgiProcessor.handleCompleteRequest(
        const requestId : word;
        const stream : IStreamAdapter;
        const streamCloser : ICloseable
    );
    begin
        fCompleteRequestId := requestId;

        if assigned(fcgiRequestReadyListener) then
        begin
            fcgiRequestReadyListener.ready(
                stream,
                fcgiRequestMgr.getEnvironment(requestId),
                fcgiRequestMgr.getStdInStream(requestId)
            );
        end;

        if not fcgiRequestMgr.keepConnection(requestId) then
        begin
            streamCloser.close();
        end;

        fcgiRequestMgr.remove(requestId);
    end;

    (*!-----------------------------------------------
     * parse stream for FCGI records
     *------------------------------------------------
     * @param stream socket stream
     * @param streamClose, instance which can close stream
     * @param buffer, buffer where data from socket is stored
     * @param bufferSize, size of buffer where data from socket is stored
     *-----------------------------------------------*)
    function TFcgiProcessor.processBuffer(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const buffer : pointer;
        const bufferSize : ptrUint
    ) : boolean;
    var afcgiRec : IFcgiRecord;
        requestId : word;
    begin
        result := false;
        if (fcgiParser.hasFrame(buffer, bufferSize)) then
        begin
            afcgiRec := fcgiParser.parseFrame(buffer, bufferSize);
            fcgiRequestMgr.add(afcgiRec);
            requestId := afcgiRec.getRequestId();
            if fcgiRequestMgr.complete(requestId) then
            begin
                handleCompleteRequest(requestId, stream, streamCloser);
                result := true;
            end;
        end;
    end;

    (*!-----------------------------------------------
     * process stream and parse for FCGI records until stream
     * is exhausted
     *------------------------------------------------
     * @param stream socket stream
     * @param streamClose, instance which can close stream
     *-----------------------------------------------*)
    function TFcgiProcessor.process(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    ) : boolean;
    var bufPtr : pointer;
        bufSize  : ptrUint;
        streamEmpty : boolean;
    begin
        result := false;
        repeat
            streamEmpty := fcgiParser.readRecord(stream, bufPtr, bufSize);
            if (bufPtr <> nil) and (bufSize > 0) then
            begin
                result := processBuffer(stream, streamCloser, bufPtr, bufSize);
            end;
        until streamEmpty or result;
    end;

    (*!------------------------------------------------
     * set listener to be notified weh request is ready
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TFcgiProcessor.setReadyListener(const listener : IReadyListener) : IProtocolProcessor;
    begin
        fcgiRequestReadyListener := listener;
        result := self;
    end;

    (*!------------------------------------------------
     * get request id
     *-----------------------------------------------
     * @return request id
     *-----------------------------------------------*)
    function TFcgiProcessor.getRequestId() : word;
    begin
        result := fCompleteRequestId;
    end;

    (*!------------------------------------------------
     * get FastCGI StdIn stream for complete request
     *-----------------------------------------------*)
    function TFcgiProcessor.getStdIn() : IStreamAdapter;
    begin
        result := fcgiRequestMgr.getStdInStream(fCompleteRequestId);
    end;

    (*!------------------------------------------------
     * get number of bytes of complete request based
     * on information buffer
     *-----------------------------------------------
     * @return number of bytes of complete request
     *-----------------------------------------------*)
    function TFcgiProcessor.expectedSize(const buff : IStreamAdapter) : int64;
    begin
        result := -1;
    end;
end.
