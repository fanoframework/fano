{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StreamQueueImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DataAvailListenerIntf,
    CloseableIntf,
    StreamAdapterIntf,
    StreamIdIntf,
    TaskQueueIntf;

type


    (*!-----------------------------------------------
     * class having capability to handle data availability
     * and put stream in queue for later processing
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStreamQueue = class(TInterfacedObject, IDataAvailListener)
    private
        fQueue : ITaskQueue;
    public
        constructor create(const queue : ITaskQueue);

        (*!------------------------------------------------
        * handle if data is available
        *-----------------------------------------------
        * @param stream, stream that store data
        * @param context, additional data related to stream
        * @param streamCloser, instance that can close stream if required
        * @param streamId, instance that can identify stream
        * @return true if data is handled
        *-----------------------------------------------*)
        function handleData(
            const stream : IStreamAdapter;
            const context : TObject;
            const streamCloser : ICloseable;
            const streamId : IStreamId
        ) : boolean;

    end;

implementation

uses

    HandleConnWorkImpl;

    constructor TStreamQueue.create(const queue : ITaskQueue);
    begin
        fQueue := queue;
    end;

    (*!------------------------------------------------
     * handle if data is available
     *-----------------------------------------------
     * @param stream, stream that store data
     * @param context, additional data related to stream
     * @param streamCloser, instance that can close stream if required
     * @param streamId, instance that can identify stream
     * @return true if data is handled
     *-----------------------------------------------*)
    function TStreamQueue.handleData(
        const stream : IStreamAdapter;
        const context : TObject;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    ) : boolean;
    var task : PTaskItem;
        work : THandleConnWork;
    begin
        work := THandleConnWork.create(stream, streamCloser, streamId);
        new(task);
        task^.quit := false;
        task^.protocolAware := work;
        task^.work := work;
        fQueue.enqueue(task);
        result := true;
    end;

end.
