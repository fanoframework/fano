{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SelectIoHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Sockets,
    IoHandlerIntf,
    DataAvailListenerIntf,
    ListenSocketIntf,
    StreamAdapterIntf,
    SocketOptsIntf,
    AbstractIoHandlerImpl,
    BaseUnix,
    Unix;

type

    (*!-----------------------------------------------
     * I/O handler implementation which use select()
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSelectIoHandler = class(TAbstractIoHandler)
    private
        fTimeoutVal : TTimeVal;

        (*!-----------------------------------------------
         * convert timeout in millisecond to TTimeVal record
         *-------------------------------------------------
         * @param timeoutInMs, timeout in millisecond
        *-----------------------------------------------*)
        function getTimeout(const timeoutInMs : integer) : TTimeVal;


        (*!-----------------------------------------------
         * accept all incoming connection until no more pending
         * connection available
         *-------------------------------------------------
         * @param listenSocket, listen socket handle
         * @param maxHandle, highest handle
         * @param origFds, original file descriptor set
         *-----------------------------------------------*)
        procedure acceptAllConnections(
            const listenSocket : IListenSocket;
            var maxHandle : longint;
            var origFds : TFDSet
        );

        (*!-----------------------------------------------
         * called when client connection is established
         *-------------------------------------------------
         * @param clientSocket, socket handle where data can be read
         *-----------------------------------------------*)
        function handleClientConnection(clientSocket : longint) : boolean;

        (*!-----------------------------------------------
         * initialize file descriptor set for listening
         * socket and also termination pipe
         *-------------------------------------------------
         * @param listenSocketFd, socket handle
         * @param pipeIn, pipe input handle
         * @return file descriptor set
         *-----------------------------------------------*)
        function initFileDescSet(listenSocketFd : longint; pipeIn : longint) : TFDSet;

        (*!-----------------------------------------------
         * find file descriptor with biggest value
         *-------------------------------------------------
         * @param listenSocket, socket handle
         * @param pipeIn, pipe input handle
         * @return highest handle
         *-----------------------------------------------*)
        function getHighestHandle(listenSocketFd : longint; pipeIn : longint) : longint;

        (*!-----------------------------------------------
         * handle when one or more file descriptor is ready for I/O
         *-------------------------------------------------
         * @param listenSocket, listen socket handle
         * @param pipeIn, terminate pipe input handle
         * @param readfds, file descriptor set
         * @param totDesc, number of file descriptor ready for I/O
         * @param maxHandle, highest handle
         * @param origFds, original file descriptor set
         * @param terminated, set true if we should terminate
         *-----------------------------------------------*)
        procedure handleFileDescriptorIOReady(
            listenSocket : IListenSocket;
            pipeIn : longint;
            const readfds : TFDSet;
            var totDesc : longint;
            var maxHandle : longint;
            var origFds : TFDSet;
            var terminated : boolean
        );

        (*!-----------------------------------------------
         * add client socket to monitored set
         *-------------------------------------------------
         * @param fds, file descriptor to be added
         * @param maxHandle, highest handle
         * @param origFds, original file descriptor set
         *-----------------------------------------------*)
        procedure addToMonitoredSet(
            const fds : longint;
            var maxHandle : longint;
            var origFds : TFDSet
        );

        (*!-----------------------------------------------
         * remove client socket from monitored set
         *-------------------------------------------------
         * @param fds, file descriptor to be removed
         * @param maxHandle, highest handle
         * @param origFds, original file descriptor set
         *-----------------------------------------------*)
        procedure removeFromMonitoredSet(
            const fds : longint;
            var maxHandle : longint;
            var origFds : TFDSet
        );


    public
        constructor create(
            const sockOpts : ISocketOpts;
            const timeoutInMs : integer = 30000
        );

        (*!-----------------------------------------------
         * handle incoming connection until terminated
         *------------------------------------------------
         * @param listenSocket listen socket
         * @param termPipeIn termination pipe in file descriptor
         *-----------------------------------------------*)
        procedure handleConnection(const listenSocket : IListenSocket; termPipeIn : longint); override;
    end;

implementation

uses

    SysUtils,
    Errors,
    SocketConsts,
    ESockWouldBlockImpl,
    ESockErrorImpl,
    StreamAdapterImpl,
    SockStreamImpl,
    CloseableIntf,
    StreamIdIntf,
    CloseableStreamImpl,
    DateUtils;

    constructor TSelectIoHandler.create(
        const sockOpts : ISocketOpts;
        const timeoutInMs : integer = 30000
    );
    begin
        inherited create(sockOpts, timeoutInMs);
        fTimeoutVal := getTimeOut(timeoutInMs);
    end;

    (*!-----------------------------------------------
     * convert timeout in millisecond to TTimeVal record
     *-------------------------------------------------
     * @param timeoutInMs, timeout in millisecond
     *-----------------------------------------------*)
    function TSelectIoHandler.getTimeout(const timeoutInMs : integer) : TTimeVal;
    begin
        //get microsecond from millisecond
        result.tv_usec := (timeoutInMs mod 1000) * 1000;
        //get seconds from millisecond
        result.tv_sec := timeoutInMs div 1000;
    end;

    (*!-----------------------------------------------
     * initialize file descriptor set for listening
     * socket and also termination pipe
     *-------------------------------------------------
     * @param listenSocketFd, socket handle
     * @param pipeIn, pipe input handle
     * @return file descriptor set
     *-----------------------------------------------*)
    function TSelectIoHandler.initFileDescSet(listenSocketFd : longint; pipeIn : longint) : TFDSet;
    begin
        //initialize struct and reset all file descriptors
        result := default(TFDSet);
        fpFD_ZERO(result);

        //add listenSocket to set of read file descriptor we need to monitor
        //so we know if there something happen with listening socket
        fpFD_SET(listenSocketFd, result);

        //also add termPipeIn so we get notified if we get signal to terminate
        fpFD_SET(pipeIn, result);
    end;

    (*!-----------------------------------------------
     * find file descriptor with biggest value
     *-------------------------------------------------
     * @param listenSocketFd, socket handle
     * @param pipeIn, pipe input handle
     * @return highest handle
     *-----------------------------------------------*)
    function TSelectIoHandler.getHighestHandle(listenSocketFd : longint; pipeIn : longint) : longint;
    begin
        //find file descriptor with biggest value
        result := 0;
        if (listenSocketFd > result) then
        begin
            result := listenSocketFd;
        end;

        if (pipeIn > result) then
        begin
            result := pipeIn;
        end;
    end;

    (*!-----------------------------------------------
     * add file descriptor to monitored set
     *-------------------------------------------------
     * @param fds, file descriptor to be added
     * @param maxHandle, highest handle
     * @param origFds, original file descriptor set
     *-----------------------------------------------*)
    procedure TSelectIoHandler.addToMonitoredSet(
        const fds : longint;
        var maxHandle : longint;
        var origFds : TFDSet
    );
    begin
        fpFD_SET(fds, origFds);
        if fds > maxHandle then
        begin
            maxHandle := fds;
        end;
    end;

    (*!-----------------------------------------------
     * remove file descriptor from monitored set
     *-------------------------------------------------
     * @param fds, file descriptor to be removed
     * @param maxHandle, highest handle
     * @param origFds, original file descriptor set
     *-----------------------------------------------*)
    procedure TSelectIoHandler.removeFromMonitoredSet(
        const fds : longint;
        var maxHandle : longint;
        var origFds : TFDSet
    );
    begin
        fpFD_CLR(fds, origFds);
        if (fds = maxHandle) then
        begin
            //if we get here then we remove biggest file descriptor,
            //update maxHandle to lower biggest file descriptor in set
            while (fpFD_ISSET(maxHandle, origFds) = 0) do
            begin
                dec(maxHandle);
            end;
        end;
    end;


    (*!-----------------------------------------------
     * accept all incoming connection until no more pending
     * connection available
     *-------------------------------------------------
     * @param listenSocket, listen socket handle
     * @param maxHandle, highest handle
     * @param origFds, original file descriptor set
     *-----------------------------------------------*)
    procedure TSelectIoHandler.acceptAllConnections(
        const listenSocket : IListenSocket;
        var maxHandle : longint;
        var origFds : TFDSet
    );
    var clientSocket : longint;
    begin
        repeat
            //we have something with listening socket, it means there is
            //new connection coming, accept it
            clientSocket := listenSocket.accept(listenSocket.fd);

            if (clientSocket < 0) then
            begin
                handleAcceptError();
            end else
            begin
                fSockOpts.makeNonBlocking(clientSocket);
                //add client socket to be monitored for I/O
                addToMonitoredSet(clientSocket, maxHandle, origFds);
            end;
        until (clientSocket < 0);
    end;


    (*!-----------------------------------------------
     * handle when one or more file descriptor is ready for I/O
     *-------------------------------------------------
     * @param listenSocket, listen socket handle
     * @param pipeIn, terminate pipe input handle
     * @param readfds, file descriptor set
     * @param terminated, set true if we should terminate
     *-----------------------------------------------*)
    procedure TSelectIoHandler.handleFileDescriptorIOReady(
        listenSocket : IListenSocket;
        pipeIn : longint;
        const readfds : TFDSet;
        var totDesc : longint;
        var maxHandle : longint;
        var origFds : TFDSet;
        var terminated : boolean
    );
    var fds : longint;
    begin
        for fds := 0 to maxHandle do
        begin
            if fpFD_ISSET(fds, readfds) > 0 then
            begin
                if fds = pipeIn then
                begin
                    //we get termination signal, just read until no more
                    //bytes and quit
                    readPipe(pipeIn);
                    terminated := true;
                    break;
                end else
                if fds = listenSocket.fd then
                begin
                    //we have something with listening socket, it means there is
                    //new connection coming, accept it
                    acceptAllConnections(listenSocket, maxHandle, origFds);
                end else
                begin
                    //if we get here then it must be from one or
                    //more client connections
                    if handleClientConnection(fds) then
                    begin
                        removeFromMonitoredSet(fds, maxHandle, origFds);
                    end;
                end;

                dec(totDesc);
                if (totDesc <= 0) then
                begin
                    //if we get here, it means all file descriptors ready for I/O
                    //has been processed, so we can exit loop early
                    break;
                end;
            end;
        end;
    end;

    (*!-----------------------------------------------
     * handle incoming connection until terminated
     *-----------------------------------------------*)
    procedure TSelectIoHandler.handleConnection(const listenSocket : IListenSocket; termPipeIn : longint);
    var origfds, readfds : TFDSet;
        highestHandle : longint;
        terminated : boolean;
    var totDesc : longint;
        aTimeoutVal : TTimeVal;
    begin
        //find file descriptor with biggest value
        highestHandle := getHighestHandle(listenSocket.fd, termPipeIn);
        origfds := initFileDescSet(listenSocket.fd, termPipeIn);
        terminated := false;
        repeat
            //need to reset readfds, timeout as they are changed by select()
            readfds := origfds;
            aTimeoutVal := fTimeoutVal;

            //wait until something happen in
            //listenSocket or termPipeIn or client connection or timeout
            totDesc := fpSelect(highestHandle + 1, @readfds, nil, nil, @aTimeoutVal);
            if totDesc > 0 then
            begin
                //one or more file descriptors is ready for I/O, check further
                handleFileDescriptorIOReady(
                    listenSocket,
                    termPipeIn,
                    readfds,
                    totDesc,
                    highestHandle,
                    origfds,
                    terminated
                );
            end else
            if totDesc = 0 then
            begin
                handleTimeout();
            end;
        until terminated;
    end;

    (*!-----------------------------------------------
     * called when client connection is allowed
     *-------------------------------------------------
     * @param clientSocket, socket handle where data can be read
     *-----------------------------------------------*)
    function TSelectIoHandler.handleClientConnection(clientSocket : longint) : boolean;
    var aStream : TCloseableStream;
        streamAdapt : IStreamAdapter;
        closeableStr : ICloseable;
        streamId : IStreamId;
    begin
        result := true;
        if (assigned(fDataAvailListener)) then
        begin
            aStream := TCloseableStream.create(
                clientSocket,
                getSockStream(clientSocket)
            );
            streamAdapt := aStream;
            closeableStr := aStream;
            streamId := aStream;
            result := fDataAvailListener.handleData(streamAdapt, self, closeableStr, streamId);
        end;
    end;

end.
