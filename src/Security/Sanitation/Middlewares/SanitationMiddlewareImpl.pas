{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SanitationMiddlewareImpl;

interface

{$MODE OBJFPC}

uses

    RequestIntf,
    ResponseIntf,
    MiddlewareIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    SanitizerIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * middleware class that sanitized request param reading
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TSanitationMiddleware = class(TInjectableObject, IMiddleware)
    private
        fSanitizer : ISanitizer;
    public
        constructor create(const aSanitizer : ISanitizer);
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const nextMdlwr : IRequestHandler
        ) : IResponse;
    end;

implementation

uses

    SanitizedRequestImpl;

    constructor TSanitationMiddleware.create(const aSanitizer : ISanitizer);
    begin
        fSanitizer := aSanitizer;
    end;

    function TSanitationMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const nextMdlwr : IRequestHandler
    ) : IResponse;
    var sanitizedRequest : IRequest;
    begin
        sanitizedRequest := TSanitizedRequest.create(request, fSanitizer);
        result := nextMdlwr.handleRequest(sanitizedRequest, response, args);
    end;
end.
