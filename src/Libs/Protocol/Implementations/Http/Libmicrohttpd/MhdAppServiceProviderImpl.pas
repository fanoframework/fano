{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit MhdAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableWithDataNotifIntf,
    DaemonAppServiceProviderIntf,
    DaemonAppServiceProviderImpl,
    MhdSvrConfigTypes;

type

    {*------------------------------------------------
     * class having capability to
     * register one or more service factories that use
     * libmicrohttpd
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TMhdAppServiceProvider = class (TDaemonAppServiceProvider)
    private
        fSvrConfig : TMhdSvrConfig
    protected
        function buildServer() : IRunnableWithDataNotif; override;

        function buildProtocol() : IProtocolProcessor; override;

        function buildStdOut(const ctnr : IDependencyContainer) : IStdOut; override;
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
        const svrConfig : TMhdSvrConfig
    );
    begin
        inherited create();
        fSvrConfig := svrConfig;
    end;

    function TMhdAppServiceProvider.buildServer() : IRunnableWithDataNotif;
    begin
        //TMhdProcessor also act as server
        result := fProtocol as IRunnableWithDataNotif;
    end;

    function TMhdAppServiceProvider.buildProtocol() : IProtocolProcessor;
    begin
        result := TMhdProcessor.create(fStdOut as IMhdConnectionAware, svrConfig);
        //TMhdProcessor also act as server
        fServer := result as IRunnableWithDataNotif;
    end;

    function TMhdAppServiceProvider.buildStdOut(const ctnr : IDependencyContainer) : IStdOut;
    begin
        result := TMhdStdOutWriter.create();
    end;

end.
