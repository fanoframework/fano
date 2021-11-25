{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompareCurrencyValidatorImpl;

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
     * validate data compared against a reference currency
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCompareCurrencyValidator = class abstract (TBaseValidator)
    private
        fReferenceValue : currency;
    protected

        function compareCurrencyWithRef(
            const aCurrency: currency;
            const refCurrency : currency
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
        constructor create(const errMsgFormat : string; const refCurrency : currency);
    end;

implementation

uses

    SysUtils;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TCompareCurrencyValidator.create(
        const errMsgFormat : string;
        const refCurrency : currency
    );
    begin
        inherited create(errMsgFormat);
        fReferenceValue := refCurrency;
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TCompareCurrencyValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var floatValue : currency;
    begin
        result := tryStrToCurr(dataToValidate, floatValue) and
            compareCurrencyWithRef(floatValue, fReferenceValue);
    end;
end.
