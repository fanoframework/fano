{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit BoundSvrFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableWithDataNotifIntf,
    SocketSvrFactoryIntf;

type
    (*------------------------------------------------
     * factory class for socket server using bound socket
     * and select()
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TBoundSvrFactory = class (TInterfacedObject, ISocketSvrFactory)
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
    SelectIoHandlerImpl;

    constructor TBoundSvrFactory.create(const listenSocket : longint);
    begin
        fListenSocket := listenSocket;
    end;

    function TBoundSvrFactory.build() : IRunnableWithDataNotif;
    var sockOpts : ISocketOpts;
    begin
        sockOpts := TSocketOpts.create();
        result := TSocket2Svr.create(
            TBoundSocket.create(fListenSocket, sockOpts),
            TSelectIoHandler.create(sockOpts)
        );
    end;

end.
