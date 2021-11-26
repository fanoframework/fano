{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeTaskQueueImpl;

interface

{$MODE OBJFPC}

uses

    SyncObjs,
    TaskQueueIntf;

type

    (*!------------------------------------------------
     * thread-safe blocking queue which implements
     * ITaskQueue interface. This implementation wraps
     * non thread-safe ITaskQueue implementation into thread-safe
     * implementation.
     *
     * The idea is borrowed from TBlockingQueue by David Heffernan
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     * @link https://stackoverflow.com/questions/15027726/how-to-make-a-thread-finish-its-work-before-being-freed/15033839#15033839
     *-----------------------------------------------*)
    TThreadSafeTaskQueue = class(TInterfacedObject, ITaskQueue)
    private
        //non thread-safe queue
        fQueue : ITaskQueue;

        //critical section to protect access to actual queue
        fLock: TCriticalSection;

        //event for signaling queue empty status
        fNotEmpty: TEvent;
    public
        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param actualQueue actual queue to be wrapped
         *-----------------------------------------------*)
        constructor create(const actualQueue : ITaskQueue);

        (*!------------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * add value to queue
         *-----------------------------------------------
         * @param value object/data to add
         * @return true if value can be added to queue
         *-----------------------------------------------*)
        function enqueue(const value: PTaskItem): boolean;

        (*!------------------------------------------------
         * retrieve value and remove it from queue
         *-----------------------------------------------
         * @return value object/data
         *-----------------------------------------------*)
        function dequeue() : PTaskItem;

        (*!------------------------------------------------
         * empty status
         *-----------------------------------------------
         * @return queue empty or not
         *-----------------------------------------------*)
        function isEmpty() : boolean;
    end;

implementation

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------
     * @param actualQueue actual queue to be wrapped
     *-----------------------------------------------*)
    constructor TThreadSafeTaskQueue.create(const actualQueue : ITaskQueue);
    begin
        fQueue := actualQueue;
        fLock := TCriticalSection.create;
        fNotEmpty := TEvent.create(nil, true, false, '');
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TThreadSafeTaskQueue.destroy();
    begin
        fQueue := nil;
        fLock.free();
        fNotEmpty.free();
        inherited destroy();
    end;

    (*!------------------------------------------------
     * add value to queue
     *-----------------------------------------------
     * @param value object/data to add
     * @return true if value can be added to queue
     *-----------------------------------------------*)
    function TThreadSafeTaskQueue.enqueue(const value: PTaskItem): boolean;
    var wasEmpty: boolean;
    begin
        fLock.acquire();
        try
            wasEmpty := fQueue.isEmpty();
            result := fQueue.enqueue(value);
            if wasEmpty then
            begin
                //signal that queue is not empty anymore
                fNotEmpty.setEvent();
            end;
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * retrieve value and remove it from queue
     *-----------------------------------------------
     * @return value object/data
     *-----------------------------------------------*)
    function TThreadSafeTaskQueue.dequeue() : PTaskItem;
    begin
        fLock.acquire();
        try

            //need to do wait in loop because there is chance that
            //by the time fNotEmpty is signaled, other thread may dequeue it
            //causing queue to be empty again before we can reacquire the lock
            while fQueue.isEmpty() do
            begin
                //release lock, so other thread can access fQueue
                fLock.release();
                try
                    //wait until queue not empty
                    fNotEmpty.waitFor(INFINITE);
                finally
                    //reacquire lock, so other thread cannot access fQueue
                    fLock.acquire();
                end;
            end;

            result := fQueue.dequeue();

            if fQueue.isEmpty() then
            begin
                //signal that queue is empty
                fNotEmpty.resetEvent();
            end;
        Finally
            fLock.release();
        End;
    end;

    (*!------------------------------------------------
     * empty status
     *-----------------------------------------------
     * @return queue empty or not
     *-----------------------------------------------*)
    function TThreadSafeTaskQueue.isEmpty() : boolean;
    begin
        fLock.acquire();
        try
            result := fQueue.isEmpty();
        finally
            fLock.release();
        end;
    end;

end.
