{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
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

    TRateLimitRec = record
        //total number of operations recorded
        currentOperations : integer;

        //timestamp when this record should be reset
        resetTimestamp : integer;
    end;
    PRateLimitRec = ^TRateLimitRec;

    (*!------------------------------------------------
     * abstract rate limiter implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractRateLimiter = class abstract (TInterfacedObject, IRateLimiter)
    protected
        (*!------------------------------------------------
         * read rate limit info from storage
         *
         * @param identifier id to locate info from storage
         *-----------------------------------------------*)
        function readRateLimit(
            const identifier : shortstring
        ) : PRateLimitRec; virtual; abstract;

        (*!------------------------------------------------
         * insert new rate limit info to storage
         *
         * @param identifier id to locate info from storage
         *-----------------------------------------------*)
        procedure createRateLimit(
            const identifier : shortstring;
            rateLimit: PRateLimitRec
        ); virtual; abstract;

        (*!------------------------------------------------
         * update rate limit info to storage
         *
         * @param identifier id to locate info from storage
         *-----------------------------------------------*)
        procedure updateRateLimit(
            const identifier : shortstring;
            rateLimit: PRateLimitRec
        ); virtual; abstract;

        (*!------------------------------------------------
         * count number of operations identified by identifier
         *-----------------------------------------------
         * @param identifier unique identifier
         * @param rate rate configuration
         * @return total number of operation and reset timestamp
         *-----------------------------------------------*)
        function countHit(
            const identifier : shortstring;
            const rate : TRate
        ) : TRateLimitRec; virtual;
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
        ) : TLimitStatus; virtual;

    end;

implementation

uses

    SysUtils,
    DateUtils;

    (*!------------------------------------------------
     * count number of operations identified by identifier
     *-----------------------------------------------
     * @param identifier unique identifier
     * @param rate rate configuration
     * @return total number of operation and reset timestamp
     *-----------------------------------------------*)
    function TAbstractRateLimiter.countHit(
        const identifier : shortstring;
        const rate : TRate
    ) : TRateLimitRec;
    var rateLimitRec : PRateLimitRec;
        currTimestamp : integer;
    begin
        currTimestamp := DateTimeToUnix(Now);
        rateLimitRec := readRateLimit(identifier);
        if (rateLimitRec = nil) then
        begin
            //identifier not yet tracked, store it
            new(rateLimitRec);
            rateLimitRec^.currentOperations := 1;
            rateLimitRec^.resetTimestamp := currTimestamp + rate.interval;
            createRateLimit(identifier, rateLimitRec);
        end else
        begin
            if currTimestamp < rateLimitRec^.resetTimestamp then
            begin
                inc(rateLimitRec^.currentOperations);
            end else
            begin
                //expired, reset its value
                rateLimitRec^.currentOperations := 1;
                rateLimitRec^.resetTimestamp := currTimestamp + rate.interval;
            end;
            updateRateLimit(identifier, rateLimitRec);
        end;

        result := rateLimitRec^;
    end;

    (*!------------------------------------------------
     * check if number of operations identified by identifier
     * not exceed rate configuration
     *-----------------------------------------------
     * @param identifier unique identifier
     * @param rate rate configuration
     * @return boolean true if limit is reached, false otherwise
     *-----------------------------------------------*)
    function TAbstractRateLimiter.limit(
        const identifier : shortstring;
        const rate : TRate
    ) : TLimitStatus;
    var statusHit : TRateLimitRec;
    begin
        statusHit := countHit(identifier, rate);
        result.limitReached := (statusHit.currentOperations > rate.operations);
        result.limit := rate.operations;
        result.remainingAttempts := rate.operations - statusHit.currentOperations;
        if result.remainingAttempts < 0 then
        begin
            result.remainingAttempts := 0;
        end;
        result.resetTimestamp := statusHit.resetTimestamp;
        result.retryAfter := statusHit.resetTimestamp - DateTimeToUnix(Now);
        if (result.retryAfter < 0) then
        begin
            result.retryAfter := 0;
        end;
    end;

end.
