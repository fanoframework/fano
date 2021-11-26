{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit WorkerThreadImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    SysUtils,
    SyncObjs,
    RunnableIntf,
    ProtocolProcessorIntf,
    TaskQueueIntf;

type


    (*!------------------------------------------------
     * generic worker thread that execute runnable object
     * in queue until it is terminated.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TWorkerThread = class(TThread)
    private
        fQueue : ITaskQueue;
        fProtocol : IProtocolProcessor;
        fException : Exception;
        procedure handleExceptionInMainThread();
        procedure handleException();
        function runWorker() : boolean;
        procedure quitWorkerThread();
    protected
        procedure execute(); override;
    public
        constructor create(
            const aQueue : ITaskQueue;
            const proto : IProtocolProcessor
        );
        destructor destroy(); override;
        procedure terminate();
    end;

implementation

uses

    NullRunnableImpl,
    NullProtocolAwareImpl;

    constructor TWorkerThread.create(
        const aQueue : ITaskQueue;
        const proto : IProtocolProcessor
    );
    begin
        fQueue := aQueue;
        fProtocol := proto;
        //create thread with default stack frame size
        inherited create(false);
    end;

    destructor TWorkerThread.destroy();
    begin
        inherited destroy();
        fQueue := nil;
        fProtocol := nil;
    end;

    procedure TWorkerThread.handleExceptionInMainThread();
    begin
        SysUtils.ShowException(fException, nil);
    end;

    procedure TWorkerThread.handleException();
    begin
        fException := Exception(ExceptObject);
        try
            Synchronize(@handleExceptionInMainThread);
        finally
            fException := nil;
        end;
    end;

    procedure TWorkerThread.quitWorkerThread();
    var task : PTaskItem;
    begin
        //thread is being terminated, enqueue dummy task so that when thread is
        //suspended waiting to dequeue on empty queue, it
        //can be continue run and thread can quit gracefully.
        new(task);
        task^.quit := true;
        task^.protocolAware := TNullProtocolAware.create();
        task^.work := TNullRunnable.create();
        fQueue.enqueue(task);
    end;

    procedure TWorkerThread.terminate();
    begin
        //TODO: we should override TerminatedSet() but it is not yet defined
        //in FreePascal < 3.3.1
        //see https://bugs.freepascal.orf/view.php?id=37388
        inherited terminate();
        quitWorkerThread();
    end;

    function TWorkerThread.runWorker() : boolean;
    var task : PTaskItem;
    begin
        //get task to run from thread-safe queue
        task := fQueue.dequeue();
        try
            task^.protocolAware.setProtocol(fProtocol);

            //TODO: add timeout so that long-running task does not starve thread
            //instead yield execution so current thread can process other task
            task^.work.run();

            result := task^.quit;
        finally
            task^.work := nil;
            dispose(task);
        end;
    end;

    procedure TWorkerThread.execute();
    var shouldQuit : boolean;
    begin
        //termination using terminated only is not sufficient as by the time
        //thread is terminated, it may suspended when queue is empty.
        shouldQuit := false;
        while not (terminated or shouldQuit)  do
        begin
            fException := nil;
            try
                shouldQuit := runWorker();
            except
                handleException();
            end;
        end;
    end;
end.
