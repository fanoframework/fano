{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit EpollInetSvrFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableWithDataNotifIntf,
    SocketSvrFactoryIntf;

type
    (*------------------------------------------------
     * factory class for socket server using IP
     * and Linux epoll API
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TEpollInetSvrFactory = class(TInterfacedObject, ISocketSvrFactory)
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
    EpollIoHandlerImpl;

    constructor TEpollInetSvrFactory.create(const aHost : string; const aPort : word);
    begin
        fHost := aHost;
        fPort := aPort;
    end;

    function TEpollInetSvrFactory.build() : IRunnableWithDataNotif;
    var sockOpts : ISocketOpts;
    begin
        sockOpts := TSocketOpts.create();
        result := TSocket2Svr.create(
            TInetSocket.create(fHost, fPort, sockOpts),
            TEpollIoHandler.create(sockOpts)
        );
    end;

end.
