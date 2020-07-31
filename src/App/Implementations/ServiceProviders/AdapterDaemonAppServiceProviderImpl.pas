{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit AdapterDaemonAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    AppServiceProviderIntf,
    DaemonAppServiceProviderIntf,
    RunnableWithDataNotifIntf,
    ProtocolProcessorIntf,
    StdOutIntf,
    OutputBufferIntf,
    DecoratorAppServiceProviderImpl;

type

    {*------------------------------------------------
     * adapter class that can adapt IAppServiceProvider into
     * IDaemonAppServiceProvider
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TAdapterDaemonAppServiceProvider = class (TDecoratorAppServiceProvider, IDaemonAppServiceProvider)
    private
        fServer : IRunnableWithDataNotif;
        fProtocol : IProtocolProcessor;
        fOutputBuffer : IOutputBuffer;
    protected
        function buildServer() : IRunnableWithDataNotif; virtual;

        function buildProtocol() : IProtocolProcessor; virtual;

        function buildOutputBuffer() : IOutputBuffer; virtual;

    public
        constructor create(const actualSvc : IAppServiceProvider);
        destructor destroy(); override;

        function getServer() : IRunnableWithDataNotif;

        function getProtocol() : IProtocolProcessor;

        function getOutputBuffer() : IOutputBuffer;
    end;

implementation

uses

    StdInFromStreamImpl,
    NullStreamAdapterImpl,
    NullStdOutImpl,
    NullProtocolProcessorImpl,
    NullRunnableWithDataNotifImpl,
    OutputBufferImpl;

    constructor TAdapterDaemonAppServiceProvider.create(const actualSvc : IAppServiceProvider);
    begin
        inherited create(actualSvc);
        fServer := buildServer();
        fProtocol := buildProtocol();
        fOutputBuffer := buildOutputBuffer();
    end;

    destructor TAdapterDaemonAppServiceProvider.destroy();
    begin
        fServer := nil;
        fProtocol := nil;
        fOutputBuffer := nil;
        inherited destroy();
    end;

    function TAdapterDaemonAppServiceProvider.buildServer() : IRunnableWithDataNotif;
    begin
        result := TNullRunnableWithDataNotif.create();
    end;

    function TAdapterDaemonAppServiceProvider.buildProtocol() : IProtocolProcessor;
    begin
        result := TNullProtocolProcessor.create();
    end;

    function TAdapterDaemonAppServiceProvider.buildOutputBuffer() : IOutputBuffer;
    begin
        result := TOutputBuffer.create();
    end;

    function TAdapterDaemonAppServiceProvider.getServer() : IRunnableWithDataNotif;
    begin
        result := fServer;
    end;

    function TAdapterDaemonAppServiceProvider.getProtocol() : IProtocolProcessor;
    begin
        result := fProtocol;
    end;

    function TAdapterDaemonAppServiceProvider.getOutputBuffer() : IOutputBuffer;
    begin
        result := fOutputBuffer;
    end;
end.
