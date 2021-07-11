{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MethodMiddlewareImpl;

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
     * to allow method be used as middleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMethodMiddleware = class(TInterfacedObject, IMiddleware)
    private
        fMiddlewareMethod : TMiddlewareMethod;
    public
        constructor create(const middlewareMethod : TMiddlewareMethod);

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

    constructor TMethodMiddleware.create(const middlewareMethod : TMiddlewareMethod);
    begin
        fMiddlewareMethod := middlewareMethod;
        if not assigned(fMIddlewareMethod) then
        begin
            raise Exception.create('Invalid middleware method');
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
    function TMethodMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    begin
        result := fMiddlewareMethod(request, response, args, next);
    end;
end.
