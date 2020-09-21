{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BoolErrorHandlerImpl;

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
     * error handler that is composed from two error handler
     * that is conditionally choosed based on some boolean condition
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TBoolErrorHandler = class (TConditionalErrorHandler)
    private
        fCondition : boolean;
    protected
        function condition(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer;
            const msg : string
        ) : boolean; override;
    public
        (*!---------------------------------------------------
         * constructor
         *---------------------------------------------------
         * @param firstErrHandler first error handler
         * @param secondErrHandler second error handler
         * @param boolCondition if true then use first handler otherwise
         *        use second handler
         *---------------------------------------------------*)
        constructor create(
            const firstErrHandler : IErrorHandler;
            const secondErrHandler : IErrorHandler;
            const boolCondition : boolean
        );
    end;

implementation

    (*!---------------------------------------------------
     * constructor
     *---------------------------------------------------
     * @param firstErrHandler first error handler
     * @param secondErrHandler second error handler
     * @param condition if true then use first handler otherwise
     *        use second handler
     *---------------------------------------------------*)
    constructor TBoolErrorHandler.create(
        const firstErrHandler : IErrorHandler;
        const secondErrHandler : IErrorHandler;
        const boolCondition : boolean
    );
    begin
        inherited create(firstErrHandler, secondErrHandler);
        fCondition := boolCondition;
    end;

    function TBoolErrorHandler.condition(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer;
        const msg : string
    ) : boolean;
    begin
        result := fCondition;
    end;
end.
