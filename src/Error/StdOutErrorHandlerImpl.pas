{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdOutErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    sysutils,
    ErrorHandlerIntf,
    StdOutIntf,
    EnvironmentEnumeratorIntf,
    InjectableObjectImpl;

type

    (*!---------------------------------------------------
     * base custom error handler that output to stdout
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TStdOutErrorHandler = class abstract (TInjectableObject, IErrorHandler)
    protected
        fStdOut : IStdOut;
    public
        constructor create(const astdout : IStdOut);
        destructor destroy(); override;

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
        ) : IErrorHandler; virtual; abstract;
    end;

implementation

    constructor TStdOutErrorHandler.create(const astdout : IStdOut);
    begin
        fStdOut := astdout;
    end;

    destructor TStdOutErrorHandler.destroy();
    begin
        fStdOut := nil;
        inherited destroy();
    end;

end.
