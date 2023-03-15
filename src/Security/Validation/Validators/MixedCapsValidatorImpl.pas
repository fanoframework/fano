{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MixedCapsValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    RequestIntf,
    RegexIntf,
    ValidatorIntf,
    BaseValidatorImpl;

type

    (*!------------------------------------------------
     * class having capability to validate
     * that input data at least contains mix of one lower case letter
     * and one upper case letter
     *-------------------------------------------------
     * This is provided so that we can provide password form
     * validation with custom rule such as min 8 characters
     * length with combination at least one letter, at least
     * one number, at least one symbols with mixed capitalization etc
     *--------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMixedCapsValidator = class(TBaseValidator)
    private
        fAtLeastOneLowerLetter: IValidator;
        fAtLeastOneUpperLetter: IValidator;
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
        constructor create(const regexInst : IRegex);

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

uses

    AtLeastOneLowerAlphaValidatorImpl,
    AtLeastOneUpperAlphaValidatorImpl, RegexImpl;

resourcestring

    sErrNotValidMixedCaps = 'Field ''%s'' must contain at least one lower case letter and one upper case character';

    constructor TMixedCapsValidator.create(const regexInst : IRegex);
    begin
        inherited create(sErrNotValidMixedCaps);
        fAtLeastOneLowerLetter := TAtLeastOneLowerAlphaValidator.create(regexInst);
        fAtLeastOneUpperLetter := TAtLeastOneUpperAlphaValidator.create(regexInst);
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TMixedCapsValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    begin
        // this is not used so just return true
        result:= true;
    end;

    (*!------------------------------------------------
     * Validate data
     *-------------------------------------------------
     * @param key name of field
     * @param dataToValidate input data
     * @param request request object
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TMixedCapsValidator.isValid(
        const fieldName : shortstring;
        const dataToValidate : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    begin
        result := fAtLeastOneLowerLetter.isValid(fieldName,  dataToValidate, request) and
            fAtLeastOneUpperLetter.isValid(fieldName,  dataToValidate, request);
    end;

end.
