{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RequestHandlerAsMiddlewareImpl;

interface

{$MODE OBJFPC}

uses
    RequestIntf,
    ResponseIntf,
    RequestHandlerIntf,
    RouteArgsReaderIntf,
    MiddlewareIntf;

type

    (*!------------------------------------------------
     * adapter class that wrap request handler so it can
     * act as a middleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TRequestHandlerAsMiddleware = class(TInterfacedObject, IMiddleware)
    private
        requestHandler : IRequestHandler;
    public
        constructor create(const handler : IRequestHandler);
        destructor destroy(); override;
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;
    end;

implementation

    constructor TRequestHandlerAsMiddleware.create(const handler : IRequestHandler);
    begin
        requestHandler := handler;
    end;

    destructor TRequestHandlerAsMiddleware.destroy();
    begin
        requestHandler := nil;
        inherited destroy();
    end;

    function TRequestHandlerAsMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    var newResp : IResponse;
    begin
        newResp := requestHandler.handleRequest(request, response, args);
        result := next.handleRequest(request, newResp, args);
    end;
end.
