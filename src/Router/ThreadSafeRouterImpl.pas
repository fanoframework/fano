{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeRouterImpl;

interface

{$MODE OBJFPC}

uses

    SyncObjs,
    RequestHandlerIntf,
    RouteHandlerIntf,
    RouteIntf,
    RouterIntf,
    RouteMatcherIntf,
    DecoratorRouterImpl;

type

    (*!------------------------------------------------
     * thread-safe decorator class that can set route handler
     * for various http verb
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeRouter = class (TDecoratorRouter)
    private
        fCriticalSection : TCriticalSection;
    public
        constructor create(
            const actualRouter : IRouter;
            const actualRouteMatcher : IRouteMatcher
        );
        destructor destroy(); override;

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
        ) : IRoute; override;

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
        ) : IRoute; override;

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
        ) : IRoute; override;

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
        ) : IRoute; override;

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
        ) : IRoute; override;

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
        ) : IRoute; override;

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
        ) : IRoute; override;

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
        ) : IRoute; override;

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
        ) : IRoute; override;

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
        ) : IRouteHandler; override;
    end;

implementation

    constructor TThreadSafeRouter.create(
        const actualRouter : IRouter;
        const actualRouteMatcher : IRouteMatcher
    );
    begin
        inherited create(actualRouter, actualRouteMatcher);
        fCriticalSection := TCriticalSection.create();
    end;

    destructor TThreadSafeRouter.destroy();
    begin
        fCriticalSection.free();
        inherited destroy();
    end;

    (*!------------------------------------------
     * set route handler for HTTP GET
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route handler instance
     *-------------------------------------------*)
    function TThreadSafeRouter.get(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        fCriticalSection.acquire();
        try
            result := inherited get(routePattern, handler);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------
     * set route handler for HTTP POST
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route handler instance
     *-------------------------------------------*)
    function TThreadSafeRouter.post(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        fCriticalSection.acquire();
        try
            result := inherited post(routePattern, handler);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------
     * set route handler for HTTP PUT
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route handler instance
     *-------------------------------------------*)
    function TThreadSafeRouter.put(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        fCriticalSection.acquire();
        try
            result := inherited put(routePattern, handler);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------
     * set route handler for HTTP PATCH
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route instance
     *-------------------------------------------*)
    function TThreadSafeRouter.patch(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        fCriticalSection.acquire();
        try
            result := inherited patch(routePattern, handler);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------
     * set route handler for HTTP DELETE
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route instance
     *-------------------------------------------*)
    function TThreadSafeRouter.delete(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        fCriticalSection.acquire();
        try
            result := inherited delete(routePattern, handler);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------
     * set route handler for HTTP HEAD
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route instance
     *-------------------------------------------*)
    function TThreadSafeRouter.head(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        fCriticalSection.acquire();
        try
            result := inherited head(routePattern, handler);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------
     * set route handler for HTTP OPTIONS
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route instance
     *-------------------------------------------*)
    function TThreadSafeRouter.options(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        fCriticalSection.acquire();
        try
            result := inherited options(routePattern, handler);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------
     * set route handler for multiple HTTP verbs
     * ------------------------------------------
     * @param verbs array of http verbs, GET, POST, etc
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route handler instance
     *-------------------------------------------*)
    function TThreadSafeRouter.map(
        const verbs : array of string;
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        fCriticalSection.acquire();
        try
            result := inherited map(verbs, routePattern, handler);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------
     * set route handler for all HTTP verbs
     * ------------------------------------------
     * @param routePattern regex pattern for route
     * @param handler instance route handler
     * @return route handler instance
     *-------------------------------------------*)
    function TThreadSafeRouter.any(
        const routePattern: string;
        const handler : IRequestHandler
    ) : IRoute;
    begin
        fCriticalSection.acquire();
        try
            result := inherited any(routePattern, handler);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!----------------------------------------------
     * find route handler based request method and uri
     * ----------------------------------------------
     * @param requestMethod GET, POST,.., etc
     * @param requestUri requested Uri
     * @return route handler instance
     *-----------------------------------------------*)
    function TThreadSafeRouter.match(
        const requestMethod : shortstring;
        const requestUri : shortstring
    ) : IRouteHandler;
    begin
        fCriticalSection.acquire();
        try
            result := inherited match(requestMethod, requestUri);
        finally
            fCriticalSection.release();
        end;
    end;
end.
