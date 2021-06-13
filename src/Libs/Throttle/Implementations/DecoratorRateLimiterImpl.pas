{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorRateLimiterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RateLimiterIntf,
    RateTypes;

type

    (*!------------------------------------------------
     * decorator rate limiter implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDecoratorRateLimiter = class (TInterfacedObject, IRateLimiter)
    protected
        fActualRateLimiter : IRateLimiter;
    public
        constructor create(const actualRateLimiter : IRateLimiter);

        (*!------------------------------------------------
         * check if number of operations identified by identifier
         * not exceed rate configuration
         *-----------------------------------------------
         * @param identifier unique identifier
         * @param rate rate configuration
         * @return limit status
         *-----------------------------------------------*)
        function limit(
            const identifier : shortstring;
            const rate : TRate
        ) : TLimitStatus; virtual;

    end;

implementation

    constructor TDecoratorRateLimiter.create(const actualRateLimiter : IRateLimiter);
    begin
        fActualRateLimiter := actualRateLimiter;
    end;

    (*!------------------------------------------------
     * check if number of operations identified by identifier
     * not exceed rate configuration
     *-----------------------------------------------
     * @param identifier unique identifier
     * @param rate rate configuration
     * @return limit status
    *-----------------------------------------------*)
    function TDecoratorRateLimiter.limit(
        const identifier : shortstring;
        const rate : TRate
    ) : TLimitStatus;
    begin
        result := fActualRateLimiter.limit(identifier, rate);
    end;

end.
