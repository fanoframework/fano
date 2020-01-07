{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EpollSocketSvrImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Sockets,
    RunnableIntf,
    RunnableWithDataNotifIntf,
    DataAvailListenerIntf,
    StreamAdapterIntf,
    BaseUnix,
    Unix,
    Linux,
    LruConnectionQueueImpl;

type

    (*!-----------------------------------------------
     * Socket server implementation which support graceful
     * shutdown when receive SIGTERM/SIGINT signal and also
     * allow for keeping client connection open if required
     * This class using Linux epoll API to monitor file descriptors
     *----------------------------------------------------
     * We implement our own socket server because TSocketServer
     * from fcl-net not suitable for handling graceful shutdown
     *-------------------------------------------------
     * @todo Refactor as this class similar to TSocketSvr
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TEpollSocketSvr = class(TInterfacedObject, IRunnable, IRunnableWithDataNotif)
    private
        {$IFDEF CLOSE_IDLE_CONNECTIONS}
        fLruConnectionQueue : TLruConnectionQueue;
        procedure addToConnectionsQueue(fd : longint);
        procedure closeIdleConnections();
        {$ENDIF}

        procedure raiseExceptionIfAny();

        (*!-----------------------------------------------
         * accept all incoming connection until no more pending
         * connection available
         *-------------------------------------------------
         * @param epollFd, file descriptor returned from epoll_create()
         * @param listenSocket, listen socket handle
         *-----------------------------------------------*)
        procedure acceptAllConnections(
            const epollFd : longint;
            const listenSocket : longint
        );

        (*!-----------------------------------------------
         * read terminate pipe in
         * @param pipeIn, terminate pipe input handle
         *-----------------------------------------------*)
        procedure readPipe(const pipeIn : longint);

        (*!-----------------------------------------------
         * wait for connection
         *-------------------------------------------------
         * @param epollFd, file descriptor returned from epoll_create()
         * @param termPipeIn, terminate pipe in
         * @param listenSocket, listen socket
         * @param events, array of TEpoll_Event contained file descriptors
         * @param maxEvent, total item in events array
         *-----------------------------------------------*)
        procedure waitForConnection(
            const epollFd : longint;
            const termPipeIn : longint;
            const listenSocket : longint;
            const events : PEpoll_Event;
            const maxEvents : longint
        );

        (*!-----------------------------------------------
         * run wait for connection loop
         *-------------------------------------------------
         * @param epollFd, file descriptor returned from epoll_create()
         *-----------------------------------------------*)
        procedure runWaitConnection(const epollFd : longint);

        (*!-----------------------------------------------
         * called when client connection is established
         *-------------------------------------------------
         * @param epollFd, file descriptor returned from epoll_create()
         * @param clientSocket, socket handle where data can be read
         *-----------------------------------------------*)
        function handleClientConnection(
            const epollFd : longint;
            const clientSocket : longint
        ) : boolean;

        (*!-----------------------------------------------
         * handle when one or more file descriptor is ready for I/O
         *-------------------------------------------------
         * @param epollFd, file descriptor returned from epoll_create()
         * @param listenSocket, listen socket handle
         * @param pipeIn, terminate pipe input handle
         * @param totFd, total file descriptor ready for I/O
         * @param events, array of TEpoll_Event contained file descriptors
         * @param terminated, set true if we should terminate
         *-----------------------------------------------*)
        procedure handleFileDescriptorIOReady(
            const epollFd : longint;
            const listenSocket : longint;
            const pipeIn : longint;
            const totFd : longint;
            const events : PEpoll_Event;
            var terminated : boolean
        );

        (*!-----------------------------------------------
         * add file descriptor to monitored set
         *-------------------------------------------------
         * @param epollFd, file descriptor returned from epoll_create
         * @param fd, file descriptor to be added
         * @param flag, operation flag
         *-----------------------------------------------*)
        procedure addToMonitoredSet(const epollFd : longint; const fd : longint; const flag : cardinal);

        (*!-----------------------------------------------
         * remove file descriptor from monitored set
         *-------------------------------------------------
         * @param epollFd, file descriptor returned from epoll_create()
         * @param fd, file descriptor to be removed
         *-----------------------------------------------*)
        procedure removeFromMonitoredSet(const epollFd : longint; const fd : longint);

    protected
        fDataAvailListener : IDataAvailListener;
        fListenSocket : longint;
        fQueueSize : longint;
        fIdleTimeout : longint;
        fTimeoutVal : longint;

        (*!-----------------------------------------------
         * bind socket to an socket address
         *-----------------------------------------------*)
        procedure bind(); virtual; abstract;

        (*!-----------------------------------------------
         * begin listen socket
         *-----------------------------------------------*)
        procedure listen(); virtual;

        (*!-----------------------------------------------
         * handle incoming connection until terminated
         *-----------------------------------------------*)
        procedure handleConnection();

        (*!-----------------------------------------------
         * run shutdown sequence
         *-----------------------------------------------*)
        procedure shutdown(); virtual;

        (*!-----------------------------------------------
         * accept connection
         *-------------------------------------------------
         * @param listenSocket, socket handle created with fpSocket()
         * @return client socket which data can be read
         *-----------------------------------------------*)
        function accept(listenSocket : longint) : longint; virtual; abstract;

        (*!-----------------------------------------------
         * get stream from socket
         *-------------------------------------------------
         * @param clientSocket, socket handle
         * @return stream of socket
         *-----------------------------------------------*)
        function getSockStream(clientSocket : longint) : IStreamAdapter; virtual;
    public

        (*!-----------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param listenSocket, socket handle created with fpSocket()
         * @param queueSize, number of queue when listen, 5 = default of Berkeley Socket
         * @param timeoutInMs, waiting for I/O timeout in millisecond, default 30 seconds
         * @param idleTimeoutInMs, connection idle timeout in millisecond, default 60 seconds
         *-----------------------------------------------*)
        constructor create(
            listenSocket : longint;
            queueSize : longint = 5;
            timeoutInMs : integer = 30000;
            idleTimeoutInMs : longint = 60000
        );

        (*!-----------------------------------------------
         * destructor
         *-------------------------------------------------
         * @param listenSocket, socket handle created with fpSocket()
         * @param queueSize, number of queue when listen, 5 = default of Berkeley Socket
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!-----------------------------------------------
         * run socket server until terminated
         *-----------------------------------------------*)
        function run() : IRunnable; virtual;

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

    CloseableIntf,
    ESockListenImpl,
    ESockWouldBlockImpl,
    EEpollCreateImpl,
    ESockStreamImpl,
    StreamAdapterImpl,
    SockStreamImpl,
    CloseableStreamImpl,
    EpollCloseableImpl,
    EEpollCtlImpl,
    TermSignalImpl,
    SocketConsts,
    DateUtils,
    SysUtils,
    Errors,
    StreamIdIntf;

    procedure makeNonBlocking(fd: longint);
    var flags : integer;
    begin
        //read control flag and set pipe in to be non blocking
        flags := fpFcntl(fd, F_GETFL, 0);
        fpFcntl(fd, F_SETFl, flags or O_NONBLOCK);
    end;

    (*!-----------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param listenSocket, socket handle created with fpSocket()
     * @param queueSize, number of queue when listen, 5 = default of Berkeley Socket
     * @param timeoutInMs, waiting for I/O timeout in millisecond, default 30 seconds
     * @param idleTimeoutInMs, connection idle timeout in millisecond, default 60 seconds
     *-----------------------------------------------*)
    constructor TEpollSocketSvr.create(
        listenSocket : longint;
        queueSize : integer = 5;
        timeoutInMs : integer = 30000;
        idleTimeoutInMs : longint = 60000
    );
    begin
        {$IFDEF CLOSE_IDLE_CONNECTIONS}
        fLruConnectionQueue := TLruConnectionQueue.create();
        {$ENDIF}
        fListenSocket := listenSocket;
        fQueueSize := queueSize;
        fDataAvailListener := nil;
        makeNonBlocking(listenSocket);
    end;

    (*!-----------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TEpollSocketSvr.destroy();
    begin
        shutdown();
        {$IFDEF CLOSE_IDLE_CONNECTIONS}
        fLruConnectionQueue.free();
        {$ENDIF}
        inherited destroy();
    end;

    (*!-----------------------------------------------
     * begin listen socket
     * TODO: refactor as it is similar to TSocketSvr.listen()
     *-----------------------------------------------*)
    procedure TEpollSocketSvr.listen();
    var errCode : longint;
    begin
        if fpListen(fListenSocket, fQueueSize) <> 0 then
        begin
            errCode := socketError();
            raise ESockListen.createFmt(
                rsSocketListenFailed,
                errCode,
                strError(errCode)
            );
        end;
    end;

    procedure TEpollSocketSvr.raiseExceptionIfAny();
    var errno : longint;
    begin
        errno := socketError();
        if (errno = EsockEWOULDBLOCK) or (errno = EsysEAGAIN) then
        begin
            //if we get here, it mostly because socket is non blocking
            //but no pending connection, so just do nothing
        end else
        begin
            //TODO handle error
        end;
    end;

    (*!-----------------------------------------------
     * add file descriptor to monitored set
     *-------------------------------------------------
     * @param epollFd, file descriptor returned from epoll_create
     * @param fd, file descriptor to be added
     *-----------------------------------------------*)
    procedure TEpollSocketSvr.addToMonitoredSet(
        const epollFd : longint;
        const fd : longint;
        const flag : cardinal
    );
    var ev : TEpoll_Event;
        res : longint;
    begin
        ev.events := flag;
        ev.data.fd := fd;
        res := epoll_ctl(epollFd, EPOLL_CTL_ADD, fd, @ev);
        if (res < 0) then
        begin
            raise EEpollCtl.create(raEpollAddFileDescriptorFailed);
        end;
    end;

    (*!-----------------------------------------------
     * remove file descriptor from monitored set
     *-------------------------------------------------
     * @param epollFd, file descriptor returned from epoll_create()
     * @param fd, file descriptor to be removed
     *-----------------------------------------------*)
    procedure TEpollSocketSvr.removeFromMonitoredSet(
        const epollFd : longint;
        const fd : longint
    );
    var ev : TEpoll_Event;
    begin
        //for EPOLL_CTRL_DEL, epoll_event is ignored but
        //due to bug, Linux kernel < 2.6.9 requires non-NULL,
        //here we just give them although not used.
        ev.events := EPOLLIN;
        ev.data.fd := fd;
        epoll_ctl(epollFd, EPOLL_CTL_DEL, fd, @ev);
    end;

    {$IFDEF CLOSE_IDLE_CONNECTIONS}
    //turn off for now as this cause weird access violation sometime
    procedure TEpollSocketSvr.addToConnectionsQueue(fd : longint);
    var lruFds : TLruFileDesc;
    begin
        lruFds.fds := fd;
        lruFds.timestamp := DateTimeToUnix(now());
        fLruConnectionQueue.push(lruFds);
    end;

    procedure TEpollSocketSvr.closeIdleConnections();
    var lruFds : TLruFileDesc;
        nowTimestamp : int64;
    begin
        nowTimestamp := dateTimeToUnix(now());
        lruFds := fLruConnectionQueue.top();
        if (nowTimestamp - lruFds.timestamp > fIdleTimeout) then
        begin
            fLruConnectionQueue.pop();
            fpClose(lruFds.fds);
        end;
    end;
    {$ENDIF}

    (*!-----------------------------------------------
     * accept all incoming connection until no more pending
     * connection available
     *-------------------------------------------------
     * @param epollFd, file descriptor returned from epoll_create()
     * @param listenSocket, listen socket handle
     *-----------------------------------------------*)
    procedure TEpollSocketSvr.acceptAllConnections(
        const epollFd : longint;
        const listenSocket : longint
    );
    var clientSocket : longint;
    begin
        repeat
            //we have something with listening socket, it means there is
            //new connection coming, accept it
            clientSocket := accept(listenSocket);

            if (clientSocket < 0) then
            begin
                raiseExceptionIfAny();
            end else
            begin
                //TODO : improve FCGI parser so we can use non blocking socket
                //Turn off for now as our FCGI parser not suitable for
                //handling non blocking socket
                makeNonBlocking(clientSocket);

                //add client socket to be monitored for I/O read
                //note that before client socket is closed,
                //we will remove it from monitored set (see TEpollCloseable class)
                addToMonitoredSet(epollFd, clientSocket, EPOLLIN or EPOLLET);

                {$IFDEF CLOSE_IDLE_CONNECTIONS}
                addToConnectionsQueue(clientSocket);
                {$ENDIF}
            end;
        until (clientSocket < 0);
    end;

    (*!-----------------------------------------------
     * read terminate pipe in
     * @param pipeIn, terminate pipe input handle
     *-----------------------------------------------*)
    procedure TEpollSocketSvr.readPipe(const pipeIn : longint);
    var ch : char;
        res, err : longint;
    begin
        //we get termination signal, just read until no more
        //bytes and quit
        err := 0;
        repeat
            res := fpRead(pipeIn, @ch, 1);
            if (res < 0) then
            begin
                err := socketError();
            end;
        until (res = 0) or (err = ESysEAGAIN);
    end;

    (*!-----------------------------------------------
     * handle when one or more file descriptor is ready for I/O
     *-------------------------------------------------
     * @param epollFd, file descriptor returned from epoll_create()
     * @param listenSocket, listen socket handle
     * @param pipeIn, terminate pipe input handle
     * @param totFd, total file descriptor ready for I/O
     * @param events, array of TEpoll_Event contained file descriptors
     * @param terminated, set true if we should terminate
     *-----------------------------------------------*)
    procedure TEpollSocketSvr.handleFileDescriptorIOReady(
        const epollFd : longint;
        const listenSocket : longint;
        const pipeIn : longint;
        const totFd : longint;
        const events : PEpoll_Event;
        var terminated : boolean
    );
    var i, fd : longint;
    begin
        for i := 0 to totFd -1  do
        begin
            fd := events[i].data.fd;
            if (fd = pipeIn) then
            begin
                readPipe(pipeIn);
                terminated := true;
                break;
            end else
            if (fd = listenSocket) then
            begin
                //we have something with listening socket, it means there is
                //new connection coming, accept it
                acceptAllConnections(epollFd, listenSocket);
            end else
            begin
                //if we get here then it must be from one or
                //more client connections
                handleClientConnection(epollFd, fd);
            end;
        end;
    end;

    (*!-----------------------------------------------
     * wait for connection
     *-------------------------------------------------
     * @param epollFd, file descriptor returned from epoll_create()
     * @param termPipeIn, terminate pipe in
     * @param listenSocket, listen socket
     * @param events, array of TEpoll_Event contained file descriptors
     * @param maxEvent, total item in events array
     *-----------------------------------------------*)
    procedure TEpollSocketSvr.waitForConnection(
        const epollFd : longint;
        const termPipeIn : longint;
        const listenSocket : longint;
        const events : PEpoll_Event;
        const maxEvents : longint
    );
    var terminated : boolean;
        totFd : longint;
    begin
        addToMonitoredSet(epollFd, termPipeIn, EPOLLIN);
        addToMonitoredSet(epollFd, listenSocket, EPOLLIN);
        terminated := false;
        repeat
            //wait indefinitely until something happen in fListenSocket or epollTerminatePipeIn
            totFd := epoll_wait(epollFd, events, maxEvents, fTimeoutVal);
            if totFd > 0 then
            begin
                //one or more file descriptors is ready for I/O, check further
                handleFileDescriptorIOReady(
                    epollFd,
                    listenSocket,
                    termPipeIn,
                    totFd,
                    events,
                    terminated
                );
            end else
            if (totFd = 0) then
            begin
                //timeout reached.
                //For now, do nothing
            end else
            if (totFd < 0) then
            begin
                //we have error just terminate
                terminated := true;
            end;
            {$IFDEF CLOSE_IDLE_CONNECTIONS}
            closeIdleConnections();
            {$ENDIF}
        until terminated;
        removeFromMonitoredSet(epollFd, termPipeIn);
        removeFromMonitoredSet(epollFd, listenSocket);
    end;

    (*!-----------------------------------------------
     * run wait for connection loop
     *-------------------------------------------------
     * @param epollFd, file descriptor returned from epoll_create()
     *-----------------------------------------------*)
    procedure TEpollSocketSvr.runWaitConnection(const epollFd : longint);
    const MAX_EVENTS = 64;
    var events : PEpoll_event;
    begin
        getmem(events, MAX_EVENTS * sizeof(TEpoll_Event));
        try
            waitForConnection(
                epollFd,
                terminatePipeIn, //global pipe for terminate
                fListenSocket,
                events,
                MAX_EVENTS
            );
        finally
            freemem(events);
        end;
    end;

    (*!-----------------------------------------------
     * handle incoming connection until terminated
     *-------------------------------------------------
     * @throws EEpollCreate exception
     *-----------------------------------------------*)
    procedure TEpollSocketSvr.handleConnection();
    var epollFd : longint;
    begin
        epollFd := epoll_create(1024);

        if (epollFd < 0) then
        begin
            raise EEpollCreate.create(rsEpollInitFailed);
        end;

        runWaitConnection(epollFd);
        fpClose(epollFd);
    end;

    (*!-----------------------------------------------
     * get stream from socket
     *-------------------------------------------------
     * @param clientSocket, socket handle
     * @return stream of socket
     *-----------------------------------------------*)
    function TEpollSocketSvr.getSockStream(clientSocket : longint) : IStreamAdapter;
    begin
        result := TStreamAdapter.create(TSockStream.create(clientSocket));
    end;

    (*!-----------------------------------------------
     * called when client connection is allowed
     *-------------------------------------------------
     * @param epollFd, file descriptor returned from epoll_create()
     * @param clientSocket, socket handle where data can be read
     *-----------------------------------------------*)
    function TEpollSocketSvr.handleClientConnection(
        const epollFd : longint;
        const clientSocket : longint
    ) : boolean;
    var astream : IStreamAdapter;
        streamCloser : ICloseable;
    begin
        result := true;
        if (assigned(fDataAvailListener)) then
        begin
            astream := getSockStream(clientSocket);
            try
                //create instance which can remove client socket
                //from epoll monitoring and after that close socket
                streamCloser := TEpollCloseable.create(epollFd, clientSocket);
                try
                    try
                        fDataAvailListener.handleData(
                            astream,
                            self,
                            streamCloser,
                            streamCloser as IStreamId
                        );
                    except
                        on e: ESockStream do
                        begin
                            streamCloser.close();
                            raise;
                        end;
                    end;
                finally
                    streamCloser := nil;
                end;
            finally
                astream := nil;
            end;
        end;
    end;

    (*!------------------------------------------------
     * set instance of class that will be notified when
     * data is available
     *-----------------------------------------------
     * @param dataListener, class that wish to be notified
     * @return true current instance
    *-----------------------------------------------*)
    function TEpollSocketSvr.setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;
    begin
        fDataAvailListener := dataListener;
        result := self;
    end;

    procedure TEpollSocketSvr.shutdown();
    begin
        closeSocket(fListenSocket);
        fDataAvailListener := nil;
    end;

    function TEpollSocketSvr.run() : IRunnable;
    begin
        bind();
        listen();
        handleConnection();
        result := self;
    end;

end.
