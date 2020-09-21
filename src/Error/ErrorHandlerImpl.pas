{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    sysutils,
    ErrorHandlerIntf,
    EnvironmentEnumeratorIntf,
    BaseErrorHandlerImpl;

type

    (*!---------------------------------------------------
     * default error handler for debugging
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TErrorHandler = class(TBaseErrorHandler)
    private
        function getStackTrace(const e: Exception) : string;
        function getEnvTrace(const env: ICGIEnvironmentEnumerator) : string;
    public
        function handleError(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer = 500;
            const msg : string  = 'Internal Server Error'
        ) : IErrorHandler; override;
    end;

implementation

    function TErrorHandler.getStackTrace(const e : Exception) : string;
    var
        i: integer;
        frames: PPointer;
    begin
        result := '';
        if (e <> nil) then
        begin
            result := result +
                '<div>Exception class : <strong>' + e.className + '</strong></div>' + LineEnding  +
                '<div>Message : <strong>' + e.message + '</strong></div>'+ LineEnding;
        end;

        result := result + '<div>Stacktrace:</div>' + LineEnding +
            '<pre>' + LineEnding + BackTraceStrFunc(ExceptAddr) + LineEnding;

        frames := ExceptFrames;
        for i := 0 to ExceptFrameCount - 1 do
        begin
            result := result + BackTraceStrFunc(frames[i]) + LineEnding;
        end;
        result := result + '</pre>';
    end;

    function TErrorHandler.getEnvTrace(const env: ICGIEnvironmentEnumerator) : string;
    var indx, totEnv: integer;
    begin
        totEnv := env.count();
        result := '<h3>Environments</h3><table border="1">' +
            '<tr><th>Name</th><th>Value</th></tr>';

        for indx := 0 to totEnv-1 do
        begin
            result := result + '<tr><td>' + env.getKey(indx) + '</td>'+
                '<td>' + env.getValue(indx) + '</td></tr>';
        end;

        result := result + '</table>';
    end;

    function TErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    begin
        writeln('Content-Type: text/html');
        writeln('Status: ', intToStr(status), ' ', msg);
        writeln();
        writeln(
            '<!DOCTYPE html><html><head>' +
            '<title>Fano Application Error</title></head><body>' +
            '<h2>Fano Application Error</h2>'
        );
        writeln(getStackTrace(exc));
        writeln(getEnvTrace(env));
        writeln('</body></html>');
        result := self;
    end;
end.
