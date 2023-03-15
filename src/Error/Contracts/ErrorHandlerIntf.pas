{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ErrorHandlerIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    EnvironmentEnumeratorIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to handle
     * exception
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IErrorHandler = interface
        ['{2D6BF281-BBF9-41A0-BE5D-33E84E39B1C6}']

        (*!---------------------------------------------------
         * handle exception
         *----------------------------------------------------
         * @param env environment enumerator
         * @param exc exception that is to be handled
         * @param status HTTP error status, default is HTTP error 500
         * @param msg HTTP error message
         * @return current instance
         *---------------------------------------------------*)
        function handleError(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer = 500;
            const msg : string  = 'Internal Server Error'
        ) : IErrorHandler;
    end;

implementation
end.
