{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MethodRequestHandlerImpl;

interface

{$MODE OBJFPC}

uses

    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    HandlerTypes;

type

    (*!------------------------------------------------
     * adapter class which implement IRequestHandler
     * to allow method be used as request handler
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMethodRequestHandler = class(TInterfacedObject, IRequestHandler)
    private
        fHandlerMethod : THandlerMethod;
    public
        constructor create(const handlerMethod : THandlerMethod);

        (*!-------------------------------------------
         * handle request
         *--------------------------------------------
         * @param request object represent current request
         * @param response object represent current response
         * @param args object represent current route arguments
         * @return new response
         *--------------------------------------------*)
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader
        ) : IResponse;
    end;

implementation

uses

    SysUtils;

    constructor TMethodRequestHandler.create(const handlerMethod : THandlerMethod);
    begin
        fHandlerMethod := handlerMethod;
        if not assigned(fHandlerMethod) then
        begin
            raise Exception.create('Invalid handler method');
        end;
    end;

    (*!-------------------------------------------
     * handle request
     *--------------------------------------------
     * @param request object represent current request
     * @param response object represent current response
     * @param args object represent current route arguments
     * @return new response
     *--------------------------------------------*)
    function TMethodRequestHandler.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader
    ) : IResponse;
    begin
        result := fHandlerMethod(request, response, args);
    end;
end.
