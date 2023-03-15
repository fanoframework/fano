{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit LoggerErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    LogLevelTypes,
    ErrorHandlerIntf,
    LoggerIntf,
    EnvironmentEnumeratorIntf,
    LogErrorHandlerImpl;

type

    (*!---------------------------------------------------
     * error handler that log error information instead
     * outputting client with capability to define log level
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TLoggerErrorHandler = class(TLogErrorHandler)
    private
        fLogTypes : TLogLevelTypes;
    public

        constructor create(const aLogger : ILogger; const logTypes : TLogLevelTypes);

        function handleError(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer = 500;
            const msg : string  = 'Internal Server Error'
        ) : IErrorHandler; override;
    end;

implementation

    constructor TLoggerErrorHandler.create(
        const aLogger : ILogger;
        const logTypes : TLogLevelTypes
    );
    begin
        inherited create(aLogger);
        fLogTypes := logTypes;
    end;

    function TLoggerErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    begin
        if (logEmergency in fLogTypes) then
        begin
            fLogger.emergency(getStackTrace(exc, status, msg));
        end;

        if (logAlert in fLogTypes) then
        begin
            fLogger.alert(getStackTrace(exc, status, msg));
        end;

        if (logCritical in fLogTypes) then
        begin
            fLogger.critical(getStackTrace(exc, status, msg));
        end;

        if (logError in fLogTypes) then
        begin
            fLogger.error(getStackTrace(exc, status, msg));
        end;

        if (logWarning in fLogTypes) then
        begin
            fLogger.warning(getStackTrace(exc, status, msg));
        end;

        if (logDebug in fLogTypes) then
        begin
            fLogger.debug(getStackTrace(exc, status, msg));
        end;

        if (logInfo in fLogTypes) then
        begin
            fLogger.info(getStackTrace(exc, status, msg));
        end;

        if (logNotice in fLogTypes) then
        begin
            fLogger.notice(getStackTrace(exc, status, msg));
        end;

        result := self;
    end;
end.
