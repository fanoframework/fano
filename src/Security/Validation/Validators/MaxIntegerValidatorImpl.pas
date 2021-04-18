{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MaxIntegerValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    CompareIntValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate if data does not greater than a reference value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMaxIntegerValidator = class(TCompareIntValidator)
    protected
        function compareIntWithRef(
            const aInt: integer;
            const refInt : integer
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param maxValue maximum value allowed
         *-------------------------------------------------*)
        constructor create(const maxValue : integer);
    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeIntegerWithMaxValue = 'Field %%s must be integer with maximum value of %d';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TMaxIntegerValidator.create(const maxValue : integer);
    begin
        inherited create(
            format(sErrFieldMustBeIntegerWithMaxValue, [ maxValue ]),
            maxValue
        );
    end;

    function TMaxIntegerValidator.compareIntWithRef(
        const aInt: integer;
        const refInt : integer
    ) : boolean;
    begin
        result := (aInt <= refInt);
    end;

end.
