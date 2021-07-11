{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FuncMiddlewareImpl;

interface

{$MODE OBJFPC}

uses

    MiddlewareIntf,
    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    MiddlewareTypes;

type

    (*!------------------------------------------------
     * adapter class which implement IMiddleware
     * to allow function be used as middleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TFuncMiddleware = class(TInterfacedObject, IMiddleware)
    private
        fMiddlewareFunc : TMiddlewareFunc;
    public
        constructor create(const middlewareFunc : TMiddlewareFunc);

        (*!-------------------------------------------
         * handle request
         *--------------------------------------------
         * @param request object represent current request
         * @param response object represent current response
         * @param args object represent current route arguments
         * @param next next middleware
         * @return new response
         *--------------------------------------------*)
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;
    end;

implementation

uses

    SysUtils;

    constructor TFuncMiddleware.create(const middlewareFunc : TMiddlewareFunc);
    begin
        fMiddlewareFunc := middlewareFunc;
        if not assigned(fMiddlewareFunc) then
        begin
            raise Exception.create('Invalid middleware function');
        end;
    end;

    (*!-------------------------------------------
     * handle request
     *--------------------------------------------
     * @param request object represent current request
     * @param response object represent current response
     * @param args object represent current route arguments
     * @param next next middleware
     * @return new response
     *--------------------------------------------*)
    function TFuncMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    begin
        result := fMiddlewareFunc(request, response, args, next);
    end;
end.
