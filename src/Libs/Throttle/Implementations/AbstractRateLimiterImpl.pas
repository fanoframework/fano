{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractRateLimiterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RateLimiterIntf,
    RateTypes;

type

    (*!------------------------------------------------
     * abstract rate limiter implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractRateLimiter = class abstract (TInterfacedObject, IRateLimiter)
    public
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
        ) : TLimitStatus; virtual; abstract;

    end;

implementation

end.
