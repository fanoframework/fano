{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompareIntValidatorImpl;

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
     * validate data compared against a reference integer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCompareIntValidator = class abstract (TBaseValidator)
    private
        fReferenceValue : integer;
    protected

        function compareIntWithRef(
            const aint: integer;
            const refInt : integer
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
        constructor create(const errMsgFormat : string; const refInt : integer);
    end;

implementation

uses

    SysUtils;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TCompareIntValidator.create(
        const errMsgFormat : string;
        const refInt : integer
    );
    begin
        inherited create(errMsgFormat);
        fReferenceValue := refInt;
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TCompareIntValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var intValue : integer;
    begin
        result := tryStrToInt(dataToValidate, intValue) and
            compareIntWithRef(intValue, fReferenceValue);
    end;
end.
