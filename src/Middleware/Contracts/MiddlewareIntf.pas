{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MiddlewareIntf;

interface

{$MODE OBJFPC}

uses

    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability as middleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IMiddleware = interface
        ['{E0ECB41C-8D8F-41C1-9FAC-7DFBD06ED8D4}']

        (*!---------------------------------------
         * handle request
         *----------------------------------------
         * @param request request instance
         * @param response response instance
         * @param args route arguments
         * @param next next middleware to execute
         * @return response
         *----------------------------------------*)
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;

    end;

implementation
end.
