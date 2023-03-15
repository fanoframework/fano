{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeProtocolProcessorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    CloseableIntf,
    StreamIdIntf,
    ReadyListenerIntf,
    ProtocolProcessorIntf,
    RunnableIntf,
    RunnableWithDataNotifIntf,
    DataAvailListenerIntf,
    SyncObjs;


type

    (*!-----------------------------------------------
     * Thread-safe IPRotocolProcessor class having capability to process
     * stream from web server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeProtocolProcessor = class(TInterfacedObject, IProtocolProcessor, IRunnable, IRunnableWithDataNotif)
    private
        fLock : TCriticalSection;
        fActualProcessor : IProtocolProcessor;
        fActualRunnnable : IRunnable;
        fActualRunnableData : IRunnableWithDataNotif;
    public
        constructor create(
            const lock : TCriticalSection;
            const actualProcessor : IProtocolProcessor;
            const actualRunnnable : IRunnable;
            const actualRunnableData : IRunnableWithDataNotif
        );

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

        (*!------------------------------------------------
         * run it
         *-------------------------------------------------
         * @return current instance
         *-------------------------------------------------*)
        function run() : IRunnable;

        (*!------------------------------------------------
        * set instance of class that will be notified when
        * data is available
        *-----------------------------------------------
        * @param dataListener, class that wish to be notified
        * @return true current instance
        *-----------------------------------------------*)
        function setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;
    end;

implementation

    constructor TThreadSafeProtocolProcessor.create(
        const lock : TCriticalSection;
        const actualProcessor : IProtocolProcessor;
        const actualRunnnable : IRunnable;
        const actualRunnableData : IRunnableWithDataNotif
    );
    begin
        fLock := lock;
        fActualProcessor := actualProcessor;
        fActualRunnnable := actualRunnnable;
        fActualRunnableData := actualRunnableData;
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    function TThreadSafeProtocolProcessor.process(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    ) : boolean;
    begin
        fLock.acquire();
        try
            result := fActualProcessor.process(stream, streamCloser, streamId);
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * get StdIn stream for complete request
     *-----------------------------------------------*)
    function TThreadSafeProtocolProcessor.getStdIn() : IStreamAdapter;
    begin
        fLock.acquire();
        try
            result := fActualProcessor.getStdIn();
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * set listener to be notified when request is ready
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TThreadSafeProtocolProcessor.setReadyListener(const listener : IReadyListener) : IProtocolProcessor;
    begin
        fLock.acquire();
        try
            fActualProcessor.setReadyListener(listener);
            result := self;
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * get number of bytes of complete request based
     * on information buffer
     *-----------------------------------------------
     * @return number of bytes of complete request
     *-----------------------------------------------*)
    function TThreadSafeProtocolProcessor.expectedSize(const buff : IStreamAdapter) : int64;
    begin
        fLock.acquire();
        try
            result := fActualProcessor.expectedSize(buff);
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * run it
     *-------------------------------------------------
     * @return current instance
     *-------------------------------------------------*)
    function TThreadSafeProtocolProcessor.run() : IRunnable;
    begin
        //intentionally not wrap inside critical section otherwise
        //critical section never release because
        //it will never terminate until application is shutdown
        fActualRunnnable.run();
        result := self;
    end;

    (*!------------------------------------------------
     * set instance of class that will be notified when
     * data is available
     *-----------------------------------------------
     * @param dataListener, class that wish to be notified
     * @return true current instance
     *-----------------------------------------------*)
    function TThreadSafeProtocolProcessor.setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;
    begin
        fLock.acquire();
        try
            fActualRunnableData.setDataAvailListener(dataListener);
            result := self;
        finally
            fLock.release();
        end;
    end;

end.
