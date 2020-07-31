{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RouterIntf;

interface

{$MODE OBJFPC}

uses

    RequestHandlerIntf,
    RouteIntf;

type

    (*!------------------------------------------------
     * interface for any class that can set route handler
     * for various http verb
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IRouter = interface
        ['{786EC9AF-C843-4B2E-9729-9146FAE8DDE3}']

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
        ) : IRoute;

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
        ) : IRoute;

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
        ) : IRoute;

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
        ) : IRoute;

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
        ) : IRoute;

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
        ) : IRoute;

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
        ) : IRoute;

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
        ) : IRoute;

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
        ) : IRoute;
    end;

implementation
end.
