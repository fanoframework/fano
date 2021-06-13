{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThrottleMiddlewareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    AbstractMiddlewareImpl,
    RateLimiterIntf,
    RequestIdentifierIntf,
    RateTypes;

type

    (*!------------------------------------------------
     * abstract rate limiter implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThrottleMiddleware = class (TAbstractMiddleware)
    private
        fRateLimiter : IRateLimiter;
        fIdentifier : IRequestIdentifier;
        fRate : TRate;
    public
        constructor create(
            const rateLimiter : IRateLimiter;
            const identifier : IRequestIdentifier;
            const rate : TRate
        );

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

    SysUtils,
    HeadersIntf,
    HttpCodeResponseImpl;

    constructor TThrottleMiddleware.create(
        const rateLimiter : IRateLimiter;
        const identifier : IRequestIdentifier;
        const rate : TRate
    );
    begin
        fRateLimiter := rateLimiter;
        fIdentifier := identifier;
        fRate := rate;
    end;

    (*!---------------------------------------
     * handle request
     *----------------------------------------
     * @param request request instance
     * @param response response instance
     * @param args route arguments
     * @param next next middleware to execute
     * @return response
     *----------------------------------------*)
    function TThrottleMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    const TOO_MANY_REQUESTS = 429;
    var status : TLimitStatus;
        hdrs : IHeaders;
    begin
        status := fRateLimiter.limit(fIdentifier[request], fRate);
        if status.limitReached then
        begin
            result := THttpCodeResponse.create(
                //rfc 6585
                TOO_MANY_REQUESTS,
                'Too Many Requests',
                response.headers(),
                response.body()
            );
            hdrs := result.headers();
            hdrs.setHeader('X-RateLimit-Limit', inttostr(status.limit));
            hdrs.setHeader('X-RateLimit-Remaining',inttostr(status.remainingAttempts));
            hdrs.setHeader('X-RateLimit-Reset', inttostr(status.resetTimestamp));
            hdrs.setHeader('Retry-After', inttostr(status.retryAfter));
        end else
        begin
            result := next.handleRequest(request, response, args);
        end;
    end;

end.
