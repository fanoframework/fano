{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NoCacheMiddlewareImpl;

interface

{$MODE OBJFPC}

uses

    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    AbstractMiddlewareImpl;

type

    (*!------------------------------------------------
     * middleware class that prevent browser from caching
     * response
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNoCacheMiddleware = class(TAbstractMiddleware)
    public
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const nextMiddleware : IRequestHandler
        ) : IResponse; override;
    end;

implementation

    function TNoCacheMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const nextMiddleware : IRequestHandler
    ) : IResponse;
    begin
        result := nextMiddleware.handleRequest(request, response, args);
        result.headers().setHeader(
            'Cache-Control',
            'no-store, no-cache, must-revalidate'
        );
    end;
end.
