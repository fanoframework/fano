{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractSocketImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Sockets,
    SocketIntf,
    ListenSocketIntf,
    SocketOptsIntf;

type

    (*!------------------------------------------------
     * abstract class having capability setup listen socket
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractSocket = class abstract (TInterfacedObject, IListenSocket)
    private
        fSockOpts : ISocketOpts;
        fSocket : longint;
        procedure raiseExceptIfFailed(const socket : longint; const msg : string);
    protected
        (*!-----------------------------------------------
         * do actual bind socket to an socket address
         *-----------------------------------------------*)
        function doBind() : longint; virtual; abstract;

        (*!-----------------------------------------------
         * do actual socket creation
         *-----------------------------------------------*)
        function createSocket() : longint; virtual; abstract;

        (*!-----------------------------------------------
         * return textual information regarding socket
         *-----------------------------------------------*)
        function getInfo() : string; virtual; abstract;
    public

        (*!-----------------------------------------------
         * constructor
         *
         * @param sockOpts class that can change socket options
         *-----------------------------------------------*)
        constructor create(const sockOpts : ISocketOpts);

        (*!-----------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!-----------------------------------------------
         * return listen socket
         *-----------------------------------------------*)
        function getSocket() : longint;

        (*!-----------------------------------------------
         * bind socket to an socket address
         *-----------------------------------------------*)
        procedure bind();

        (*!-----------------------------------------------
        * accept connection
        *-------------------------------------------------
        * @param listenSocket, socket handle
        * @return client socket which data can be read
        *-----------------------------------------------*)
        function accept(listenSocket : longint) : longint; virtual; abstract;

        (*!-----------------------------------------------
         * start listen for incoming connection
         *
         * @param queueSize number of queue
         *-----------------------------------------------*)
        procedure listen(const queueSize : longint); virtual;
    end;

implementation

uses

    Errors,
    SocketConsts,
    ESockCreateImpl,
    ESockBindImpl,
    ESockListenImpl;

    procedure TAbstractSocket.raiseExceptIfFailed(const socket : longint; const msg : string);
    var errCode : longint;
    begin
        if socket = -1 then
        begin
            errCode := socketError();
            raise ESockCreate.createFmt(
                rsCreateFailed,
                [ msg, strError(errCode), errCode ]
            );
        end;
    end;

    (*!-----------------------------------------------
     * constructor
     *-----------------------------------------------*)
    constructor TAbstractSocket.create(const sockOpts : ISocketOpts);
    begin
        fSockOpts := sockOpts;
        fSocket := createSocket();
        raiseExceptIfFailed(fSocket, getInfo());
        fSockOpts.makeNonBlocking(fSocket);
    end;

    destructor TAbstractSocket.destroy();
    begin
        closeSocket(fSocket);
        fSockOpts := nil;
        inherited destroy();
    end;

    (*!-----------------------------------------------
     * create socket and return listen socket
     *-----------------------------------------------*)
    function TAbstractSocket.getSocket() : longint;
    begin
        result := fSocket;
    end;

    (*!-----------------------------------------------
     * bind socket to an socket address
     *-----------------------------------------------*)
    procedure TAbstractSocket.bind();
    var errCode : longint;
    begin
        if doBind() <> 0 then
        begin
            errCode := socketError();
            raise ESockBind.createFmt(
                rsBindFailed,
                [ getInfo(), strError(errCode), errCode ]
            );
        end;
    end;

    (*!-----------------------------------------------
     * start listen for incoming connection
     *
     * @param queueSize number of queue
     *-----------------------------------------------*)
    procedure TAbstractSocket.listen(const queueSize : longint);
    var errCode : longint;
    begin
        if fpListen(fSocket, queueSize) <> 0 then
        begin
            errCode := socketError();
            raise ESockListen.createFmt(
                rsSocketListenFailed,
                errCode,
                strError(errCode)
            );
        end;
    end;
end.
