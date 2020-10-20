{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit UnixSvrFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableWithDataNotifIntf,
    SocketSvrFactoryIntf;

type
    (*------------------------------------------------
     * factory class for socket server using Unix Domain
     * Socket and select()
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUnixSvrFactory = class (TInterfacedObject, ISocketSvrFactory)
    private
        fFilename : string;
    public
        constructor create(const aFilename : string);
        function build() : IRunnableWithDataNotif;
    end;

implementation

uses

    SocketOptsIntf,
    Socket2SvrImpl,
    SocketOptsImpl,
    UnixSocketImpl,
    SelectIoHandlerImpl;

    constructor TUnixSvrFactory.create(const aFilename : string);
    begin
        fFilename := aFilename;
    end;

    function TUnixSvrFactory.build() : IRunnableWithDataNotif;
    var sockOpts : ISocketOpts;
    begin
        sockOpts := TSocketOpts.create();
        result := TSocket2Svr.create(
            TUnixSocket.create(fFilename, sockOpts),
            TSelectIoHandler.create(sockOpts)
        );
    end;

end.
