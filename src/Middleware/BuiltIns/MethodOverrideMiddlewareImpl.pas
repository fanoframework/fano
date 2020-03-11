{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MethodOverrideMiddlewareImpl;

interface

{$MODE OBJFPC}

uses

    RequestIntf,
    ResponseIntf,
    MiddlewareIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * middleware class having capability to override
     * http method (http verb tunneling)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMethodOverrideMiddleware = class(TInjectableObject, IMiddleware)
    public
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const nextMdlwr : IRequestHandler
        ) : IResponse;
    end;

implementation

uses

    MethodOverrideRequestImpl;

    function TMethodOverrideMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const nextMdlwr : IRequestHandler
    ) : IResponse;
    var ovrRequest : IRequest;
    begin
        ovrRequest := TMethodOverrideRequest.create(request);
        result := nextMdlwr.handleRequest(ovrRequest, response, args);
    end;
end.
