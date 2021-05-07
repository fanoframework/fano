{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorProtocolProcessorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    CloseableIntf,
    ReadyListenerIntf,
    StreamIdIntf,
    ProtocolProcessorIntf;

type

    (*!-----------------------------------------------
     * decorator class having capability to process
     * stream from web server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDecoratorProtocolProcessor = class(TInterfacedObject, IProtocolProcessor)
    protected
        fActualProcessor : IProtocolProcessor;
    public
        constructor create(const processor : IProtocolProcessor);

        (*!------------------------------------------------
         * process request stream
         *-----------------------------------------------*)
        function process(
            const stream : IStreamAdapter;
            const streamCloser : ICloseable;
            const streamId : IStreamId
        ) : boolean; virtual;

        (*!------------------------------------------------
         * get StdIn stream for complete request
         *-----------------------------------------------*)
        function getStdIn() : IStreamAdapter; virtual;

        (*!------------------------------------------------
         * set listener to be notified when request is ready
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function setReadyListener(const listener : IReadyListener) : IProtocolProcessor; virtual;

        (*!------------------------------------------------
         * get number of bytes of complete request based
         * on information buffer
         *-----------------------------------------------
         * @return number of bytes of complete request
         *-----------------------------------------------*)
        function expectedSize(const buff : IStreamAdapter) : int64; virtual;
    end;

implementation

    constructor TDecoratorProtocolProcessor.create(const processor : IProtocolProcessor);
    begin
        fActualProcessor := processor;
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    function TDecoratorProtocolProcessor.process(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    ) : boolean;
    begin
        result := fActualProcessor.process(stream, streamCloser, streamId);
    end;

    (*!------------------------------------------------
     * get StdIn stream for complete request
     *-----------------------------------------------*)
    function TDecoratorProtocolProcessor.getStdIn() : IStreamAdapter;
    begin
        result := fActualProcessor.getStdIn();
    end;

    (*!------------------------------------------------
     * set listener to be notified when request is ready
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TDecoratorProtocolProcessor.setReadyListener(const listener : IReadyListener) : IProtocolProcessor;
    begin
        fActualProcessor.setReadyListener(listener);
        result := self;
    end;

    (*!------------------------------------------------
     * get number of bytes of complete request based
     * on information buffer
     *-----------------------------------------------
     * @return number of bytes of complete request
     *-----------------------------------------------*)
    function TDecoratorProtocolProcessor.expectedSize(const buff : IStreamAdapter) : int64;
    begin
        result := fActualProcessor.expectedSize(buff);
    end;
end.
