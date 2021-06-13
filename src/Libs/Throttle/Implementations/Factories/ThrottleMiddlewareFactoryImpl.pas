{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThrottleMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}
uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    RateLimiterIntf,
    RequestIdentifierIntf,
    RateTypes;

type

    (*!------------------------------------------------
     * factory class for TThrottleMiddleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TThrottleMiddlewareFactory = class(TFactory, IDependencyFactory)
    private
        fRate : TRate;
        fRateLimiter : IRateLimiter;
        fRequestIdentifier : IRequestIdentifier;
    public
        constructor create();
        function rateLimiter(const limiter : IRateLimiter) : TThrottleMiddlewareFactory;
        function requestIdentifier(const identifier : IRequestIdentifier) : TThrottleMiddlewareFactory;

        function rate(const numOperations : integer; const intervalSecs : integer) : TThrottleMiddlewareFactory;
        function ratePerSecond(const numOperations : integer) : TThrottleMiddlewareFactory;
        function ratePerMinute(const numOperations : integer) : TThrottleMiddlewareFactory;
        function ratePerHour(const numOperations : integer) : TThrottleMiddlewareFactory;
        function ratePerDay(const numOperations : integer) : TThrottleMiddlewareFactory;

        (*!---------------------------------------
         * build middleware instance
         *----------------------------------------
         * @param container dependency container
         * @return instance of middleware
         *----------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    ThrottleMiddlewareImpl,
    MemoryRateLimiterImpl,
    IpAddrRequestIdentifierImpl;

const

    //default limit is 5000 req/sec
    DEFAULT_OPERATIONS = 5000;
    DEFAULT_INTERVAL = 1;

    constructor TThrottleMiddlewareFactory.create();
    begin
        //default rate limiter using memory storage
        fRateLimiter := TMemoryRateLimiter.create();
        //default identifier is IP address
        fRequestIdentifier := TIpAddrRequestIdentifier.create();
        //rate
        fRate.operations := DEFAULT_OPERATIONS;
        fRate.interval := DEFAULT_INTERVAL;
    end;

    function TThrottleMiddlewareFactory.rateLimiter(
        const limiter : IRateLimiter
    ) : TThrottleMiddlewareFactory;
    begin
        fRateLimiter := limiter;
        result := self;
    end;

    function TThrottleMiddlewareFactory.requestIdentifier(
        const identifier : IRequestIdentifier
    ) : TThrottleMiddlewareFactory;
    begin
        fRequestIdentifier := identifier;
        result := self;
    end;

    function TThrottleMiddlewareFactory.rate(
        const numOperations : integer;
        const intervalSecs : integer
    ) : TThrottleMiddlewareFactory;
    begin
        fRate.operations := numOperations;
        fRate.interval := intervalSecs;
        result := self;
    end;

    function TThrottleMiddlewareFactory.ratePerSecond(
        const numOperations : integer
    ) : TThrottleMiddlewareFactory;
    begin
        rate(numOperations, 1);
        result := self;
    end;

    function TThrottleMiddlewareFactory.ratePerMinute(
        const numOperations : integer
    ) : TThrottleMiddlewareFactory;
    const NUM_SECONDS_IN_MINUTE = 60;
    begin
        rate(numOperations, NUM_SECONDS_IN_MINUTE);
        result := self;
    end;

    function TThrottleMiddlewareFactory.ratePerHour(
        const numOperations : integer
    ) : TThrottleMiddlewareFactory;
    const NUM_SECONDS_IN_HOUR = 60 * 60;
    begin
        rate(numOperations, NUM_SECONDS_IN_HOUR);
        result := self;
    end;

    function TThrottleMiddlewareFactory.ratePerDay(const numOperations : integer) : TThrottleMiddlewareFactory;
    const NUM_SECONDS_IN_DAY = 24 * 60 * 60;
    begin
        rate(numOperations, NUM_SECONDS_IN_DAY);
        result := self;
    end;

    function TThrottleMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TThrottleMiddleware.create(
            fRateLimiter,
            fRequestIdentifier,
            fRate
        );
    end;

end.
