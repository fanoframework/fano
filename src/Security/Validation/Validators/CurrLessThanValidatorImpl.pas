{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CurrLessThanValidatorImpl;

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
     * validate if data less than a reference currency value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCurrLessThanValidator = class(TCompareCurrencyValidator)
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

    sErrFieldMustBeCurrencyLessThan = 'Field %%s must be currency value less than %f';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TCurrLessThanValidator.create(const refValue : currency);
    begin
        inherited create(
            format(sErrFieldMustBeCurrencyLessThan, [ refValue ]),
            refValue
        );
    end;

    function TCurrLessThanValidator.compareCurrencyWithRef(
        const aCurrency: currency;
        const refCurrency : currency
    ) : boolean;
    begin
        result := (aCurrency < refCurrency);
    end;

end.
