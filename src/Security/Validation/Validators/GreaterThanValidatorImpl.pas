{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit GreaterThanValidatorImpl;

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
     * validate if data greater than a reference value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TGreaterThanValidator = class(TCompareIntValidator)
    protected
        function compareIntWithRef(
            const aInt: integer;
            const refInt : integer
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param refValue reference value
         *-------------------------------------------------*)
        constructor create(const refValue : integer);
    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeIntegerGreaterThan = 'Field %%s must be integer greater than %d';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TGreaterThanValidator.create(const refValue : integer);
    begin
        inherited create(
            format(sErrFieldMustBeIntegerGreaterThan, [ refValue ]),
            refValue
        );
    end;

    function TGreaterThanValidator.compareIntWithRef(
        const aInt: integer;
        const refInt : integer
    ) : boolean;
    begin
        result := (aInt > refInt);
    end;

end.
