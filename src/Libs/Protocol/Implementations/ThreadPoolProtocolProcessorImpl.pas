{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadPoolProtocolProcessorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    CloseableIntf,
    ReadyListenerIntf,
    StreamIdIntf,
    TaskQueueIntf,
    ProtocolProcessorIntf,
    DecoratorProtocolProcessorImpl;

type

    (*!-----------------------------------------------
     * class having capability to process
     * stream from web server by submitting socket stream
     * to queue which then be processed by pool of worker thread
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadPoolProtocolProcessor = class(TInterfacedObject, IProtocolProcessor)
    private
        fQueue : ITaskQueue;
    public
        constructor create(const queue : ITaskQueue);

        (*!------------------------------------------------
         * process request stream
         *-----------------------------------------------*)
        function process(
            const stream : IStreamAdapter;
            const streamCloser : ICloseable;
            const streamId : IStreamId
        ) : boolean;

    end;

implementation

uses

    Classes;

type

    TProcessingTask = class(TInterfacedObject, IRunnable, IProtocolAware);
    private
        fActualProcessor : IProtocolProcessor;
        fStream : IStreamAdapter;
        fStreamCloser : ICloseable;
        fStreamId : IStreamId;
    public
        constructor create(
            const stream : IStreamAdapter;
            const streamCloser : ICloseable;
            const streamId : IStreamId
        );

        (*!------------------------------------------------
         * set protocol processor
         *-----------------------------------------------
         * @param protocol protocol processor
         *-----------------------------------------------*)
        procedure setProtocol(const protocol : IProtocolProcessor);
        function run() : IRunnable;
    end;

    constructor TProcessingTask.create(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    );
    begin
        fStream := stream;
        fStreamCloser := streamCloser;
        fStreamId := streamId;
    end;

    (*!------------------------------------------------
     * set protocol processor
     *-----------------------------------------------
     * @param protocol protocol processor
     *-----------------------------------------------*)
    procedure TProcessingTask.setProtocol(const protocol : IProtocolProcessor);
    begin
        fActualProcessor := protocol;
    end;

    function TProcessingTask.run() : IRunnable;
    begin
        fActualProcessor.process(fStream, fStreamCloser, fStreamId);
    end;

    constructor TThreadPoolProtocolProcessor.create(const queue : ITaskQueue);
    begin
        fQueue := queue;
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    function TThreadPoolProtocolProcessor.process(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    ) : boolean;
    var task : PTaskItem;
    begin
        new(task);
        task^.quit := false;
        task^.protocolAware := TProcessingTask.create(stream, streamCloser, streamId);
        task^.work := task^.protocolAware as IRunnable;
        fQueue.enqueue(task);
        result := true;
    end;
end.
