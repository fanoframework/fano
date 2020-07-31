{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractRouterFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    MiddlewareListFactoryIntf;

type

    (*!------------------------------------------------
     * Factory class for route collection using
     * TSimpleRouteList
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAbstractRouterFactory = class(TFactory, IDependencyFactory)
    private
        fMiddlewareListFactory : IMiddlewareListFactory;
    protected
        function getMiddlewareFactory() : IMiddlewareListFactory;
    public
        constructor create();
        destructor destroy(); override;
        function middlewareListFactory(const aFactory : IMiddlewareListFactory) : TAbstractRouterFactory;
    end;

implementation

uses

    MiddlewareListFactoryImpl;

    constructor TAbstractRouterFactory.create();
    begin
        fMiddlewareListFactory := nil;
    end;

    destructor TAbstractRouterFactory.destroy();
    begin
        fMiddlewareListFactory := nil;
        inherited destroy();
    end;

    function TAbstractRouterFactory.getMiddlewareFactory() : IMiddlewareListFactory;
    begin
        if (fMiddlewareListFactory = nil) then
        begin
            fMiddlewareListFactory := TMiddlewareListFactory.create();
        end;
        result := fMiddlewareListFactory;
    end;

    function TAbstractRouterFactory.middlewareListFactory(const aFactory : IMiddlewareListFactory) : TAbstractRouterFactory;
    begin
        fMiddlewareListFactory := aFactory;
        result := self;
    end;
end.
