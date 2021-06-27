{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit GroupErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    sysutils,
    ErrorHandlerIntf,
    EnvironmentEnumeratorIntf,
    BaseErrorHandlerImpl;

type

    TErrorHandlerArray = array of IErrorHandler;

    (*!---------------------------------------------------
     * error handler that is composed from one or more handler
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TGroupErrorHandler = class(TBaseErrorHandler)
    protected
        fErrorHandlers : TErrorHandlerArray;
    public

        (*!---------------------------------------------------
         * constructor
         *---------------------------------------------------
         * @param array of IErrorHandler errHandlerArr
         *---------------------------------------------------*)
        constructor create(const errHandlerArr : array of IErrorHandler);
        destructor destroy(); override;

        function handleError(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer = 500;
            const msg : string  = 'Internal Server Error'
        ) : IErrorHandler; override;
    end;

implementation

    function initErrorHandlers(
        const errorHandlers : array of IErrorHandler
    ) : TErrorHandlerArray;
    var i : integer;
    begin
        result := default(TErrorHandlerArray);
        setLength(result, high(errorHandlers) - low(errorHandlers) + 1);
        for i := low(errorHandlers) to high(errorHandlers) do
        begin
            result[i] := errorHandlers[i];
        end;
    end;

    procedure freeErrorHandlers(var errorHandlers : TErrorHandlerArray);
    var i : integer;
    begin
        for i := 0 to length(errorHandlers) - 1 do
        begin
            errorHandlers[i] := nil;
        end;
        setLength(errorHandlers, 0);
        errorHandlers := nil;
    end;

    (*!---------------------------------------------------
     * constructor
     *---------------------------------------------------
     * @param array of IErrorHandler errHandlerArr
     *---------------------------------------------------*)
    constructor TGroupErrorHandler.create(
        const errHandlerArr : array of IErrorHandler
    );
    begin
        fErrorHandlers := initErrorHandlers(errHandlerArr);
    end;

    destructor TGroupErrorHandler.destroy();
    begin
        freeErrorHandlers(fErrorHandlers);
        inherited destroy();
    end;

    function TGroupErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    var i : integer;
    begin
        result := self;
        for i := 0 to length(fErrorHandlers) - 1 do
        begin
            fErrorHandlers[i].handleError(env, exc, status, msg);
        end;
    end;
end.
