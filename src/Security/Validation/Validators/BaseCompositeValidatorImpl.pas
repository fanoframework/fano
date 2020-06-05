{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BaseCompositeValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    RequestIntf,
    ValidatorIntf,
    BaseValidatorImpl,
    ValidatorArrayTypes;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate data using one or more validator
     * This is provided to allow complex validation using
     * several simple validator
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *------------------------------------------------*)
    TBaseCompositeValidator = class(TBaseValidator)
    protected
        fValidators : TValidatorArray;
    protected
        (*!------------------------------------------------
         * actual data validation
         *-------------------------------------------------
         * @param dataToValidate input data
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
        function isValidData(
            const dataToValidate : string;
            const dataCollection : IReadOnlyList;
            const request : IRequest
        ) : boolean; override;
    public
        constructor create(const avalidators : array of IValidator);
        destructor destroy(); override;

    end;

implementation

    function initValidators(const avalidators : array of IValidator) : TValidatorArray;
    var i, len : integer;
    begin
        len := high(avalidators) - low(avalidators) + 1;
        setLength(result, len);
        for i := 0 to len -1 do
        begin
            result[i] := avalidators[i];
        end;
    end;

    function freeValidators(var validators : TValidatorArray) : TValidatorArray;
    var i, len : integer;
    begin
        len := length(validators);
        for i := 0 to len -1 do
        begin
            validators[i] := nil;
        end;
        setLength(validators, 0);
        validators := nil;
        result := validators;
    end;

    constructor TBaseCompositeValidator.create(const avalidators : array of IValidator);
    begin
        //just set empty error string. We will get from external validators
        inherited create('');
        fValidators := initValidators(avalidators);
    end;

    destructor TBaseCompositeValidator.destroy();
    begin
        fValidators := freeValidators(fValidators);
        inherited destroy();
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TBaseCompositeValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    begin
        //intentionally always pass validation
        //because we delegate validation to external validators
        result := true;
    end;

end.
