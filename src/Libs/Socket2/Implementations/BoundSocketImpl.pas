{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BoundSocketImpl;

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
    TBoundSocket = class (TAbstractSocket)
    private
        fListenSocket : longint;
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
         * @param listenSocket bound socket
         *-----------------------------------------------*)
        constructor create(
            const listenSocket : longint;
            const sockOpts : ISocketOpts
        );

        (*!-----------------------------------------------
        * accept connection
        *-------------------------------------------------
        * @param listenSocket, socket handle
        * @return client socket which data can be read
        *-----------------------------------------------*)
        function accept(listenSocket : longint) : longint; override;

        (*!-----------------------------------------------
         * start listen for incoming connection
         *
         * @param queueSize number of queue
         *-----------------------------------------------*)
        procedure listen(const queueSize : longint); override;
    end;

implementation

uses

    SysUtils;

    function TBoundSocket.createSocket() : longint;
    begin
        result := fListenSocket;
    end;

    function TBoundSocket.getInfo() : string;
    begin
        result := format('Bound socket %d', [fListenSocket]);
    end;

    (*!-----------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param filename socket filename
     *-----------------------------------------------*)
    constructor TBoundSocket.create(
        const listenSocket : longint;
        const sockOpts : ISocketOpts
    );
    begin
        fListenSocket := listenSocket;
        inherited create(sockOpts);
    end;

    (*!-----------------------------------------------
     * bind socket to socket address
     *-----------------------------------------------*)
    function TBoundSocket.doBind() : longint;
    begin
        //intentionally does nothing as listenSocket is assumed already bound
        result := 0;
    end;

    (*!-----------------------------------------------
     * accept connection
     *-------------------------------------------------
     * @param listenSocket, socket handle
     * @return client socket which data can be read
     *-----------------------------------------------*)
    function TBoundSocket.accept(listenSocket : longint) : longint;
    begin
        result := fpAccept(listenSocket, nil, nil);
    end;

    (*!-----------------------------------------------
     * start listen for incoming connection
     *
     * @param queueSize number of queue
     *-----------------------------------------------*)
    procedure TBoundSocket.listen(const queueSize : longint);
    begin
        //intentionally does nothing as listenSocket is assumed already bound and listen
    end;

end.
