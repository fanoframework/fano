{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CurrGreaterThanValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    CompareCurrencyValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate if data greater than a reference
     * currency value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCurrGreaterThanValidator = class(TCompareCurrencyValidator)
    protected
        function compareCurrencyWithRef(
            const aCurrency: currency;
            const refCurrency : currency
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param refValue reference value
         *-------------------------------------------------*)
        constructor create(const refValue : currency);
    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeCurrencyGreaterThan = 'Field %%s must be currency value greater than %f';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TCurrGreaterThanValidator.create(const refValue : currency);
    begin
        inherited create(
            format(sErrFieldMustBeCurrencyGreaterThan, [ refValue ]),
            refValue
        );
    end;

    function TCurrGreaterThanValidator.compareCurrencyWithRef(
        const aCurrency: currency;
        const refCurrency : currency
    ) : boolean;
    begin
        result := (aCurrency > refCurrency);
    end;

end.
