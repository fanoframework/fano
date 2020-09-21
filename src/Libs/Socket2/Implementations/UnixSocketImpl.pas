{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UnixSocketImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Sockets,
    SocketOptsIntf,
    AbstractSocketImpl;

type

    (*!------------------------------------------------
     * class having capability setup Unix socket
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUnixSocket = class (TAbstractSocket)
    private
        fSocketFile : string;
        FUnixAddr : TUnixSockAddr;
        fSocketAddrLen : TSockLen;
    protected
        function createSocket() : longint; override;

        (*!-----------------------------------------------
         * return textual information regarding socket
         *-----------------------------------------------*)
        function getInfo() : string; override;

        (*!-----------------------------------------------
         * bind socket to socket address
         *-----------------------------------------------*)
        function doBind() : longint; override;
    public
        (*!-----------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param filename socket filename
         * @param sockOpts class that can change socket options
         *-----------------------------------------------*)
        constructor create(
            const filename : string;
            const sockOpts : ISocketOpts
        );

        (*!-----------------------------------------------
        * accept connection
        *-------------------------------------------------
        * @param listenSocket, socket handle
        * @return client socket which data can be read
        *-----------------------------------------------*)
        function accept(listenSocket : longint) : longint; override;
    end;

implementation

uses

    BaseUnix,
    Unix;

    function TUnixSocket.createSocket() : longint;
    begin
        result := fpSocket(AF_UNIX, SOCK_STREAM, 0);
    end;

    function TUnixSocket.getInfo() : string;
    begin
        result := fSocketFile;
    end;

    (*!-----------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param filename socket filename
     * @param sockOpts class that can change socket options
     *-----------------------------------------------*)
    constructor TUnixSocket.create(
        const filename : string;
        const sockOpts : ISocketOpts
    );
    begin
        fSocketFile := filename;
        inherited create(sockOpts);
    end;

    (*!-----------------------------------------------
     * replacement for str2UnixSockAddr() which marked
     * as deprecated
     *-----------------------------------------------*)
    procedure StrToUnixAddr(const addr : string; var sockAddr : TUnixSockAddr; var len:longint);
    begin
        move(addr[1], sockAddr.Path, length(addr));
        sockAddr.Family := AF_UNIX;
        sockAddr.Path[length(addr)] := #0;
        len := length(addr) + 3;
    end;

    (*!-----------------------------------------------
     * bind socket to socket address
     *-----------------------------------------------*)
    function TUnixSocket.doBind() : longInt;
    var addrLen  : longint;
    begin
        StrToUnixAddr(fSocketFile, FUnixAddr, addrLen);
        result := fpBind(getSocket(), @FUnixAddr, addrLen);
        fSocketAddrLen := addrLen;
    end;

    (*!-----------------------------------------------
     * accept connection
     *-------------------------------------------------
     * @param listenSocket, socket handle
     * @return client socket which data can be read
     *-----------------------------------------------*)
    function TUnixSocket.accept(listenSocket : longint) : longint;
    var addrLen : TSockLen;
    begin
        addrLen := fSocketAddrLen;
        result := fpAccept(listenSocket, @FUnixAddr, @addrLen);
        fSocketAddrLen := addrLen;
    end;

end.
