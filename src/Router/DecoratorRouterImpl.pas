{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorRouterImpl;

interface

{$MODE OBJFPC}

uses

    RequestHandlerIntf,
    RouteIntf,
    RouterIntf,
    RouteHandlerIntf,
    RouteMatcherIntf;

type

    (*!------------------------------------------------
     * decorator class that can set route handler
     * for various http verb
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDecoratorRouter = class (TInterfacedObject, IRouter, IRouteMatcher)
    protected
        fActualRouter : IRouter;
        fActualRouteMatcher : IRouteMatcher;
    public
        constructor create(
            const actualRouter : IRouter;
            const actualRouteMatcher : IRouteMatcher
        );

        (*!------------------------------------------
         * set route handler for HTTP GET
         * ------------------------------------------
         * @param routePattern regex pattern for route
         * @param handler instance route handler
         * @return route handler instance
         *-------------------------------------------*)
        function get(
            const routePattern: string;
            const handler : IRequestHandler
        ) : IRoute; virtual;

        (*!------------------------------------------
         * set route handler for HTTP POST
         * ------------------------------------------
         * @param routePattern regex pattern for route
         * @param handler instance route handler
         * @return route handler instance
         *-------------------------------------------*)
        function post(
            const routePattern: string;
            const handler : IRequestHandler
        ) : IRoute; virtual;

        (*!------------------------------------------
         * set route handler for HTTP PUT
         * ------------------------------------------
         * @param routePattern regex pattern for route
         * @param handler instance route handler
         * @return route handler instance
         *-------------------------------------------*)
        function put(
            const routePattern: string;
            const handler : IRequestHandler
        ) : IRoute; virtual;

        (*!------------------------------------------
         * set route handler for HTTP PATCH
         * ------------------------------------------
         * @param routePattern regex pattern for route
         * @param handler instance route handler
         * @return route instance
         *-------------------------------------------*)
        function patch(
            const routePattern: string;
            const handler : IRequestHandler
        ) : IRoute; virtual;

        (*!------------------------------------------
         * set route handler for HTTP DELETE
         * ------------------------------------------
         * @param routePattern regex pattern for route
         * @param handler instance route handler
         * @return route instance
         *-------------------------------------------*)
        function delete(
            const routePattern: string;
            const handler : IRequestHandler
        ) : IRoute; virtual;

        (*!------------------------------------------
         * set route handler for HTTP HEAD
         * ------------------------------------------
         * @param routePattern regex pattern for route
         * @param handler instance route handler
         * @return route instance
         *-------------------------------------------*)
        function head(
            const routePattern: string;
            const handler : IRequestHandler
        ) : IRoute; virtual;

        (*!------------------------------------------
         * set route handler for HTTP OPTIONS
         * ------------------------------------------
         * @param routePattern regex pattern for route
         * @param handler instance route handler
         * @return route instance
         *-------------------------------------------*)
        function options(
            const routePattern: string;
            const handler : IRequestHandler
        ) : IRoute; virtual;

        (*!------------------------------------------
         * set route handler for multiple HTTP verbs
         * ------------------------------------------
         * @param verbs array of http verbs, GET, POST, etc
         * @param routePattern regex pattern for route
         * @param handler instance route handler
         * @return route handler instance
         *-------------------------------------------*)
        function map(
            const verbs : array of string;
            const routePattern: string;
            const handler : IRequestHandler
        ) : IRoute; virtual;

        (*!------------------------------------------
         * set route handler for all HTTP verbs
         * ------------------------------------------
         * @param routePattern regex pattern for route
         * @param handler instance route handler
         * @return route handler instance
         *-------------------------------------------*)
        function any(
            const routePattern: string;
            const handler : IRequestHandler
        ) : IRoute; virtual;

        (*!----------------------------------------------
         * find route handler based request method and uri
         * ----------------------------------------------
         * @param requestMethod GET, POST,.., etc
         * @param requestUri requested Uri
         * @return route handler instance
         *-----------------------------------------------*)
        function match(
            const requestMethod : shortstring;
            const requestUri : shortstring
        ) : IRouteHandler; virtual;
    end;

implementation

    constructor TDecoratorRouter.create(
        const actualRouter : IRouter;
        const actualRouteMatcher : IRouteMatcher
    );
    begin
        fActualRouter := actualRouter;
        fActualRouteMatcher := actualRouteMatcher;
    end;

    (*!------------------------------------------
     * set route handler for HTTP GET
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route handler instance
     *-------------------------------------------*)
    function TDecoratorRouter.get(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        result := fActualRouter.get(routePattern, handler);
    end;

    (*!------------------------------------------
     * set route handler for HTTP POST
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route handler instance
     *-------------------------------------------*)
    function TDecoratorRouter.post(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        result := fActualRouter.post(routePattern, handler);
    end;

    (*!------------------------------------------
     * set route handler for HTTP PUT
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route handler instance
     *-------------------------------------------*)
    function TDecoratorRouter.put(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        result := fActualRouter.put(routePattern, handler);
    end;

    (*!------------------------------------------
     * set route handler for HTTP PATCH
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route instance
     *-------------------------------------------*)
    function TDecoratorRouter.patch(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        result := fActualRouter.patch(routePattern, handler);
    end;

    (*!------------------------------------------
     * set route handler for HTTP DELETE
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route instance
     *-------------------------------------------*)
    function TDecoratorRouter.delete(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        result := fActualRouter.delete(routePattern, handler);
    end;

    (*!------------------------------------------
     * set route handler for HTTP HEAD
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route instance
     *-------------------------------------------*)
    function TDecoratorRouter.head(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        result := fActualRouter.head(routePattern, handler);
    end;

    (*!------------------------------------------
     * set route handler for HTTP OPTIONS
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route instance
     *-------------------------------------------*)
    function TDecoratorRouter.options(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        result := fActualRouter.options(routePattern, handler);
    end;

    (*!------------------------------------------
     * set route handler for multiple HTTP verbs
     * ------------------------------------------
     * @param verbs array of http verbs, GET, POST, etc
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route handler instance
     *-------------------------------------------*)
    function TDecoratorRouter.map(
        const verbs : array of string;
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        result := fActualRouter.map(verbs, routePattern, handler);
    end;

    (*!------------------------------------------
     * set route handler for all HTTP verbs
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route handler instance
     *-------------------------------------------*)
    function TDecoratorRouter.any(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        result := fActualRouter.any(routePattern, handler);
    end;

    (*!----------------------------------------------
     * find route handler based request method and uri
     * ----------------------------------------------
     * @param requestMethod GET, POST,.., etc
     * @param requestUri requested Uri
     * @return route handler instance
     *-----------------------------------------------*)
    function TDecoratorRouter.match(
        const requestMethod : shortstring;
        const requestUri : shortstring
    ) : IRouteHandler;
    begin
        result := fActualRouteMatcher.match(requestMethod, requestUri);
    end;
end.
