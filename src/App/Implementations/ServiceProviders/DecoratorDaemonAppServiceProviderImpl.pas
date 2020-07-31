{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DecoratorDaemonAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DaemonAppServiceProviderIntf,
    RunnableWithDataNotifIntf,
    ProtocolProcessorIntf,
    StdOutIntf,
    OutputBufferIntf,
    DecoratorAppServiceProviderImpl;

type

    {*------------------------------------------------
     * class that having capability to
     * register one or more service factories
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TDecoratorDaemonAppServiceProvider = class (TDecoratorAppServiceProvider, IDaemonAppServiceProvider)
    protected
        fDaemonSvc : IDaemonAppServiceProvider;
    public
        constructor create(const actualSvc : IDaemonAppServiceProvider);
        destructor destroy(); override;

        function getServer() : IRunnableWithDataNotif; virtual;

        function getProtocol() : IProtocolProcessor; virtual;

        function getOutputBuffer() : IOutputBuffer; virtual;

        function getStdOut() : IStdOut; virtual;

    end;

implementation

uses

    StdInFromStreamImpl,
    NullStreamAdapterImpl,
    NullStdOutImpl,
    NullProtocolProcessorImpl,
    NullRunnableWithDataNotifImpl,
    OutputBufferImpl;

    constructor TDecoratorDaemonAppServiceProvider.create(const actualSvc : IDaemonAppServiceProvider);
    begin
        inherited create(actualSvc);
        fDaemonSvc := actualSvc;
    end;

    destructor TDecoratorDaemonAppServiceProvider.destroy();
    begin
        fDaemonSvc := nil;
        inherited destroy();
    end;

    function TDecoratorDaemonAppServiceProvider.getServer() : IRunnableWithDataNotif;
    begin
        result := fDaemonSvc.getServer();
    end;

    function TDecoratorDaemonAppServiceProvider.getProtocol() : IProtocolProcessor;
    begin
        result := fDaemonSvc.getProtocol();
    end;

    function TDecoratorDaemonAppServiceProvider.getOutputBuffer() : IOutputBuffer;
    begin
        result := fDaemonSvc.getOutputBuffer();
    end;

    function TDecoratorDaemonAppServiceProvider.getStdOut() : IStdOut;
    begin
        result := fDaemonSvc.getStdOut();
    end;
end.
