{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MiddlewareChainImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    MiddlewareLinkListIntf;

type

    (*!------------------------------------------------
     * Internal request handler class having capability
     * to combine two middleware link list as one
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMiddlewareChain = class(TInterfacedObject, IRequestHandler)
    private
        fAppMiddlewares : IMiddlewareLinkList;
        fRouteMiddlewares : IMiddlewareLinkList;
        fHandler : IRequestHandler;

        procedure linkAppAndRouteMiddlewares();
        procedure unlinkAppAndRouteMiddlewares();
        function getFirst() : IRequestHandler;
    public
        constructor create(
            const appMiddlewares : IMiddlewareLinkList;
            const routeMiddlewares : IMiddlewareLinkList;
            const handler : IRequestHandler
        );
        destructor destroy(); override;

        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const routeArgs : IRouteArgsReader
        ) : IResponse;

    end;

implementation

uses

    MiddlewareLinkIntf;

    constructor TMiddlewareChain.create(
        const appMiddlewares : IMiddlewareLinkList;
        const routeMiddlewares : IMiddlewareLinkList;
        const handler : IRequestHandler
    );
    begin
        fAppMiddlewares := appMiddlewares;
        fRouteMiddlewares := routeMiddlewares;
        fHandler := handler;
        linkAppAndRouteMiddlewares();
    end;

    destructor TMiddlewareChain.destroy();
    begin
        //remove reference to avoid memory leak
        unlinkAppAndRouteMiddlewares();
        fAppMiddlewares := nil;
        fRouteMiddlewares := nil;
        fHandler := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * combine application middleware list and route
     * middleware list and controller request handler
     * as one chain
     *-------------------------------------------------
     * Combine
     * app middlewares => [mw0]--[mw1]
     * route middlewares => [rmw0]--[rmw1]
     * request handler => [handler]
     * to become
     * [mw0]--[mw1]--[rmw0]--[rmw1]--[handler]
     *
     * app middlewares => empty
     * route middlewares => [rmw0]--[rmw1]
     * request handler => [handler]
     * to become
     * [rmw0]--[rmw1]--[handler]
     *
     * app middlewares => [mw0]--[mw1]
     * route middlewares => empty
     * request handler => [handler]
     * to become
     * [mw0]--[mw1]--[handler]
     *
     * app middlewares => empty
     * route middlewares => empty
     * request handler => [handler]
     * to become
     * [handler]
     *-------------------------------------------------*)
    procedure TMiddlewareChain.linkAppAndRouteMiddlewares();
    var appLastLink, routeFirstLink, routeLastLink : IMiddlewareLink;
        totAppMiddleware, totRouteMiddleware : integer;
    begin
        totAppMiddleware := fAppMiddlewares.count();
        totRouteMiddleware := fRouteMiddlewares.count();
        if (totAppMiddleware > 0) then
        begin
            appLastLink := fAppMiddlewares.get(totAppMiddleware - 1);
            if (totRouteMiddleware > 0) then
            begin
                routeFirstLink := fRouteMiddlewares.get(0);
                appLastLink.next := routeFirstLink;
                routeLastLink := fRouteMiddlewares.get(totRouteMiddleware - 1);
                routeLastLink.next := fHandler;
            end else
            begin
                appLastLink.next := fHandler;
            end;
        end else
        begin
            if (totRouteMiddleware > 0) then
            begin
                routeLastLink := fRouteMiddlewares.get(totRouteMiddleware - 1);
                routeLastLink.next := fHandler;
            end;
        end;
    end;

    procedure TMiddlewareChain.unlinkAppAndRouteMiddlewares();
    var appLastLink, routeLastLink : IMiddlewareLink;
        totAppMiddleware, totRouteMiddleware : integer;
    begin
        totAppMiddleware := fAppMiddlewares.count();
        totRouteMiddleware := fRouteMiddlewares.count();
        if (totAppMiddleware > 0) then
        begin
            appLastLink := fAppMiddlewares.get(totAppMiddleware - 1);
            if (totRouteMiddleware > 0) then
            begin
                appLastLink.next := nil;
                routeLastLink := fRouteMiddlewares.get(totRouteMiddleware - 1);
                routeLastLink.next := nil;
            end else
            begin
                appLastLink.next := nil;
            end;
        end else
        begin
            if (totRouteMiddleware > 0) then
            begin
                routeLastLink := fRouteMiddlewares.get(totRouteMiddleware - 1);
                routeLastLink.next := nil;
            end;
        end;
    end;

    function TMiddlewareChain.getFirst() : IRequestHandler;
    var totAppMiddleware, totRouteMiddleware : integer;
    begin
        totAppMiddleware := fAppMiddlewares.count();
        totRouteMiddleware := fRouteMiddlewares.count();
        if (totAppMiddleware > 0) or (totRouteMiddleware > 0) then
        begin
            if (totAppMiddleware > 0) then
            begin
                result := fAppMiddlewares.get(0);
            end else
            begin
                result := fRouteMiddlewares.get(0);
            end;
        end else
        begin
            result := fHandler;
        end;
    end;

    function TMiddlewareChain.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const routeArgs : IRouteArgsReader
    ) : IResponse;
    begin
        result := getFirst().handleRequest(request, response, routeArgs);
    end;

end.
