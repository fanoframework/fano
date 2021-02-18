{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MiddlewareExecutorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    MiddlewareLinkListIntf,
    MiddlewareExecutorIntf,
    RouteArgsReaderIntf,
    RouteHandlerIntf;

type

    (*!------------------------------------------------
     * class having capability to execute middlewares stack
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMiddlewareExecutor = class(TInterfacedObject, IMiddlewareExecutor)
    private
        fAppMiddlewares : IMiddlewareLinkList;
    public
        constructor create(const appMiddlewares : IMiddlewareLinkList);
        destructor destroy(); override;
        function execute(
            const request : IRequest;
            const response : IResponse;
            const routeHandler : IRouteHandler
        ) : IResponse;
    end;

implementation

uses

    RequestHandlerIntf,
    MiddlewareChainImpl;

    constructor TMiddlewareExecutor.create(const appMiddlewares : IMiddlewareLinkList);
    begin
        fAppMiddlewares := appMiddlewares;
    end;

    destructor TMiddlewareExecutor.destroy();
    begin
        fAppMiddlewares := nil;
        inherited destroy();
    end;

    function TMiddlewareExecutor.execute(
        const request : IRequest;
        const response : IResponse;
        const routeHandler : IRouteHandler
    ) : IResponse;
    var mdlwr : IRequestHandler;
    begin
        mdlwr := TMiddlewareChain.create(
            fAppMiddlewares,
            routeHandler.middlewares(),
            routeHandler.handler()
        );
        try

            result := mdlwr.handleRequest(
                request,
                response,
                routeHandler.argsReader()
            );

        finally
            mdlwr := nil;
        end;
    end;
end.
