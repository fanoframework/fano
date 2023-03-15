{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FloatLessOrEqualThanValidatorImpl;

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
     * validate if data less than a reference float value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TFloatLessOrEqualThanValidator = class(TCompareFloatValidator)
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

    sErrFieldMustBeFloatLessOrEqualThan = 'Field %%s must be float value less or equal than %f';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TFloatLessOrEqualThanValidator.create(const refValue : double);
    begin
        inherited create(
            format(sErrFieldMustBeFloatLessOrEqualThan, [ refValue ]),
            refValue
        );
    end;

    function TFloatLessOrEqualThanValidator.compareFloatWithRef(
        const aFloat: double;
        const refFloat : double
    ) : boolean;
    begin
        result := (aFloat <= refFloat);
    end;

end.
