{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit XssFilterMiddlewareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    MiddlewareIntf,
    RequestHandlerIntf,
    RouteArgsReaderIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * middleware that prevent basic XSS attack by adding
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TXssFilterMiddleware = class(TInjectableObject, IMiddleware)
    public
        (*!---------------------------------------
         * handle request and validate request
         *----------------------------------------
         * @param request request instance
         * @param response response instance
         * @param route arguments
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

    (*!---------------------------------------
     * handle request
     *----------------------------------------
     * @param request request instance
     * @param response response instance
     * @param route arguments
     * @param next next middleware to execute
     * @return response
     *----------------------------------------*)
    function TXssFilterMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    begin
        result := next.handleRequest(request, response, args);
        result.headers().setHeader('X-XSS-Protection', '1; mode=block');
    end;

end.
