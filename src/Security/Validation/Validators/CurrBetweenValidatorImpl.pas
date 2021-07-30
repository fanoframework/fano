{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CurrBetweenValidatorImpl;

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
     * validate value between certain float values
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCurrBetweenValidator = class(TBaseValidator)
    private
        fLowValue : currency;
        fHighValue : currency;
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
        constructor create(const lowValue: currency; const highValue : currency);

    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeCurrencyBetween = 'Field %%s must be currency value between %f to %f';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TCurrBetweenValidator.create(
        const lowValue: currency;
        const highValue : currency
    );
    begin
        fLowValue := lowValue;
        fHighValue := highValue;
        inherited create(format(sErrFieldMustBeCurrencyBetween, [fLowValue, fHighValue]));
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TCurrBetweenValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var actualVal : currency;
    begin
        //try to convert string to currency
        result := tryStrToCurr(dataToValidate, actualVal) and
            (actualVal >= fLowValue) and (actualVal <= fHighValue);
    end;
end.
