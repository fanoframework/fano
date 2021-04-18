{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SimpleDispatcherFactoryImpl;

interface

{$MODE OBJFPC}

uses
    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    RouteMatcherIntf,
    RequestResponseFactoryIntf;

type

    (*!--------------------------------------------------
     * factory class for TSimpleDispatcher,
     * route dispatcher implementation which does not support
     * middleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TSimpleDispatcherFactory = class(TFactory, IDependencyFactory)
    protected
        fRouteMatcher : IRouteMatcher;
        fRequestResponseFactory : IRequestResponseFactory;
    public
        constructor create (
            const routeMatcher : IRouteMatcher;
            const requestResponseFactory : IRequestResponseFactory
        );
        destructor destroy(); override;
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    SimpleDispatcherImpl;

    constructor TSimpleDispatcherFactory.create(
        const routeMatcher : IRouteMatcher;
        const requestResponseFactory : IRequestResponseFactory
    );
    begin
        inherited create();
        fRouteMatcher := routeMatcher;
        fRequestResponseFactory := requestResponseFactory;
    end;

    destructor TSimpleDispatcherFactory.destroy();
    begin
        fRouteMatcher := nil;
        fRequestResponseFactory := nil;
        inherited destroy();
    end;

    function TSimpleDispatcherFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TSimpleDispatcher.create(
            fRouteMatcher,
            fRequestResponseFactory.responseFactory,
            fRequestResponseFactory.requestFactory
        );
    end;

end.
