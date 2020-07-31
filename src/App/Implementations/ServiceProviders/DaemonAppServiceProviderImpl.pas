{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DaemonAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DaemonAppServiceProviderIntf,
    AppServiceProviderIntf,
    DependencyContainerIntf,
    ServiceProviderIntf,
    ErrorHandlerIntf,
    DispatcherIntf,
    EnvironmentIntf,
    StdInIntf,
    StdOutIntf,
    OutputBufferIntf,
    RouteMatcherIntf,
    RouterIntf,
    RunnableWithDataNotifIntf,
    ProtocolProcessorIntf,
    BasicAppServiceProviderImpl;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TDaemonAppServiceProvider = class abstract (TBasicAppServiceProvider, IDaemonAppServiceProvider)
    private
        fServer : IRunnableWithDataNotif;
        fProtocol : IProtocolProcessor;
    protected

        function buildServer() : IRunnableWithDataNotif; virtual;

        function buildProtocol() : IProtocolProcessor; virtual;

        function buildStdOut(const ctnr : IDependencyContainer) : IStdOut; override;

        function buildStdIn(const ctnr : IDependencyContainer) : IStdIn; override;
    public
        constructor create();
        destructor destroy(); override;

        function getServer() : IRunnableWithDataNotif;

        function getProtocol() : IProtocolProcessor;

    end;

implementation

uses

    StdInFromStreamImpl,
    NullStreamAdapterImpl,
    NullStdOutImpl,
    NullProtocolProcessorImpl,
    NullRunnableWithDataNotifImpl,
    OutputBufferImpl;

    constructor TDaemonAppServiceProvider.create();
    begin
        inherited create();
        fServer := buildServer();
        fProtocol := buildProtocol();
    end;

    destructor TDaemonAppServiceProvider.destroy();
    begin
        fServer := nil;
        fProtocol := nil;
        inherited destroy();
    end;

    function TDaemonAppServiceProvider.buildServer() : IRunnableWithDataNotif;
    begin
        result := TNullRunnableWithDataNotif.create();
    end;

    function TDaemonAppServiceProvider.buildProtocol() : IProtocolProcessor;
    begin
        result := TNullProtocolProcessor.create();
    end;

    function TDaemonAppServiceProvider.buildStdOut(const ctnr : IDependencyContainer) : IStdOut;
    begin
        result := TNullStdOut.create();
    end;

    function TDaemonAppServiceProvider.buildStdIn(const ctnr : IDependencyContainer) : IStdIn;
    begin
        result := TStdInFromStream.create(TNullStreamAdapter.create());
    end;

    function TDaemonAppServiceProvider.getServer() : IRunnableWithDataNotif;
    begin
        result := fServer;
    end;

    function TDaemonAppServiceProvider.getProtocol() : IProtocolProcessor;
    begin
        result := fProtocol;
    end;

end.
