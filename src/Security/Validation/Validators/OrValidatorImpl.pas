{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit OrValidatorImpl;

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
     * basic class having capability to
     * validate data using one or more validator with OR
     * boolean operator. validation result only return false
     * if all validators are failed
     * This is provided to allow complex validation using
     * several simple validator
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *------------------------------------------------*)
    TOrValidator = class(TBaseCompositeValidator)
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


    (*!------------------------------------------------
     * Validate data
     *-------------------------------------------------
     * @param fieldName name of field
     * @param dataToValidate input data
     * @param request request object
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TOrValidator.isValid(
        const fieldName : shortstring;
        const dataToValidate : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var i, len, totFail : integer;
    begin
        result := false;
        len := length(fValidators);
        errorMsgFormat := '';
        totFail := 0;
        for i := 0 to len - 1 do
        begin
            result := result or fValidators[i].isValid(fieldName, dataToValidate, request);
            if (result) then
            begin
                //one of validation rules is satisfied so exit early
                exit;
            end else
            begin
                if (totFail > 0) then
                begin
                    errorMsgFormat := errorMsgFormat + ', ';
                end;
                errorMsgFormat := errorMsgFormat + fValidators[i].errorMessage(fieldName);
                inc(totFail);
            end;
        end;
    end;
end.
