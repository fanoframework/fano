{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AjaxErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    sysutils,
    DependencyIntf,
    ErrorHandlerIntf,
    EnvironmentEnumeratorIntf,
    BaseErrorHandlerImpl;

type

    (*!---------------------------------------------------
     * default error handler for debugging that returns
     * error response as JSON
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TAjaxErrorHandler = class(TBaseErrorHandler)
    private
        function getStackTrace(const e: Exception) : string;
    public
        (*!---------------------------------------------------
         * handle exception
         *----------------------------------------------------
         * @param exc exception that is to be handled
         * @param status HTTP error status, default is HTTP error 500
         * @param msg HTTP error message
         *---------------------------------------------------*)
        function handleError(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer = 500;
            const msg : string  = 'Internal Server Error'
        ) : IErrorHandler; override;
    end;

implementation

    function TAjaxErrorHandler.getStackTrace(const e : Exception) : string;
    var
        i, len: integer;
        frames: PPointer;
    begin
        result := '{';
        if (e <> nil) then
        begin
            result := result +
                '"exception" : "' + e.className + '",' + LineEnding  +
                '"message" : "' + stringReplace(e.message, '"', '\"', [rfReplaceAll]) + '",' + LineEnding;
        end;

        result := result + '"stacktrace": {' +
            '"exception_address" : "' + trimLeft(BackTraceStrFunc(ExceptAddr)) + '",' + LineEnding +
            '"traces" : [';

        frames := ExceptFrames;
        len := ExceptFrameCount();
        for i := 0 to len - 1 do
        begin
            result := result + '"' + trimLeft(BackTraceStrFunc(frames[i])) + '"';
            if (i < len - 1) then
            begin
                result := result + ',' + LineEnding;
            end else
            begin
                result := result + LineEnding;
            end;
        end;
        result := result + ']' + LineEnding + '}' + LineEnding + '}';
    end;

    (*!---------------------------------------------------
     * handle exception
     *----------------------------------------------------
     * @param exc exception that is to be handled
     * @param status HTTP error status, default is HTTP error 500
     * @param msg HTTP error message
     *---------------------------------------------------*)
    function TAjaxErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    begin
        writeln('Content-Type: application/json');
        writeln('Status: ', intToStr(status), ' ', msg);
        writeln();
        writeln(getStackTrace(exc));
        result := self;
    end;
end.
