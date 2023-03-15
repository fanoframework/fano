{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit KqueueInetSvrFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableWithDataNotifIntf,
    SocketSvrFactoryIntf;

type
    (*------------------------------------------------
     * factory class for socket server using IP
     * and FreeBSD kqueue API
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TKqueueInetSvrFactory = class(TInterfacedObject, ISocketSvrFactory)
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
    InetSocketImpl,
    KqueueIoHandlerImpl;

    constructor TKqueueInetSvrFactory.create(const aHost : string; const aPort : word);
    begin
        fHost := aHost;
        fPort := aPort;
    end;

    function TKqueueInetSvrFactory.build() : IRunnableWithDataNotif;
    var sockOpts : ISocketOpts;
    begin
        sockOpts := TSocketOpts.create();
        result := TSocket2Svr.create(
            TInetSocket.create(fHost, fPort, sockOpts),
            TKqueueIoHandler.create(sockOpts)
        );
    end;

end.
