{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
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

    protected
        function readRateLimit(
            const identifier : shortstring
        ) : PRateLimitRec; override;

        (*!------------------------------------------------
         * insert new rate limit info to storage
         *
         * @param identifier id to locate info from storage
         *-----------------------------------------------*)
        procedure createRateLimit(
            const identifier : shortstring;
            rateLimit: PRateLimitRec
        ); override;

        (*!------------------------------------------------
         * update rate limit info to storage
         *
         * @param identifier id to locate info from storage
         *-----------------------------------------------*)
        procedure updateRateLimit(
            const identifier : shortstring;
            rateLimit: PRateLimitRec
        ); override;

    public
        constructor create();
        destructor destroy(); override;

    end;

implementation


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

    function TMemoryRateLimiter.readRateLimit(
        const identifier : shortstring
    ) : PRateLimitRec;
    begin
        result := fStorage.find(identifier);
    end;

    (*!------------------------------------------------
     * insert new rate limit info to storage
     *
     * @param identifier id to locate info from storage
     *-----------------------------------------------*)
    procedure TMemoryRateLimiter.createRateLimit(
        const identifier : shortstring;
        rateLimit: PRateLimitRec
    );
    begin
        fStorage.add(identifier, rateLimit);
    end;

    (*!------------------------------------------------
     * update rate limit info to storage
     *
     * @param identifier id to locate info from storage
     *-----------------------------------------------*)
    procedure TMemoryRateLimiter.updateRateLimit(
        const identifier : shortstring;
        rateLimit: PRateLimitRec
    );
    begin
        //intentionally does nothing as update record means
        //data in fStorage will be updated too
    end;

end.
