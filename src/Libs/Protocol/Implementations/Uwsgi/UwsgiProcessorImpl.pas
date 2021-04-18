{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UwsgiProcessorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    CloseableIntf,
    StreamIdIntf,
    UwsgiParserIntf,
    ProtocolProcessorIntf,
    ReadyListenerIntf;

type

    (*!-----------------------------------------------
     * Class which can process uwsgi stream from web server
     *
     * @link https://uwsgi-docs.readthedocs.io/en/latest/Protocol.html
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUwsgiProcessor = class(TInterfacedObject, IProtocolProcessor)
    private
        fParser : IUwsgiParser;
        fRequestReadyListener : IReadyListener;
        fStdIn : IStreamAdapter;

        procedure resetInternalVars();
    public
        constructor create(const aParser : IUwsgiParser);
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

    constructor TUwsgiProcessor.create(const aParser : IUwsgiParser);
    begin
        inherited create();
        fParser := aParser;
        fRequestReadyListener := nil;
        fStdIn := nil;
    end;

    destructor TUwsgiProcessor.destroy();
    begin
        resetInternalVars();
        inherited destroy();
    end;

    procedure TUwsgiProcessor.resetInternalVars();
    begin
        fRequestReadyListener := nil;
        fStdIn := nil;
        fParser := nil;
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    function TUwsgiProcessor.process(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    ) : boolean;
    begin
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
        //close socket connection
        streamCloser.close();
        result := true;
    end;

    (*!------------------------------------------------
     * get StdIn stream for complete request
     *-----------------------------------------------*)
    function TUwsgiProcessor.getStdIn() : IStreamAdapter;
    begin
        result := fStdIn;
    end;

    (*!------------------------------------------------
     * set listener to be notified weh request is ready
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TUwsgiProcessor.setReadyListener(const listener : IReadyListener) : IProtocolProcessor;
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
    function TUwsgiProcessor.expectedSize(const buff : IStreamAdapter) : int64;
    begin
        result := fParser.expectedSize(buff);
    end;

end.
