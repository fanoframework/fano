{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FuncRequestHandlerImpl;

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
     * to allow function be used as request handler
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TFuncRequestHandler = class(TInterfacedObject, IRequestHandler)
    private
        fHandlerFunc : THandlerFunc;
    public
        constructor create(const handlerFunc : THandlerFunc);

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

    constructor TFuncRequestHandler.create(const handlerFunc : THandlerFunc);
    begin
        fHandlerFunc := handlerFunc;
        if not assigned(fHandlerFunc) then
        begin
            raise Exception.create('Invalid handler function');
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
    function TFuncRequestHandler.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader
    ) : IResponse;
    begin
        result := fHandlerFunc(request, response, args);
    end;
end.
