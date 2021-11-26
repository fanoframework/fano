{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ConditionalErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    sysutils,
    ErrorHandlerIntf,
    EnvironmentEnumeratorIntf,
    CompositeErrorHandlerImpl;

type

    (*!---------------------------------------------------
     * error handler that is composed from two error handler
     * that is conditionally choosed based on some condition
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TConditionalErrorHandler = class abstract (TCompositeErrorHandler)
    protected
        function condition(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer;
            const msg : string
        ) : boolean; virtual; abstract;
    public

        function handleError(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer = 500;
            const msg : string  = 'Internal Server Error'
        ) : IErrorHandler; override;
    end;

implementation

    function TConditionalErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    begin
        if condition(env, exc, status, msg) then
        begin
            firstErrorHandler.handleError(env, exc, status, msg);
        end else
        begin
            secondErrorHandler.handleError(env, exc, status, msg);
        end;
        result := self;
    end;
end.
