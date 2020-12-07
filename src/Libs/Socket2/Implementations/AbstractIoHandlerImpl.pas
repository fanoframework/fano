{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractIoHandlerImpl;

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
    BaseUnix,
    Unix;

type

    (*!-----------------------------------------------
     * Base I/O handler implementation
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractIoHandler = class abstract (TInterfacedObject, IIoHandler)
    protected
        fTimeoutInMs : integer;
        fSockOpts : ISocketOpts;
        fDataAvailListener : IDataAvailListener;

        procedure handleTimeout(); virtual;
        procedure handleAcceptError();

        (*!-----------------------------------------------
         * read terminate pipe in
         * @param pipeIn, terminate pipe input handle
         *-----------------------------------------------*)
        procedure readPipe(const pipeIn : longint);

        (*!-----------------------------------------------
         * get stream from socket
         *-------------------------------------------------
         * @param clientSocket, socket handle
         * @return stream of socket
         *-----------------------------------------------*)
        function getSockStream(clientSocket : longint) : IStreamAdapter; virtual;

    public
        constructor create(
            const sockOpts : ISocketOpts;
            const timeoutInMs : integer = 30000
        );
        destructor destroy(); override;

        (*!-----------------------------------------------
         * handle incoming connection until terminated
         *------------------------------------------------
         * @param listenSocket listen socket
         * @param termPipeIn termination pipe in file descriptor
         *-----------------------------------------------*)
        procedure handleConnection(const listenSocket : IListenSocket; termPipeIn : longint); virtual; abstract;

        (*!------------------------------------------------
         * set instance of class that will be notified when
         * data is available
         *-----------------------------------------------
         * @param dataListener, class that wish to be notified
         * @return true current instance
         *-----------------------------------------------*)
        function setDataAvailListener(const dataListener : IDataAvailListener) : IIoHandler;
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
    DateUtils;

    constructor TAbstractIoHandler.create(
        const sockOpts : ISocketOpts;
        const timeoutInMs : integer = 30000
    );
    begin
        fSockOpts := sockOpts;
        fDataAvailListener := nil;
        fTimeoutInMs := timeoutInMs;
    end;

    destructor TAbstractIoHandler.destroy();
    begin
        fDataAvailListener := nil;
        fSockOpts := nil;
        inherited destroy();
    end;

    procedure TAbstractIoHandler.handleAcceptError();
    var errCode : longint;
    begin
        errCode := socketError();
        if not ((errCode = ESysEWOULDBLOCK) or
            (errCode = ESysEAGAIN) or
            (errCode = ESysEINTR) or
            (errCode = EsysECONNABORTED)) then
        begin
            raise ESockError.createFmt(
                rsSocketError,
                errCode,
                strError(errCode)
            );
        end;

        //if we get here, it mostly because nonblocking listening socket is
        //trying to accept client connection
        //but client connection aborted or
        //signal is caught
    end;

    (*!-----------------------------------------------
     * get stream from socket
     *-------------------------------------------------
     * @param clientSocket, socket handle
     * @return stream of socket
     *-----------------------------------------------*)
    function TAbstractIoHandler.getSockStream(clientSocket : longint) : IStreamAdapter;
    begin
        result := TStreamAdapter.create(TSockStream.create(clientSocket));
    end;

    (*!------------------------------------------------
     * set instance of class that will be notified when
     * data is available
     *-----------------------------------------------
     * @param dataListener, class that wish to be notified
     * @return true current instance
    *-----------------------------------------------*)
    function TAbstractIoHandler.setDataAvailListener(const dataListener : IDataAvailListener) : IIoHandler;
    begin
        fDataAvailListener := dataListener;
        result := self;
    end;

    (*!-----------------------------------------------
     * read terminate pipe in
     * @param pipeIn, terminate pipe input handle
     *-----------------------------------------------*)
    procedure TAbstractIoHandler.readPipe(const pipeIn : longint);
    var ch : char;
        res, err : longint;
    begin
        //we get termination signal, just read until no more
        //bytes and quit
        err := 0;
        repeat
            res := fpRead(pipeIn, @ch, 1);
            if (res = -1) then
            begin
                err := socketError();
                //pipeIn is nonblocking, so read() may failed with
                //EsysEWOULDBLOCK or EsysEAGAIN, in that case just quit loop
                //we will retry read pipeIn in next iteration
                if not ((err = ESysEAGAIN) or (err = EsysEWOULDBLOCK)) then
                begin
                    //if we get here, something is wrong
                    raise ESockError.createFmt(rsSocketError, err, strError(err));
                end;
            end;
        until (res > 0) or (err = ESysEAGAIN) or (err = EsysEWOULDBLOCK);
    end;

    procedure TAbstractIoHandler.handleTimeout();
    begin
        //do something when timeout
        //TODO: remove too long idle connection
    end;
end.
