{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit TooManyRequestsErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    sysutils,
    ErrorHandlerIntf,
    EnvironmentEnumeratorIntf,
    ConditionalErrorHandlerImpl;

type

    (*!---------------------------------------------------
     * error handler that handle ERouteHandlerNotFound exception
     * or pass to default error handler
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TTooManyRequestsErrorHandler = class (TConditionalErrorHandler)
    protected
        function condition(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer;
            const msg : string
        ) : boolean; override;
    end;

implementation

uses

    ETooManyRequestsImpl;

    function TTooManyRequestsErrorHandler.condition(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer;
        const msg : string
    ) : boolean;
    begin
        result := exc is ETooManyRequests;
    end;
end.
