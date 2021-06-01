{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BaseErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    sysutils,
    ErrorHandlerIntf,
    EnvironmentEnumeratorIntf,
    InjectableObjectImpl;

type

    (*!---------------------------------------------------
     * base custom error handler that user must inherit and
     * provide template to be displayed
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TBaseErrorHandler = class abstract (TInjectableObject, IErrorHandler)
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
        ) : IErrorHandler; virtual; abstract;
    end;

implementation

end.
