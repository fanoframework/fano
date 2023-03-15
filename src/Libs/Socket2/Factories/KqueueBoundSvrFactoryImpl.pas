{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit KqueueBoundSvrFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableWithDataNotifIntf,
    SocketSvrFactoryIntf;

type
    (*------------------------------------------------
     * factory class for socket server using bound
     * socket and FreeBSD kqueue API
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TKqueueBoundSvrFactory = class (TInterfacedObject, ISocketSvrFactory)
    private
        fListenSocket : longint;
    public
        constructor create(const listenSocket : longint);
        function build() : IRunnableWithDataNotif;
    end;

implementation

uses

    SocketOptsIntf,
    Socket2SvrImpl,
    SocketOptsImpl,
    BoundSocketImpl,
    KqueueIoHandlerImpl;

    constructor TKqueueBoundSvrFactory.create(const listenSocket : longint);
    begin
        fListenSocket := listenSocket;
    end;

    function TKqueueBoundSvrFactory.build() : IRunnableWithDataNotif;
    var sockOpts : ISocketOpts;
    begin
        sockOpts := TSocketOpts.create();
        result := TSocket2Svr.create(
            TBoundSocket.create(fListenSocket, sockOpts),
            TKqueueIoHandler.create(sockOpts)
        );
    end;

end.
