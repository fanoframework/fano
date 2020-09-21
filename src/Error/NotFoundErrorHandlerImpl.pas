{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NotFoundErrorHandlerImpl;

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
    TNotFoundErrorHandler = class (TConditionalErrorHandler)
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

    ERouteHandlerNotFoundImpl;

    function TNotFoundErrorHandler.condition(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer;
        const msg : string
    ) : boolean;
    begin
        result := exc is ERouteHandlerNotFound;
    end;
end.
