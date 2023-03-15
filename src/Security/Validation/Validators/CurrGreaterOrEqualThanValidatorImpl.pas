{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CurrGreaterOrEqualThanValidatorImpl;

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
     * validate if data greater or equal than a reference
     * currency value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCurrGreaterOrEqualThanValidator = class(TCompareCurrencyValidator)
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

    sErrFieldMustBeCurrencyGreaterOrEqualThan = 'Field %%s must be currency value greater or equal than %f';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TCurrGreaterOrEqualThanValidator.create(const refValue : currency);
    begin
        inherited create(
            format(sErrFieldMustBeCurrencyGreaterOrEqualThan, [ refValue ]),
            refValue
        );
    end;

    function TCurrGreaterOrEqualThanValidator.compareCurrencyWithRef(
        const aCurrency: currency;
        const refCurrency : currency
    ) : boolean;
    begin
        result := (aCurrency >= refCurrency);
    end;

end.
