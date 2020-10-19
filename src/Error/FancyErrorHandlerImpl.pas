{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FancyErrorHandlerImpl;

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
     * modern look default error handler for debugging
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TFancyErrorHandler = class(TBaseErrorHandler)
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

    {$INCLUDE Includes/head.html.inc}

    function TFancyErrorHandler.getStackTrace(const e : Exception) : string;
    var
        i: integer;
        frames: PPointer;
        strExcAddr : string;
    begin
        result := '';
        if (e <> nil) then
        begin
            result := result +
                '<section class="wrapper"><div class="inner">' +
                '<div>Exception : <strong>' + e.className + '</strong></div>' +
                '<div><em>' + e.message + '</em></div></div></section>';
        end;

        strExcAddr := BackTraceStrFunc(ExceptAddr);
        result := result +
            '<section class="wrapper"><div class="inner"><h3>Stacktrace:</h3>' +
            '<pre><code>' + strExcAddr + LineEnding;

        frames := ExceptFrames;
        for i := 0 to ExceptFrameCount - 1 do
        begin
            strExcAddr := BackTraceStrFunc(frames[i]);
            result := result + strExcAddr + LineEnding;
        end;
        result := result + '</code></pre></div></section>';
    end;

    function TFancyErrorHandler.getEnvTrace(const env: ICGIEnvironmentEnumerator) : string;
    var indx, totEnv, valPos: integer;
        key, value : string;
    begin
        totEnv := env.count();
        result := '<section class="wrapper"><div class="inner"><h3>Environments:</h3><ul>';

        for indx := 0 to totEnv-1 do
        begin
            key := env.getKey(indx);
            value := env.getValue(indx);
            valPos := pos('=' + value, key);
            if valPos <> 0 then
            begin
                //key in CGI sometimes include its value too, strip that if any
                key := copy(key, 1, valPos - 1);
            end;
            result := result + '<li><h5>' + key + '</h5>'+
                '<pre><code>' + value + '</code></pre></li>';
        end;

        result := result + '</ul></div></section>';
    end;

    function TFancyErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    begin
        writeln('Content-Type: text/html');
        writeln('Status: ', intToStr(status), ' ', msg);
        writeln();
        writeln(STR_HEAD_HTML);
        writeln(getStackTrace(exc));
        writeln(getEnvTrace(env));
        writeln('</div></body></html>');
        result := self;
    end;
end.
