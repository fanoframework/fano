{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    sysutils,
    ErrorHandlerIntf,
    EnvironmentEnumeratorIntf,
    StdOutErrorHandlerImpl;

type

    {------------------------------------------------
     default error handler to surpress error message
     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    TNullErrorHandler = class(TStdOutErrorHandler)
    public
        function handleError(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer = 500;
            const msg : string  = 'Internal Server Error'
        ) : IErrorHandler; override;
    end;

implementation

    function TNullErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    begin
        fStdOut.writeln('Content-Type: text/html');
        fStdOut.writeln('Status: ', intToStr(status), ' ', msg);
        fStdOut.writeln();
        fStdOut.writeln('');
        result := self;
    end;
end.
