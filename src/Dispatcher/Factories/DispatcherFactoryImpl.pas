{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DispatcherFactoryImpl;

interface

{$MODE OBJFPC}

uses
    DependencyIntf,
    DependencyContainerIntf,
    RouteMatcherIntf,
    MiddlewareLinkListIntf,
    MiddlewareExecutorIntf,
    RequestResponseFactoryIntf,
    SimpleDispatcherFactoryImpl;

type

    (*!--------------------------------------------------
     * factory class for TDispatcher,
     * route dispatcher implementation which support middleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TDispatcherFactory = class(TSimpleDispatcherFactory)
    private
        appMiddlewares : IMiddlewareLinkList;
    protected
        function createMiddlewareExecutor() : IMiddlewareExecutor; virtual;
    public
        constructor create (
            const appMiddlewaresInst : IMiddlewareLinkList;
            const routeMatcher : IRouteMatcher;
            const requestResponseFactory : IRequestResponseFactory
        );
        destructor destroy(); override;

        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    DispatcherImpl,
    RequestResponseFactoryImpl,
    MiddlewareExecutorImpl;

    constructor TDispatcherFactory.create(
        const appMiddlewaresInst : IMiddlewareLinkList;
        const routeMatcher : IRouteMatcher;
        const requestResponseFactory : IRequestResponseFactory
    );
    begin
        inherited create(routeMatcher, requestResponseFactory);
        appMiddlewares := appMiddlewaresInst;
    end;

    destructor TDispatcherFactory.destroy();
    begin
        appMiddlewares := nil;
        inherited destroy();
    end;

    function TDispatcherFactory.createMiddlewareExecutor() : IMiddlewareExecutor;
    begin
        result := TMiddlewareExecutor.create(appMiddlewares);
    end;

    function TDispatcherFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TDispatcher.create(
            createMiddlewareExecutor(),
            fRouteMatcher,
            fRequestResponseFactory.responseFactory,
            fRequestResponseFactory.requestFactory
        );
    end;

end.
