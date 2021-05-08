{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit ThreadProtocolAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyContainerIntf,
    ProtocolProcessorIntf,
    StdOutIntf,
    StdInIntf,
    ErrorHandlerIntf,
    DispatcherIntf,
    EnvironmentIntf,
    RouterIntf,
    RouteMatcherIntf,
    OutputBufferIntf,
    DaemonAppServiceProviderIntf,
    ProtocolAppServiceProviderImpl;

type

    {*------------------------------------------------
     * class having capability to
     * register one or more service factories for
     * application that handle multiple threads
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TThreadProtocolAppServiceProvider = class (TProtocolAppServiceProvider)
    private
        fThreadProtocol : IProtocolProcessor;
        fThreadSafeContainer : IDependencyContainer;
        fThreadSafeErrorHandler : IErrorHandler;
        fThreadSafeDispatcher : IDispatcher;
        fThreadSafeEnv : ICGIEnvironment;
        fThreadSafeStdIn : IStdIn;
        fThreadSafeStdOut : IStdOut;
        fThreadSafeRouter : IRouter;
        fThreadSafeRouteMatcher : IRouteMatcher;
        fThreadSafeOutputBuffer : IOutputBuffer;
    public
        constructor create(const actualSvc : IDaemonAppServiceProvider);
        destructor destroy(); override;

        function getContainer() : IDependencyContainer; override;

        function getErrorHandler() : IErrorHandler; override;

        function getDispatcher() : IDispatcher; override;

        function getEnvironment() : ICGIEnvironment; override;

        function getRouter() : IRouter; override;
        function getRouteMatcher() : IRouteMatcher; override;

        function getStdIn() : IStdIn; override;

        function getOutputBuffer() : IOutputBuffer; override;

        function getProtocol() : IProtocolProcessor; override;
        function getStdOut() : IStdOut; override;
    end;

implementation

uses

    ThreadProtocolProcessorImpl,
    ThreadSafeDependencyContainerImpl,
    ThreadSafeErrorHandlerImpl,
    ThreadSafeDispatcherImpl,
    ThreadSafeEnvironmentImpl,
    ThreadSafeStdInImpl,
    ThreadSafeStdOutImpl,
    ThreadSafeRouterImpl,
    ThreadSafeOutputBufferImpl;

    constructor TThreadProtocolAppServiceProvider.create(
        const actualSvc : IDaemonAppServiceProvider
    );
    begin
        inherited create(actualSvc);
        //wrap global instance with thread-safe implementation
        fThreadProtocol := TThreadProtocolProcessor.create(
            fDaemonSvc.getProtocol()
        );

        fThreadSafeContainer := TThreadSafeDependencyContainer.create(
            fDaemonSvc.getContainer()
        );

        fThreadSafeErrorHandler := TThreadSafeErrorHandler.create(
            fDaemonSvc.getErrorHandler()
        );

        fThreadSafeDispatcher := TThreadSafeDispatcher.create(
            fDaemonSvc.getDispatcher()
        );

        fThreadSafeEnv := TThreadSafeEnvironment.create(
            fDaemonSvc.getEnvironment()
        );

        fThreadSafeStdIn := TThreadSafeStdIn.create(
            fDaemonSvc.getStdIn()
        );

        fThreadSafeStdOut := TThreadSafeStdOut.create(fDaemonSvc.getStdOut());
        fThreadSafeRouter := TThreadSafeRouter.create(
            fDaemonSvc.getRouter(),
            fDaemonSvc.getRouteMatcher()
        );

        //TThreadSafeRouter also implements IRouteMatcher so this is OK
        fThreadSafeRouteMatcher := fThreadSafeRouter as IRouteMatcher;

        fThreadSafeOutputBuffer := TThreadSafeOutputBuffer.create(
            fDaemonSvc.getOutputBuffer
        );
    end;

    destructor TThreadProtocolAppServiceProvider.destroy();
    begin
        fThreadSafeStdIn := nil;
        fThreadSafeStdOut := nil;
        fThreadSafeRouter := nil;
        fThreadSafeRouteMatcher := nil;
        fThreadSafeEnv := nil;
        fThreadSafeDispatcher := nil;
        fThreadSafeErrorHandler := nil;
        fThreadSafeContainer := nil;
        fThreadProtocol := nil;
        inherited destroy();
    end;

    function TThreadProtocolAppServiceProvider.getContainer() : IDependencyContainer;
    begin
        result := fThreadSafeContainer;
    end;

    function TThreadProtocolAppServiceProvider.getErrorHandler() : IErrorHandler;
    begin
        result := fThreadSafeErrorHandler;
    end;

    function TThreadProtocolAppServiceProvider.getDispatcher() : IDispatcher;
    begin
        result := fThreadSafeDispatcher;
    end;

    function TThreadProtocolAppServiceProvider.getEnvironment() : ICGIEnvironment;
    begin
        result := fThreadSafeEnv;
    end;

    function TThreadProtocolAppServiceProvider.getRouter() : IRouter;
    begin
        result := fThreadSafeRouter;
    end;

    function TThreadProtocolAppServiceProvider.getRouteMatcher() : IRouteMatcher;
    begin
        result := fThreadSafeRouteMatcher;
    end;

    function TThreadProtocolAppServiceProvider.getStdIn() : IStdIn;
    begin
        result := fThreadSafeStdIn;
    end;

    function TThreadProtocolAppServiceProvider.getOutputBuffer() : IOutputBuffer;
    begin
        result := fThreadSafeOutputBuffer;
    end;

    function TThreadProtocolAppServiceProvider.getProtocol() : IProtocolProcessor;
    begin
        result := fThreadProtocol;
    end;

    function TThreadProtocolAppServiceProvider.getStdOut() : IStdOut;
    begin
        result := fThreadSafeStdOut;
    end;
end.
