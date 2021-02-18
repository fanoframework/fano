{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit MhdAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableWithDataNotifIntf,
    DaemonAppServiceProviderIntf,
    ProtocolAppServiceProviderImpl,
    MhdSvrConfigTypes;

type

    {*------------------------------------------------
     * class having capability to
     * register one or more service factories that use
     * libmicrohttpd
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TMhdAppServiceProvider = class (TProtocolAppServiceProvider)
    private
        fServer : IRunnableWithDataNotif;
    public
        constructor create(
            const actualSvc : IDaemonAppServiceProvider;
            const svrConfig : TMhdSvrConfig
        );
        destructor destroy(); override;
        function getServer() : IRunnableWithDataNotif; override;
    end;

implementation

uses

    MhdConnectionAwareIntf,
    MhdProcessorImpl,
    MhdStdOutWriterImpl;

    constructor TMhdAppServiceProvider.create(
        const actualSvc : IDaemonAppServiceProvider;
        const svrConfig : TMhdSvrConfig
    );
    begin
        inherited create(actualSvc);
        fStdOut := TMhdStdOutWriter.create();
        fProtocol := TMhdProcessor.create(fStdOut as IMhdConnectionAware, svrConfig);
        //TMhdProcessor also act as server
        fServer := fProtocol as IRunnableWithDataNotif;
    end;

    destructor TMhdAppServiceProvider.destroy();
    begin
        fServer := nil;
        inherited destroy();
    end;

    function TMhdAppServiceProvider.getServer() : IRunnableWithDataNotif;
    begin
        result := fServer;
    end;

end.
