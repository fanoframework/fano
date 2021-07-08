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

    TOnLimitReachedEvent = function (
        const status : TLimitStatus;
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse of object;

    (*!------------------------------------------------
     * rate limiter implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThrottleMiddleware = class (TAbstractMiddleware)
    private
        fRateLimiter : IRateLimiter;
        fIdentifier : IRequestIdentifier;
        fRate : TRate;
        fOnLimitReached : TOnLimitReachedEvent;

        function defaultLimitReach(
            const status : TLimitStatus;
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;
    public
        constructor create(
            const rateLimiter : IRateLimiter;
            const identifier : IRequestIdentifier;
            const rate : TRate;
            const evLimitReached : TOnLimitReachedEvent = nil
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
    ETooManyRequestsImpl;

    constructor TThrottleMiddleware.create(
        const rateLimiter : IRateLimiter;
        const identifier : IRequestIdentifier;
        const rate : TRate;
        const evLimitReached : TOnLimitReachedEvent = nil
    );
    begin
        fRateLimiter := rateLimiter;
        fIdentifier := identifier;
        fRate := rate;
        fOnLimitReached := @defaultLimitReach;
        if (evLimitReached <> nil) then
        begin
            fOnLimitReached := @evLimitReached;
        end;
    end;

    function TThrottleMiddleware.defaultLimitReach(
        const status : TLimitStatus;
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    var
        headers : string;
    begin
        headers :=
            'X-RateLimit-Limit: ' + inttostr(status.limit) + #13#10 +
            'X-RateLimit-Remaining: ' + inttostr(status.remainingAttempts) + #13#10 +
            'X-RateLimit-Reset: ' + inttostr(status.resetTimestamp) + #13#10 +
            'Retry-After: ' + inttostr(status.retryAfter) + #13#10;

        raise ETooManyRequests.create(
            'Too many requests. Please try again after ' +
            inttostr(status.retryAfter) +' seconds',
            headers
        );
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
    var status : TLimitStatus;
        headers : string;
    begin
        status := fRateLimiter.limit(fIdentifier[request], fRate);
        if status.limitReached then
        begin
            if (Assigned(fOnLimitReached)) then
            begin
                result := fOnLimitReached(status, request, response, args, next);
            end;
        end else
        begin
            result := next.handleRequest(request, response, args);
        end;
    end;

end.
