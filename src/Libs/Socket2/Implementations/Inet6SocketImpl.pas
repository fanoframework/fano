{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Inet6SocketImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Sockets,
    SocketOptsIntf,
    AbstractSocketImpl;

type

    (*!------------------------------------------------
     * class having capability setup IP socket support IPv6
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TInet6Socket = class (TAbstractSocket)
    private
        FInetAddr : TInetSockAddr6;
        fHost : string;
        fPort : word;
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
         * @param ahost, hostname or ip
         * @param aport, port
         * @param sockOpts class that can change socket options
         *-----------------------------------------------*)
        constructor create(
            const ahost : string;
            const aport : word;
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

    SysUtils;

    function TInet6Socket.createSocket() : longint;
    begin
        result := fpSocket(AF_INET6, SOCK_STREAM, 0);
    end;

    function TInet6Socket.getInfo() : string;
    begin
        result := format('%s:%d', [fHost, fPort]);
    end;

    (*!-----------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param host, hostname or ip
     * @param port, port
     *-----------------------------------------------*)
    constructor TInet6Socket.create(
        const ahost : string;
        const aport : word;
        const sockOpts : ISocketOpts
    );
    begin
        fHost := ahost;
        fPort := aport;
        inherited create(sockOpts);
    end;

    (*!-----------------------------------------------
     * bind socket to an socket address
     *-----------------------------------------------*)
    function TInet6Socket.doBind() : longint;
    begin
        FInetAddr.sin6_family := AF_INET6;
        FInetAddr.sin6_port := htons(FPort);
        FInetAddr.sin6_addr := StrToNetAddr6(FHost);
        result := fpBind(getSocket(), @FInetAddr, sizeof(FInetAddr));
    end;

    (*!-----------------------------------------------
     * accept connection
     *-------------------------------------------------
     * @param listenSocket, socket handle
     * @return client socket which data can be read
     *-----------------------------------------------*)
    function TInet6Socket.accept(listenSocket : longint) : longint;
    var addrLen : TSockLen;
    begin
        addrLen := sizeof(FInetAddr);
        result := fpAccept(listenSocket, @FInetAddr, @addrLen);
    end;

end.
