{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit XSimpleDispatcherFactoryImpl;

interface

{$MODE OBJFPC}

uses
    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    RouteMatcherIntf,
    RequestResponseFactoryIntf,
    SimpleDispatcherFactoryImpl;

type

    (*!--------------------------------------------------
     * factory class for TXSimpleDispatcher,
     * route dispatcher implementation which does not support
     * middleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TXSimpleDispatcherFactory = class(TSimpleDispatcherFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    XSimpleDispatcherImpl;

    function TXSimpleDispatcherFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TXSimpleDispatcher.create(
            fRouteMatcher,
            fRequestResponseFactory.responseFactory,
            fRequestResponseFactory.requestFactory
        );
    end;

end.
