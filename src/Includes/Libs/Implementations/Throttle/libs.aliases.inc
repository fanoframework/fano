{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * redeclare all class types in unit inside Libs/Mailer
 * directory
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)
TAbstractRateLimiter = AbstractRateLimiterImpl.TAbstractRateLimiter;
TDecoratorRateLimiter = DecoratorRateLimiterImpl.TDecoratorRateLimiter;
TMemoryRateLimiter = MemoryRateLimiterImpl.TMemoryRateLimiter;
TDbRateLimiter = DbRateLimiterImpl.TDbRateLimiter;

TAbstractRequestIdentifier = AbstractRequestIdentifierImpl.TAbstractRequestIdentifier;
TIpAddrRequestIdentifier = IpAddrRequestIdentifierImpl.TIpAddrRequestIdentifier;
TSessionRequestIdentifier = SessionRequestIdentifierImpl.TSessionRequestIdentifier;
TQueryParamRequestIdentifier = QueryParamRequestIdentifierImpl.TQueryParamRequestIdentifier;

TThrottleMiddleware = ThrottleMiddlewareImpl.TThrottleMiddleware;
TThrottleMiddlewareFactory = ThrottleMiddlewareFactoryImpl.TThrottleMiddlewareFactory;
TNonBlockingThrottleMiddleware = NonBlockingThrottleMiddlewareImpl.TNonBlockingThrottleMiddleware;
TNonBlockingThrottleMiddlewareFactory = NonBlockingThrottleMiddlewareFactoryImpl.TNonBlockingThrottleMiddlewareFactory;

TRate = RateTypes.TRate;
TLimitStatus = RateTypes.TLimitStatus;
