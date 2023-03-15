{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThrottleRequestImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    RateTypes,
    ThrottleRequestIntf,
    DecoratorRequestImpl;

type

    (*!------------------------------------------------
     * HTTP request with additional rate
     * limiting data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThrottleRequest = class (TDecoratorRequest, IRequest, IThrottleRequest)
    private
        fLimitStatus : TLimitStatus;
        fLimitReachedKey : string;
        fLimitKey : string;
        fRemainingAttemptsKey : string;
        fResetTimestampKey : string;
        fRetryAfterKey : string;
    public
        constructor create(
            const request : IRequest;
            const alimitStatus : TLimitStatus;
            const limitReachedKey : string = '__limitreached';
            const limitKey : string = '__limit';
            const remainingAttemptsKey : string = '__remaining_attempts';
            const resetTimestampKey : string = '__reset_timestamp';
            const retryAfterKey : string = '__retry_after'
        );

        (*!------------------------------------------------
         * get request query string or body data
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getParam(const key: string; const defValue : string = '') : string; override;

        (*!------------------------------------------------
         * get rate limit status
         *-------------------------------------------------
         * @return limit status of current request
         *------------------------------------------------*)
        function getLimitStatus() : TLimitStatus;
    end;

implementation

uses

    SysUtils;

    constructor TThrottleRequest.create(
        const request : IRequest;
        const alimitStatus : TLimitStatus;
        const limitReachedKey : string = '__limitreached';
        const limitKey : string = '__limit';
        const remainingAttemptsKey : string = '__remaining_attempts';
        const resetTimestampKey : string = '__reset_timestamp';
        const retryAfterKey : string = '__retry_after'
    );
    begin
        inherited create(request);
        fLimitStatus := alimitStatus;
        fLimitReachedKey := limitReachedKey;
        fLimitKey := limitKey;
        fRemainingAttemptsKey := remainingAttemptsKey;
        fResetTimestampKey := resetTimestampKey;
        fRetryAfterKey := retryAfterKey;
    end;

    (*!------------------------------------------------
     * get rate limit status
     *-------------------------------------------------
     * @return limit status of current request
     *------------------------------------------------*)
    function TThrottleRequest.getLimitStatus() : TLimitStatus;
    begin
        result := fLimitStatus;
    end;

    (*!------------------------------------------------
     * get request query string or body data
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TThrottleRequest.getParam(const key: string; const defValue : string = '') : string;
    begin
        if key = fLimitReachedKey then
        begin
            result := boolToStr(fLimitStatus.limitReached);
        end else
        if key = fLimitKey then
        begin
            result := intToStr(fLimitStatus.limit);
        end else
        if key = fRemainingAttemptsKey then
        begin
            result := intToStr(fLimitStatus.remainingAttempts);
        end else
        if key = fResetTimestampKey then
        begin
            result := intToStr(fLimitStatus.resetTimestamp);
        end else
        if key = fRetryAfterKey then
        begin
            result := intToStr(fLimitStatus.retryAfter);
        end else
        begin
            result := fActualRequest.getParam(key, defValue);
        end;
    end;

end.
