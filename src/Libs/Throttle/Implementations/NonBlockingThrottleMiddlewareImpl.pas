{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NonBlockingThrottleMiddlewareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    ThrottleMiddlewareImpl,
    RateTypes;

type

    (*!------------------------------------------------
     * rate limiter middleware implementation which does not
     * block request if exceed given limit. It just wraps
     * request with additional rate limit data and continue
     * so that other middleware or controller can decides what to do
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNonBlockingThrottleMiddleware = class (TThrottleMiddleware)
    public
        (*!---------------------------------------
         * handle request
         *----------------------------------------
         * @param request request instance
         * @param response response instance
         * @param args route arguments
         * @param next next middleware to execute
         * @return response
         *----------------------------------------*)
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse; override;

    end;

implementation

uses

    ThrottleRequestIntf,
    ThrottleRequestImpl;

    (*!---------------------------------------
     * handle request
     *----------------------------------------
     * @param request request instance
     * @param response response instance
     * @param args route arguments
     * @param next next middleware to execute
     * @return response
     *----------------------------------------*)
    function TNonBlockingThrottleMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    var
        status : TLimitStatus;
        throttledRequest : IThrottleRequest;
    begin
        status := fRateLimiter.limit(fIdentifier[request], fRate);
        throttledRequest := TThrottleRequest.create(request, status);
        result := next.handleRequest(throttledRequest, response, args);
    end;

end.
