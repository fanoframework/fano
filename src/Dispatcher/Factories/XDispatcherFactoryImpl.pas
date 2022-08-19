{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit XDispatcherFactoryImpl;

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
     * factory class for TXDispatcher,
     * route dispatcher implementation which support middleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TXDispatcherFactory = class(TDispatcherFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    XDispatcherImpl;

    function TXDispatcherFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TXDispatcher.create(
            createMiddlewareExecutor(),
            fRouteMatcher,
            fRequestResponseFactory.responseFactory,
            fRequestResponseFactory.requestFactory
        );
    end;

end.
