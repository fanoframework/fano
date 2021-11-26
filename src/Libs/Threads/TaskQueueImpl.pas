{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit TaskQueueImpl;

interface

{$MODE OBJFPC}

uses

    gqueue,
    TaskQueueIntf;

type

    TTaskQueueInst = specialize TQueue<PTaskItem>;

    (*!------------------------------------------------
     * non thread-safe adapter class for fcl-stl TQueue
     * which implements IQueue<T> interface.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TTaskQueue = class(TInterfacedObject, ITaskQueue)
    private
        fQueue : TTaskQueueInst;
        procedure cleanUpItems();
    public
        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------*)
        constructor create();

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

    constructor TTaskQueue.create();
    begin
        fQueue := TTaskQueueInst.create();
    end;

    destructor TTaskQueue.destroy();
    begin
        cleanUpItems();
        fQueue.free();
        inherited destroy();
    end;

    procedure TTaskQueue.cleanUpItems();
    var task : PTaskItem;
    begin
        //drain any unprocessed items
        while not isEmpty() do
        begin
            task := dequeue();
            task^.work := nil;
            dispose(task);
        end;
    end;

    (*!------------------------------------------------
     * add value to queue
     *-----------------------------------------------
     * @param value object/data to add
     * @return true if value can be added to queue
     *-----------------------------------------------*)
    function TTaskQueue.enqueue(const value: PTaskItem): boolean;
    begin
        fQueue.push(value);
        result := true;
    end;

    (*!------------------------------------------------
     * retrieve value and remove it from queue
     *-----------------------------------------------
     * @return value object/data
     *-----------------------------------------------*)
    function TTaskQueue.dequeue() : PTaskItem;
    begin
        result := fQueue.front;
        fQueue.pop();
    end;

    (*!------------------------------------------------
     * empty status
     *-----------------------------------------------
     * @return queue empty or not
     *-----------------------------------------------*)
    function TTaskQueue.isEmpty() : boolean;
    begin
        result := fQueue.isEmpty();
    end;
end.
