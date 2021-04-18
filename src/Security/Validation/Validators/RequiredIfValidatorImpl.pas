{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RequiredIfValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    RequiredValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate data that must be present and not empty
     * only if other field pass other validation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TRequiredIfValidator = class(TRequiredValidator)
    private
        fOtherField : shortstring;
        fOtherValidator : IValidator;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create(
            const otherField : shortstring;
            const otherValidator : IValidator
        );
        destructor destroy(); override;

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
        ) : boolean; override;
    end;

implementation

resourcestring

    sErrFieldIsRequiredIf = 'Field %s must be present and not empty if ';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TRequiredIfValidator.create(
        const otherField : shortstring;
        const otherValidator : IValidator
    );
    begin
        inherited create();
        fOtherField := otherField;
        fOtherValidator := otherValidator;
        errorMsgFormat := sErrFieldIsRequiredIf +
            fOtherValidator.errorMessage(fOtherField);
    end;

    destructor TRequiredIfValidator.destroy();
    begin
        fOtherValidator := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * Validate data
     *-------------------------------------------------
     * @param fieldName name of field
     * @param dataToValidate input data
     * @param request request object
     * @return true if data is valid otherwise false
     *-------------------------------------------------
     * We assume dataToValidate <> nil
     *-------------------------------------------------*)
    function TRequiredIfValidator.isValid(
        const fieldName : shortstring;
        const dataToValidate : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    begin
        if fOtherValidator.isValid(fOtherField, dataToValidate, request) then
        begin
            //if we get here then fieldName is required
            result := inherited isValid(fieldName, dataToValidate, request);
        end else
        begin
            //not required
            result := true;
        end;
    end;
end.
