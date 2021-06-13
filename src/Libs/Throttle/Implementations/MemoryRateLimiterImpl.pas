{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MemoryRateLimiterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    contnrs,
    RateTypes,
    AbstractRateLimiterImpl;

type

    TRateLimitRec = record
        //total number of operations recorded
        currentOperations : integer;

        //timestamp when this record should be reset
        resetTimestamp : integer;
    end;
    PRateLimitRec = ^TRateLimitRec;

    (*!------------------------------------------------
     * rate limiter implementation which store its
     * state in memory
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMemoryRateLimiter = class(TAbstractRateLimiter)
    private
        fStorage : TFPHashList;

        procedure cleanUpStorage();

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
        ) : TRateLimitRec;

    public
        constructor create();
        destructor destroy(); override;

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
        ) : TLimitStatus; override;

    end;

implementation

uses

    SysUtils,
    DateUtils;

    constructor TMemoryRateLimiter.create();
    begin
        fStorage := TFPHashList.create();
    end;

    destructor TMemoryRateLimiter.destroy();
    begin
        cleanUpStorage();
        inherited destroy();
    end;

    procedure TMemoryRateLimiter.cleanUpStorage();
    var i : integer;
        rateLimitRec : PRateLimitRec;
    begin
        for i := fStorage.count - 1 downto 0 do
        begin
            rateLimitRec := fStorage.items[i];
            fStorage.delete(i);
            dispose(rateLimitRec);
        end;
        fStorage.free();
    end;

    (*!------------------------------------------------
     * count number of operations identified by identifier
     *-----------------------------------------------
     * @param identifier unique identifier
     * @param rate rate configuration
     * @return total number of operation and reset timestamp
     *-----------------------------------------------*)
    function TMemoryRateLimiter.countHit(
        const identifier : shortstring;
        const rate : TRate
    ) : TRateLimitRec;
    var rateLimitRec : PRateLimitRec;
        currTimestamp : integer;
    begin
        currTimestamp := DateTimeToUnix(Now);
        rateLimitRec := fStorage.find(identifier);
        if (rateLimitRec = nil) then
        begin
            //identifier not yet tracked, store it
            new(rateLimitRec);
            rateLimitRec^.currentOperations := 1;
            rateLimitRec^.resetTimestamp := currTimestamp + rate.interval;
            fStorage.add(identifier, rateLimitRec);
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
    function TMemoryRateLimiter.limit(
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
