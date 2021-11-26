{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ValidationImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    ReadOnlyListIntf,
    ListIntf,
    RequestIntf,
    ValidatorIntf,
    RequestValidatorintf,
    ValidationRulesIntf,
    ValidationResultTypes,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * basic validation class having capability to
     * validate input data from request instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TValidation = class(TInjectableObject, IRequestValidator, IValidationRules)
    private
        validationResult : TValidationResult;
        validatorList : IList;
        procedure clearValidator();
        function validateKeyValue(const inputData : IReadOnlyList; const request : IRequest) : TValidationResult;
    public

        constructor create(const validators : IList);
        destructor destroy(); override;

        (*!------------------------------------------------
         * Validate data from request
         *-------------------------------------------------
         * @param request request instance to validate
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
        function validate(const request : IRequest) : TValidationResult;

        (*!------------------------------------------------
         * get last validation status result
         *-------------------------------------------------
         * @return validation result
         *-------------------------------------------------
         * This mechanism is provided to allow application doing
         * validation in middleware before controller and then
         * get validation result in controller/route handler
         * with assumption that it is same request validator
         * instance that is used in middleware and
         * controller/route handler.
         * IRequestValidator implementation must maintain
         * state of last validate() call result.
         *-------------------------------------------------*)
        function lastValidationResult() : TValidationResult;

        (*!------------------------------------------------
         * Add rule and its validator
         *-------------------------------------------------
         * @param key name of field in GET, POST request input data
         * @return current validation rules
         *-------------------------------------------------*)
        function addRule(const key : shortstring; const validator : IValidator) : IValidationRules;
    end;

implementation

uses

    KeyValueTypes,
    EInvalidValidatorImpl;

resourcestring

    sErrInvalidValidator = 'Validator for %s can not be nil';

type

    TValidatorRec = record
        key : shortstring;
        validator : IValidator;
    end;
    PValidatorRec = ^TValidatorRec;

    constructor TValidation.create(const validators : IList);
    begin
        validatorList := validators;
        validationResult.isValid := true;
        validationResult.errorMessages := nil;
    end;

    destructor TValidation.destroy();
    begin
        clearValidator();
        validatorList := nil;
        inherited destroy();
    end;

    procedure TValidation.clearValidator();
    var i, len : integer;
        valRec : PValidatorRec;
    begin
        len := validatorList.count();
        for i := len-1 downto 0 do
        begin
            valRec := validatorList.get(i);
            valRec^.validator := nil;
            dispose(valRec);
            validatorList.delete(i);
        end;
    end;

    (*!------------------------------------------------
     * Validate data from key value pair array
     *-------------------------------------------------
     * @param inputData array of key value pair
     * @param request request object
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TValidation.validateKeyValue(
        const inputData : IReadOnlyList;
        const request : IRequest
    ) : TValidationResult;
    var i, len, numFailValidation : integer;
        valRec : PValidatorRec;
    begin
        result := default(TValidationResult);
        result.isValid := true;
        len := validatorList.count();

        //assume all validator will fail
        setLength(result.errorMessages, len);
        numFailValidation := 0;
        for i:= 0 to len-1 do
        begin
            valRec := validatorList.get(i);
            if (not valRec^.validator.isValid(valRec^.key, inputData, request)) then
            begin
                //validation is failed, get validation error message
                with result.errorMessages[numFailValidation] do
                begin
                    key := valRec^.key;
                    errorMessage := valRec^.validator.errorMessage(valRec^.key);
                end;
                inc(numFailValidation);
                result.isValid := false;
            end;
        end;
        //set to actual number of failed validation
        setLength(result.errorMessages, numFailValidation);
    end;

    (*!------------------------------------------------
     * Validate data from request
     *-------------------------------------------------
     * @param request request instance to validate
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TValidation.validate(const request : IRequest)  : TValidationResult;
    begin
        validationResult := validateKeyValue(request.getParams(), request);
        result := validationResult;
    end;

    (*!------------------------------------------------
     * get last validation status result
     *-------------------------------------------------
     * @return validation result
     *-------------------------------------------------*)
    function TValidation.lastValidationResult() : TValidationResult;
    begin
        result := validationResult;
    end;

    (*!------------------------------------------------
     * Add rule and its validator
     *-------------------------------------------------
     * @param key name of field in GET, POST request input data
     * @return current validation rules
     *-------------------------------------------------*)
    function TValidation.addRule(const key : shortstring; const validator : IValidator) : IValidationRules;
    var valRec : PValidatorRec;
    begin
        if (validator = nil) then
        begin
            raise EInvalidValidator.createFmt(sErrInvalidValidator, [key]);
        end;

        valRec := validatorList.find(key);
        if (valRec = nil) then
        begin
            new(valRec);
            validatorList.add(key, valRec);
        end;
        valRec^.key := key;
        valRec^.validator := validator;
        result := self;
    end;


end.
