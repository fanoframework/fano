{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    SysUtils,
    ErrorHandlerIntf,
    EnvironmentEnumeratorIntf,
    DecoratorErrorHandlerImpl;

type

    (*!---------------------------------------------------
     * thread-safe error handler that is decorate another error handler
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TThreadSafeErrorHandler = class (TDecoratorErrorHandler)
    private
        fCriticalSection : TCriticalSection;
    public
        (*!---------------------------------------------------
         * constructor
         *---------------------------------------------------
         * @param errHandler decorated error handler
         *---------------------------------------------------*)
        constructor create(const errHandler : IErrorHandler);
        destructor destroy(); override;

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
        ) : IErrorHandler; override;
    end;

implementation

    (*!---------------------------------------------------
     * constructor
     *---------------------------------------------------
     * @param errHandler first error handler
     *---------------------------------------------------*)
    constructor TThreadSafeErrorHandler.create(const errHandler : IErrorHandler);
    begin
        inherited create(errHandler);
        fCriticalSection := TCriticalSection.create();
    end;

    destructor TThreadSafeErrorHandler.destroy();
    begin
        fCriticalSection.free();
        inherited destroy();
    end;

    (*!---------------------------------------------------
     * handle exception
     *----------------------------------------------------
     * @param env environment enumerator
     * @param exc exception that is to be handled
     * @param status HTTP error status, default is HTTP error 500
     * @param msg HTTP error message
     * @return current instance
     *---------------------------------------------------*)
    function TThreadSafeErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    begin
        fCriticalSection.acquire();
        try
            fErrorHandler.handleError(env, exc, status, msg);
        finally
            fCriticalSection.release();
        end;
    end;
end.
