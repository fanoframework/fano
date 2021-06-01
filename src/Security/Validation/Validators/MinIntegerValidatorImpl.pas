{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MinIntegerValidatorImpl;

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
     * validate if data does not less than a reference value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMinIntegerValidator = class(TCompareIntValidator)
    protected
        function compareIntWithRef(
            const aInt: integer;
            const refInt : integer
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param minValue minimum value allowed
         *-------------------------------------------------*)
        constructor create(const minValue : integer);
    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeIntegerWithMinValue = 'Field %%s must be integer with minimum value of %d';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TMinIntegerValidator.create(const minValue : integer);
    begin
        inherited create(
            format(sErrFieldMustBeIntegerWithMinValue, [ minValue ]),
            minValue
        );
    end;

    function TMinIntegerValidator.compareIntWithRef(
        const aInt: integer;
        const refInt : integer
    ) : boolean;
    begin
        result := (aInt >= refInt);
    end;

end.
