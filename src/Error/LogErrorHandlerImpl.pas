{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit LogErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    sysutils,
    ErrorHandlerIntf,
    LoggerIntf,
    EnvironmentEnumeratorIntf,
    BaseErrorHandlerImpl;

type

    (*!---------------------------------------------------
     * error handler that log error information instead
     * outputting client
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TLogErrorHandler = class(TBaseErrorHandler)
    private
        logger : ILogger;

        function getStackTrace(
            const e: Exception;
            const httpStatus : integer;
            const httpMsg : string
        ) : string;
    public

        constructor create(const aLogger : ILogger);
        destructor destroy(); override;

        function handleError(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer = 500;
            const msg : string  = 'Internal Server Error'
        ) : IErrorHandler; override;
    end;

implementation

    constructor TLogErrorHandler.create(const aLogger : ILogger);
    begin
        logger := aLogger;
    end;

    destructor TLogErrorHandler.destroy();
    begin
        inherited destroy();
        logger := nil;
    end;

    function TLogErrorHandler.getStackTrace(
        const e : Exception;
        const httpStatus : integer;
        const httpMsg : string
    ) : string;
    var
        i: integer;
        frames: PPointer;
    begin
        result := '------Program Exception--------' + LineEnding +
            'HTTP Status : ' + inttostr(httpStatus) + LineEnding +
            'HTTP Message : ' + httpMsg + LineEnding;
        if (e <> nil) then
        begin
            result := result +
                'Exception class : ' + e.className  + LineEnding  +
                'Message : ' + e.message + LineEnding;
        end;

        result := result + 'Stacktrace:' + LineEnding +
            LineEnding + BackTraceStrFunc(ExceptAddr) + LineEnding;

        frames := ExceptFrames;
        for i := 0 to ExceptFrameCount - 1 do
        begin
            result := result + BackTraceStrFunc(frames[i]) + LineEnding;
        end;
        result := result + '-----------------------' + LineEnding;
    end;

    function TLogErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    begin
        logger.critical(getStackTrace(exc, status, msg));
        result := self;
    end;
end.
