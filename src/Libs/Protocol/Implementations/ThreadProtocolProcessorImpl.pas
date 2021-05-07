{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadProtocolProcessorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    CloseableIntf,
    ReadyListenerIntf,
    StreamIdIntf,
    ProtocolProcessorIntf,
    DecoratorProtocolProcessorImpl;

type

    (*!-----------------------------------------------
     * decorator class having capability to process
     * stream from web server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadProtocolProcessor = class(TDecoratorProtocolProcessor)
    public

        (*!------------------------------------------------
         * process request stream
         *-----------------------------------------------*)
        function process(
            const stream : IStreamAdapter;
            const streamCloser : ICloseable;
            const streamId : IStreamId
        ) : boolean; override;

    end;

implementation

uses

    Classes;

type

    TProcessorThread = class (TThread)
    private
        fStream : IStreamAdapter;
        fStreamCloser : ICloseable;
        fStreamId : IStreamId;
        fActualProcessor : IProtocolProcessor;
    public
        constructor create(
            const stream : IStreamAdapter;
            const streamCloser : ICloseable;
            const streamId : IStreamId;
            const actualProcessor : IProtocolProcessor
        );
        procedure execute(); override;
    end;

    constructor TProcessorThread.create(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId;
        const actualProcessor : IProtocolProcessor
    );
    const SUSPENDED_THREAD = true;
    begin
        inherited create(SUSPENDED_THREAD);
        fStream := stream;
        fStreamCloser := streamCloser;
        fStreamId := streamId;
        fActualProcessor := actualProcessor;
        FreeOnTerminate := true;
    end;

    procedure TProcessorThread.execute();
    begin
        fActualProcessor.process(fStream, fStreamCloser, fStreamId);
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    function TThreadProtocolProcessor.process(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    ) : boolean;
    var executorThread : TProcessorThread;
    begin
        executorThread := TProcessorThread.create(
            stream,
            streamCloser,
            streamId,
            fActualProcessor
        );
        executorThread.start();
        result := true;
    end;
end.
