{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AcceptedValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    BooleanValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate true or 'yes', 'on' or 1 data. This
     * is mostly used for accepting "Terms and Conditions"
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAcceptedValidator = class(TBooleanValidator)
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
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create();
    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeAccepted = 'Field %s must be accepted';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TAcceptedValidator.create();
    begin
        inherited create();
        errorMsgFormat := sErrFieldMustBeAccepted;
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TAcceptedValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var truthyVal : string;
    begin
        truthyVal := lowercase(dataToValidate);
        result := inherited isValidData(truthyVal, dataCollection, request) or
            (truthyVal = 'yes') or
            (truthyVal = 'on') or
            (truthyVal = '1');
    end;
end.
