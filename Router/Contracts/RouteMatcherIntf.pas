{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (GPL 3.0)
 *}

unit RouteMatcherIntf;

interface

{$MODE OBJFPC}

uses

    RouteHandlerIntf;

type

    (*!------------------------------------------------
     * interface for any class that can find a route by name
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRouteMatcher = interface
        ['{CA7D9639-1B26-4B44-8C4B-794A4562CD75}']

        (*!----------------------------------------------
         * find route handler based request method and uri
         * ----------------------------------------------
         * @param requestMethod GET, POST,.., etc
         * @param requestUri requested Uri
         * @return route handler instance
         *-----------------------------------------------*)
        function match(const requestMethod : string; const requestUri : string) : IRouteHandler;
    end;

implementation
end.
