{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit AppServiceProviderIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyContainerIntf,
    ServiceProviderIntf,
    ErrorHandlerIntf,
    DispatcherIntf,
    EnvironmentIntf,
    StdInIntf,
    RouteMatcherIntf,
    RouterIntf;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    IAppServiceProvider = interface(IServiceProvider)
        ['{41032A70-F31D-45A6-AE26-574888BE4D07}']
        function getContainer() : IDependencyContainer;
        property container : IDependencyContainer read getContainer;

        function getErrorHandler() : IErrorHandler;
        property errorHandler : IErrorHandler read getErrorHandler;

        function getDispatcher() : IDispatcher;
        property dispatcher : IDispatcher read getDispatcher;

        function getEnvironment() : ICGIEnvironment;
        property env : ICGIEnvironment read getEnvironment;

        function getRouter() : IRouter;
        property router : IRouter read getRouter;

        function getStdIn() : IStdIn;
        property stdIn : IStdIn read getStdIn;
    end;

implementation

end.
