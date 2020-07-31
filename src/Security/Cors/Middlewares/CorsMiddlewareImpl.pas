{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit CorsMiddlewareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    MiddlewareIntf,
    RequestIntf,
    ResponseIntf,
    HeadersIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    InjectableObjectImpl,
    CorsIntf;

type

    (*!------------------------------------------------
     * middleware implementation that add CORS header
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCorsMiddleware = class(TInjectableObject, IMiddleware)
    private
        fCors : ICors;
        function handlePreflightRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;
    public
        constructor create(const cors : ICors);
        destructor destroy(); override;

        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;
    end;

implementation

uses

    HttpCodeResponseImpl;

    constructor TCorsMiddleware.create(const cors : ICors);
    begin
        inherited create();
        fCors := cors;
    end;

    destructor TCorsMiddleware.destroy();
    begin
        fCors := nil;
        inherited destroy();
    end;

    function TCorsMiddleware.handlePreflightRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    begin
        if (fCors.isPreflightRequest(request)) then
        begin
            //preflight request, no need to continue, we handle it from here
            result := fCors.handlePreflightRequest(request, response);
        end else
        begin
            if (not fCors.isAllowed(request)) then
            begin
                result := THttpCodeResponse.create(403, 'Not allowed', response.headers());
            end else
            begin
                //add CORS header and continue to next middleware/request handler
                result := next.handleRequest(
                    request,
                    fCors.addCorsResponseHeaders(request, response),
                    args
                );
            end;
        end;
    end;

    function TCorsMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    begin
        if (not fCors.isCorsRequest(request)) then
        begin
            //do nothing and just continue to next middleware
            result := next.handleRequest(request, response, args);
        end else
        begin
            result := handlePreflightRequest(request, response, args, next);
        end;
    end;

end.
