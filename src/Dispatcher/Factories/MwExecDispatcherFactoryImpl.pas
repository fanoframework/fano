{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MwExecDispatcherFactoryImpl;

interface

{$MODE OBJFPC}

uses
    DependencyIntf,
    DependencyContainerIntf,
    RouteMatcherIntf,
    MiddlewareLinkListIntf,
    MiddlewareExecutorIntf,
    RequestResponseFactoryIntf,
    DispatcherFactoryImpl;

type

    (*!--------------------------------------------------
     * factory class for TMwExecDispatcher,
     * route dispatcher implementation which support middleware
     * and ensure application middleware always executed even
     * when route is not exists
     *---------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TMwExecDispatcherFactory = class(TDispatcherFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    MwExecDispatcherImpl;

    function TMwExecDispatcherFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TMwExecDispatcher.create(
            createMiddlewareExecutor(),
            fRouteMatcher,
            fRequestResponseFactory.responseFactory,
            fRequestResponseFactory.requestFactory
        );
    end;

end.
