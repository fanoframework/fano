{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit OneOfValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    RequestIntf,
    ValidatorIntf,
    BaseCompositeValidatorImpl,
    ValidatorArrayTypes;

type

    (*!------------------------------------------------
     * class having capability to
     * validate data using one or more validators and
     * exactly only one validator must pass
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *------------------------------------------------*)
    TOneOfValidator = class(TBaseCompositeValidator)
    public
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

    SysUtils;

resourcestring

    sErrMustPassExactlyOne = 'Exactly one validator must pass but %d ' +
        'validator(s) pass and %d validator(s) fail(s). ';

    (*!------------------------------------------------
     * Validate data
     *-------------------------------------------------
     * @param fieldName name of field
     * @param dataToValidate input data
     * @param request request object
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TOneOfValidator.isValid(
        const fieldName : shortstring;
        const dataToValidate : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var i, len, totSuccess, totFail : integer;
    begin
        len := length(fValidators);
        errorMsgFormat := '';
        totSuccess := 0;
        totFail := 0;
        for i := 0 to len - 1 do
        begin
            if (fValidators[i].isValid(fieldName, dataToValidate, request)) then
            begin
                inc(totSuccess);
            end else
            begin
                inc(totFail);
                if (totFail > 0) then
                begin
                    errorMsgFormat := errorMsgFormat + ', ';
                end;
                errorMsgFormat := errorMsgFormat +
                    fValidators[i].errorMessage(fieldName);
            end;
        end;

        result := (totSuccess = 1);
        if result then
        begin
            //if exactly one pass, reset error message
            errorMsgFormat := '';
        end else
        begin
            errorMsgFormat := format(
                sErrMustPassExactlyOne,
                [ totSuccess, totFail ]
            ) + errorMsgFormat;
        end;;
    end;
end.
