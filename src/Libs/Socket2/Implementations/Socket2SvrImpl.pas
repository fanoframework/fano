{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Socket2SvrImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableIntf,
    RunnableWithDataNotifIntf,
    DataAvailListenerIntf,
    ListenSocketIntf,
    IoHandlerIntf,
    InjectableObjectImpl,
    SocketConsts;

type

    (*!-----------------------------------------------
     * Socket server implementation which support graceful
     * shutdown when receive SIGTERM/SIGINT signal and also
     * allow for keeping client connection open if required
     *----------------------------------------------------
     * We implement our own socket server because TSocketServer
     * from fcl-net not suitable for handling graceful shutdown
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSocket2Svr = class (TInjectableObject, IRunnable, IRunnableWithDataNotif)
    private
        fSocket : IListenSocket;
        fIoHandler : IIoHandler;
        fQueueSize : longint;
    public
        constructor create(
            const socket : IListenSocket;
            const ioHandler : IIoHandler;
            const queueSize : longint = DEFAULT_LISTEN_BACKLOG
        );
        destructor destroy(); override;

        (*!-----------------------------------------------
         * run socket server until terminated
         *-----------------------------------------------*)
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

uses

    TermSignalImpl;

    constructor TSocket2Svr.create(
        const socket : IListenSocket;
        const ioHandler : IIoHandler;
        const queueSize : longint = DEFAULT_LISTEN_BACKLOG
    );
    begin
        fSocket := socket;
        fIoHandler := ioHandler;
        fQueueSize := queueSize;
    end;

    destructor TSocket2Svr.destroy();
    begin
        fSocket := nil;
        fIoHandler := nil;
        inherited destroy();
    end;

    function TSocket2Svr.run() : IRunnable;
    begin
        fSocket.bind();
        fSocket.listen(fQueueSize);
        fIoHandler.handleConnection(fSocket, terminatePipeIn);
        result := self;
    end;

    (*!------------------------------------------------
     * set instance of class that will be notified when
     * data is available
     *-----------------------------------------------
     * @param dataListener, class that wish to be notified
     * @return true current instance
     *-----------------------------------------------*)
    function TSocket2Svr.setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;
    begin
        fIoHandler.setDataAvailListener(dataListener);
        result := self;
    end;

end.
