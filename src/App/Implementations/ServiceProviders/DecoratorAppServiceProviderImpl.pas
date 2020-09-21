{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DecoratorAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    AppServiceProviderIntf,
    DependencyContainerIntf,
    ErrorHandlerIntf,
    DispatcherIntf,
    EnvironmentIntf,
    StdInIntf,
    RouterIntf;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TDecoratorAppServiceProvider = class (TInterfacedObject, IAppServiceProvider)
    protected
        fAppSvc : IAppServiceProvider;
    public
        constructor create(const actualSvc : IAppServiceProvider);
        destructor destroy(); override;

        function getContainer() : IDependencyContainer; virtual;

        function getErrorHandler() : IErrorHandler; virtual;

        function getDispatcher() : IDispatcher; virtual;

        function getEnvironment() : ICGIEnvironment; virtual;

        function getRouter() : IRouter; virtual;

        function getStdIn() : IStdIn; virtual;

        (*!--------------------------------------------------------
         * register all services
         *---------------------------------------------------------
         * @param container service container
         *---------------------------------------------------------
         * Descendant must implement this and registers services
         * according to their requirement
         *---------------------------------------------------------*)
        procedure register(const cntr : IDependencyContainer);
    end;

implementation

    constructor TDecoratorAppServiceProvider.create(const actualSvc : IAppServiceProvider);
    begin
        fAppSvc := actualSvc;
    end;

    destructor TDecoratorAppServiceProvider.destroy();
    begin
        fAppSvc := nil;
        inherited destroy();
    end;

    function TDecoratorAppServiceProvider.getContainer() : IDependencyContainer;
    begin
        result := fAppSvc.getContainer();
    end;

    function TDecoratorAppServiceProvider.getErrorHandler() : IErrorHandler;
    begin
        result := fAppSvc.getErrorHandler();
    end;

    function TDecoratorAppServiceProvider.getDispatcher() : IDispatcher;
    begin
        result := fAppSvc.getDispatcher();
    end;

    function TDecoratorAppServiceProvider.getEnvironment() : ICGIEnvironment;
    begin
        result := fAppSvc.getEnvironment();
    end;

    function TDecoratorAppServiceProvider.getRouter() : IRouter;
    begin
        result := fAppSvc.getRouter();
    end;

    function TDecoratorAppServiceProvider.getStdIn() : IStdIn;
    begin
        result := fAppSvc.getStdIn();
    end;

    (*!--------------------------------------------------------
     * register all services
     *---------------------------------------------------------
     * @param container service container
     *---------------------------------------------------------
     * Descendant must implement this and registers services
     * according to their requirement
     *---------------------------------------------------------*)
    procedure TDecoratorAppServiceProvider.register(const cntr : IDependencyContainer);
    begin
        fAppSvc.register(cntr);
    end;
end.
