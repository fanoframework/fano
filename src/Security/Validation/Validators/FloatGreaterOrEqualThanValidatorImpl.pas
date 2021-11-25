{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FloatGreaterOrEqualThanValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    CompareFloatValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate if data greater or equal than a reference
     * float value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TFloatGreaterOrEqualThanValidator = class(TCompareFloatValidator)
    protected
        function compareFloatWithRef(
            const aFloat: double;
            const refFloat : double
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param refValue reference value
         *-------------------------------------------------*)
        constructor create(const refValue : double);
    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeFloatGreaterOrEqualThan = 'Field %%s must be float value greater or equal than %f';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TFloatGreaterOrEqualThanValidator.create(const refValue : double);
    begin
        inherited create(
            format(sErrFieldMustBeFloatGreaterOrEqualThan, [ refValue ]),
            refValue
        );
    end;

    function TFloatGreaterOrEqualThanValidator.compareFloatWithRef(
        const aFloat: double;
        const refFloat : double
    ) : boolean;
    begin
        result := (aFloat >= refFloat);
    end;

end.
