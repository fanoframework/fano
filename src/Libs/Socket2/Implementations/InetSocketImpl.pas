{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit InetSocketImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Sockets,
    SocketOptsIntf,
    AbstractSocketImpl;

type

    (*!------------------------------------------------
     * class having capability setup IP socket
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TInetSocket = class (TAbstractSocket)
    private
        FInetAddr : TInetSockAddr;
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

    function TInetSocket.createSocket() : longint;
    begin
        result := fpSocket(AF_INET, SOCK_STREAM, 0);
    end;

    function TInetSocket.getInfo() : string;
    begin
        result := format('%s:%d', [fHost, fPort]);
    end;

    (*!-----------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param host, hostname or ip
     * @param port, port
     *-----------------------------------------------*)
    constructor TInetSocket.create(
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
    function TInetSocket.doBind() : longint;
    begin
        FInetAddr.sin_family := AF_INET;
        FInetAddr.sin_port := htons(FPort);
        FInetAddr.sin_addr.s_addr := LongWord(StrToNetAddr(FHost));
        result := fpBind(getSocket(), @FInetAddr, sizeof(FInetAddr));
    end;

    (*!-----------------------------------------------
     * accept connection
     *-------------------------------------------------
     * @param listenSocket, socket handle
     * @return client socket which data can be read
     *-----------------------------------------------*)
    function TInetSocket.accept(listenSocket : longint) : longint;
    var addrLen : TSockLen;
    begin
        addrLen := sizeof(FInetAddr);
        result := fpAccept(listenSocket, @FInetAddr, @addrLen);
    end;

end.
