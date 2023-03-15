{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit ServerAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DaemonAppServiceProviderIntf,
    RunnableWithDataNotifIntf,
    DecoratorDaemonAppServiceProviderImpl;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TServerAppServiceProvider = class (TDecoratorDaemonAppServiceProvider)
    private
        fServer : IRunnableWithDataNotif;
    public
        constructor create(
            const actualSvc : IDaemonAppServiceProvider;
            const svr : IRunnableWithDataNotif
        );
        destructor destroy(); override;

        function getServer() : IRunnableWithDataNotif; override;

    end;

implementation

    constructor TServerAppServiceProvider.create(
        const actualSvc : IDaemonAppServiceProvider;
        const svr : IRunnableWithDataNotif
    );
    begin
        inherited create(actualSvc);
        fServer := svr;
    end;

    destructor TServerAppServiceProvider.destroy();
    begin
        fServer := nil;
        inherited destroy();
    end;

    function TServerAppServiceProvider.getServer() : IRunnableWithDataNotif;
    begin
        result := fServer;
    end;

end.
