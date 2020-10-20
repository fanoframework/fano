{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompositeErrorHandlerImpl;

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
     * error handler that is composed from two error handler
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TCompositeErrorHandler = class(TBaseErrorHandler)
    protected
        firstErrorHandler : IErrorHandler;
        secondErrorHandler : IErrorHandler;
    public

        (*!---------------------------------------------------
         * constructor
         *---------------------------------------------------
         * @param firstErrHandler first error handler
         * @param secondErrHandler second error handler
         *---------------------------------------------------*)
        constructor create(
            const firstErrHandler : IErrorHandler;
            const secondErrHandler : IErrorHandler
        );
        destructor destroy(); override;

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
     * @param firstErrHandler first error handler
     * @param secondErrHandler second error handler
     *---------------------------------------------------*)
    constructor TCompositeErrorHandler.create(
        const firstErrHandler : IErrorHandler;
        const secondErrHandler : IErrorHandler
    );
    begin
        firstErrorHandler := firstErrHandler;
        secondErrorHandler := secondErrHandler;
    end;

    destructor TCompositeErrorHandler.destroy();
    begin
        inherited destroy();
        firstErrorHandler := nil;
        secondErrorHandler := nil;
    end;

    function TCompositeErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    begin
        firstErrorHandler.handleError(env, exc, status, msg);
        secondErrorHandler.handleError(env, exc, status, msg);
        result := self;
    end;
end.
