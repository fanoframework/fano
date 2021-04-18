{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompositeMiddlewareImpl;

interface

{$MODE OBJFPC}

uses

    RequestIntf,
    ResponseIntf,
    MiddlewareIntf,
    MiddlewareLinkIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    InjectableObjectImpl;

type

    TMiddlewareArray = array of IMiddlewareLink;

    (*!------------------------------------------------
     * middleware class that is composed from several
     * external middlewares
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCompositeMiddleware = class(TInjectableObject, IMiddleware)
    private
        fMiddlewares : TMiddlewareArray;
        procedure freeMiddlewares(var middlewares : TMiddlewareArray);
        function initMiddlewares(const middlewares : array of IMiddleware) : TMiddlewareArray;
    public
        constructor create(const middlewares : array of IMiddleware);
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

    MiddlewareLinkImpl;

    constructor TCompositeMiddleware.create(const middlewares : array of IMiddleware);
    begin
        fMiddlewares := initMiddlewares(middlewares);
    end;

    destructor TCompositeMiddleware.destroy();
    begin
        freeMiddlewares(fMiddlewares);
        inherited destroy();
    end;

    function TCompositeMiddleware.initMiddlewares(const middlewares : array of IMiddleware) : TMiddlewareArray;
    var i, totMiddlewares : integer;
    begin
        result := default(TMiddlewareArray);
        totMiddlewares := high(middlewares) - low(middlewares) + 1;
        setLength(result, totMiddlewares);
        if (totMiddlewares > 0) then
        begin
            for i := 0 to totMiddlewares - 1 do
            begin
                result[i] := TMiddlewareLink.create(middlewares[i]);
                result[i].next := nil;
                if (i > 0) then
                begin
                    result[i-1].next := result[i];
                end;
            end;
        end;
    end;

    procedure TCompositeMiddleware.freeMiddlewares(var middlewares : TMiddlewareArray);
    var i, totMiddlewares : integer;
    begin
        totMiddlewares := length(middlewares);
        for i := 0 to totMiddlewares - 1 do
        begin
            middlewares[i].next := nil;
            middlewares[i] := nil;
        end;
        setLength(middlewares, 0);
        middlewares := nil;
    end;

    function TCompositeMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    var totMiddlewares : integer;
    begin
        totMiddlewares := length(fMiddlewares);
        if (totMiddlewares > 0) then
        begin
            //point last middleware next to next middleware
            fMiddlewares[totMiddlewares-1].next := next;
            try
                //execute middleware start from first
                result := fMiddlewares[0].handleRequest(request, response, args);
            finally
                //remove reference to avoid memory leak
                fMiddlewares[totMiddlewares-1].next := nil;
            end;
        end else
        begin
            result := next.handleRequest(request, response, args);
        end;
    end;
end.
