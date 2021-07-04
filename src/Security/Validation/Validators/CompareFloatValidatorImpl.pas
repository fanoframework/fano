{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompareFloatValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    BaseValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate data compared against a reference double
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCompareFloatValidator = class abstract (TBaseValidator)
    private
        fReferenceValue : double;
    protected

        function compareFloatWithRef(
            const aFloat: double;
            const refFloat : double
        ) : boolean; virtual; abstract;

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
        constructor create(const errMsgFormat : string; const refFloat : double);
    end;

implementation

uses

    SysUtils;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TCompareFloatValidator.create(
        const errMsgFormat : string;
        const refFloat : double
    );
    begin
        inherited create(errMsgFormat);
        fReferenceValue := refFloat;
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TCompareFloatValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var floatValue : double;
    begin
        result := tryStrToFloat(dataToValidate, floatValue) and
            compareFloatWithRef(floatValue, fReferenceValue);
    end;
end.
