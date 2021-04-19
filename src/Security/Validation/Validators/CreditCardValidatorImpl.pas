{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CreditCardValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    RequestIntf,
    ValidatorIntf,
    ValidatorArrayTypes,
    BaseCompositeValidatorImpl;

type

    (*!------------------------------------------------
     * class having capability to validate credit card number
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCreditCardValidator = class(TInterfacedObject, IValidator)
    private
        fLuhnValidator : IValidator;
        fAcceptedCreditCardsValidator : IValidator;
        fLuhnIsValid : boolean;
        fCreditCardsIsValid : boolean;
    public
        constructor create(const acceptedCreditCards : array of IValidator);

        (*!------------------------------------------------
         * Validate data
         *-------------------------------------------------
         * @param fieldName name of field
         * @param dataToValidate input data
         * @param request request object
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
        function isValid(
            const fieldName : shortstring;
            const dataToValidate : IReadOnlyList;
            const request : IRequest
        ) : boolean;

        (*!------------------------------------------------
         * Get validation error message
         *-------------------------------------------------
         * @param key name of filed that is being validated
         * @return validation error message
         *-------------------------------------------------*)
        function errorMessage(const fieldName : shortstring) : string;

    end;

implementation

uses

    sysutils,
    KeyValueTypes,
    LuhnValidatorImpl,
    OneOfValidatorImpl;

    constructor TCreditCardValidator.create(const acceptedCreditCards : array of IValidator);
    begin
        fLuhnValidator := TLuhnValidator.create();
        fAcceptedCreditCardsValidator := TOneOfValidator.create(acceptedCreditCards);
    end;

    destructor TCreditCardValidator.destroy();
    begin
        fLuhnValidator := nil;
        fAcceptedCreditCardsValidator := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * Validate data
     *-------------------------------------------------
     * @param key name of field
     * @param dataToValidate input data
     * @param request request object
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TCreditCardValidator.isValid(
        const fieldName : shortstring;
        const dataToValidate : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var val : PKeyValue;
    begin
        fLuhnIsValid := false;
        fCreditCardsIsValid := false;

        val := dataToValidate.find(fieldName);
        if (val = nil) then
        begin
            //if we get here it means there is no field with that name
            //so assume that validation is success
            result := true;
        end else
        begin
            fLuhnIsValid := fLuhnValidator.isValid(fieldName, dataToValidate, request);
            if (fLuhnIsValid) then
            begin
                fCreditCardsIsValid := fAcceptedCreditCardsValidator.isValid(
                    fieldName,
                    dataToValidate,
                    request
                );
            end;
            result := fLuhnIsValid and fCreditCardsIsValid;
        end;
    end;

    (*!------------------------------------------------
     * Get validation error message
     *-------------------------------------------------
     * @return validation error message
     *-------------------------------------------------*)
    function TCreditCardValidator.errorMessage(const fieldName : shortstring) : string;
    begin
        if not fLuhnIsValid then
        begin
            //if luhn validator fails, get error message from it
            result := fLuhnValidator.errorMessage(fieldName);
        end else
        begin
            result := fAcceptedCreditCardsValidator.errorMessage(fieldName);
        end;
    end;
end.
