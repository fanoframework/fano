{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ScgiProcessorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    CloseableIntf,
    ScgiParserIntf,
    ProtocolProcessorIntf,
    StreamIdIntf,
    ReadyListenerIntf;

type

    (*!-----------------------------------------------
     * Class which can process SCGI stream from web server
     *
     * @link https://python.ca/scgi/protocol.txt
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TScgiProcessor = class(TInterfacedObject, IProtocolProcessor)
    private
        fParser : IScgiParser;
        fRequestReadyListener : IReadyListener;
        fStdIn : IStreamAdapter;

        procedure resetInternalVars();
    public
        constructor create(const aParser : IScgiParser);
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
    end;

implementation

uses

    SysUtils;

    constructor TScgiProcessor.create(const aParser : IScgiParser);
    begin
        inherited create();
        fParser := aParser;
        fRequestReadyListener := nil;
        fStdIn := nil;
    end;

    destructor TScgiProcessor.destroy();
    begin
        resetInternalVars();
        inherited destroy();
    end;

    procedure TScgiProcessor.resetInternalVars();
    begin
        fRequestReadyListener := nil;
        fStdIn := nil;
        fParser := nil;
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    function TScgiProcessor.process(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    ) : boolean;
    begin
        result := true;
        fParser.parse(stream);
        fStdIn := fParser.getStdIn();
        if assigned(fRequestReadyListener) then
        begin
            fRequestReadyListener.ready(
                stream,
                fParser.getEnv(),
                fStdIn
            );
        end;
        //SCGI protocol requires always close socket connection
        streamCloser.close();
    end;

    (*!------------------------------------------------
     * get StdIn stream for complete request
     *-----------------------------------------------*)
    function TScgiProcessor.getStdIn() : IStreamAdapter;
    begin
        result := fStdIn;
    end;

    (*!------------------------------------------------
     * set listener to be notified weh request is ready
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TScgiProcessor.setReadyListener(const listener : IReadyListener) : IProtocolProcessor;
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
    function TScgiProcessor.expectedSize(const buff : IStreamAdapter) : int64;
    begin
        result := fParser.expectedSize(buff);
    end;
end.
