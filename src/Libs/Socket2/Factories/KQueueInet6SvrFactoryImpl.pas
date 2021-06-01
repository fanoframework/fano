{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit KqueueInet6SvrFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableWithDataNotifIntf,
    SocketSvrFactoryIntf;

type
    (*------------------------------------------------
     * factory class for socket server using IP
     * and FreeBSD kqueue API with IPv6 support
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TKqueueInet6SvrFactory = class(TInterfacedObject, ISocketSvrFactory)
    private
        fHost : string;
        fPort : word;
    public
        constructor create(const aHost : string; const aPort : word);
        function build() : IRunnableWithDataNotif;
    end;

implementation

uses

    SocketOptsIntf,
    Socket2SvrImpl,
    SocketOptsImpl,
    Inet6SocketImpl,
    KQueueIoHandlerImpl;

    constructor TKQueueInet6SvrFactory.create(const aHost : string; const aPort : word);
    begin
        fHost := aHost;
        fPort := aPort;
    end;

    function TKqueueInet6SvrFactory.build() : IRunnableWithDataNotif;
    var sockOpts : ISocketOpts;
    begin
        sockOpts := TSocketOpts.create();
        result := TSocket2Svr.create(
            TInet6Socket.create(fHost, fPort, sockOpts),
            TKQueueIoHandler.create(sockOpts)
        );
    end;

end.
