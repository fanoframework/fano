{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NonBlockingThrottleMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    ThrottleMiddlewareFactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TNonBlockingThrottleMiddleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNonBlockingThrottleMiddlewareFactory = class(TThrottleMiddlewareFactory)
    public

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

    NonBlockingThrottleMiddlewareImpl;


    function TNonBlockingThrottleMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TNonBlockingThrottleMiddleware.create(
            fRateLimiter,
            fRequestIdentifier,
            fRate
        );
    end;

end.
