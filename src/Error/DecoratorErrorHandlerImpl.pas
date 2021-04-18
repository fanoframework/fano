{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorErrorHandlerImpl;

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
     * error handler that is decorate another error handler
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TDecoratorErrorHandler = class abstract (TBaseErrorHandler)
    protected
        fErrorHandler : IErrorHandler;
    public

        (*!---------------------------------------------------
         * constructor
         *---------------------------------------------------
         * @param errHandler error handler
         *---------------------------------------------------*)
        constructor create(const errHandler : IErrorHandler);
        destructor destroy(); override;
    end;

implementation

    (*!---------------------------------------------------
     * constructor
     *---------------------------------------------------
     * @param firstErrHandler first error handler
     * @param secondErrHandler second error handler
     *---------------------------------------------------*)
    constructor TDecoratorErrorHandler.create(const errHandler : IErrorHandler);
    begin
        fErrorHandler := errHandler;
    end;

    destructor TDecoratorErrorHandler.destroy();
    begin
        fErrorHandler := nil;
        inherited destroy();
    end;

end.
