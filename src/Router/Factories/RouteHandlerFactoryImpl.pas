{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RouteHandlerFactoryImpl;

interface

{$MODE OBJFPC}

uses

    MiddlewareListFactoryIntf,
    RequestHandlerIntf,
    RouteHandlerIntf,
    RouteHandlerFactoryIntf;

type

    (*!------------------------------------------------
     * Factory class that wrap request handler as route handler
     * so it can be chained with middlewares
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TRouteHandlerFactory = class(TInterfacedObject, IRouteHandlerFactory)
    private
        fMiddlewareListFactory : IMiddlewareListFactory;
    public
        constructor create(const middlewareListFactory : IMiddlewareListFactory);
        destructor destroy(); override;
        function build(const handler : IRequestHandler) : IRouteHandler;
    end;

implementation

uses

    MiddlewareListItemIntf,
    RouteHandlerImpl;

    constructor TRouteHandlerFactory.create(const middlewareListFactory : IMiddlewareListFactory);
    begin
        fMiddlewareListFactory := middlewareListFactory;
    end;

    destructor TRouteHandlerFactory.destroy();
    begin
        fMiddlewareListFactory := nil;
        inherited destroy();
    end;

    function TRouteHandlerFactory.build(const handler : IRequestHandler) : IRouteHandler;
    var middlewareList : IMiddlewareListItem;
    begin
        try
            middlewareList := fMiddlewareListFactory.build();
            result := TRouteHandler.create(middlewareList, handler);
        except
            middlewareList := nil;
            result := nil;
            raise;
        end;
    end;

end.
