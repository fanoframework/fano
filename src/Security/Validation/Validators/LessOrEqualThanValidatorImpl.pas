{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit LessOrEqualThanValidatorImpl;

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
     * validate if data less or equal than a reference value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TLessOrEqualThanValidator = class(TCompareIntValidator)
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

    sErrFieldMustBeIntegerLessOrEqualThan = 'Field %%s must be integer less or equal than %d';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TLessOrEqualThanValidator.create(const refValue : integer);
    begin
        inherited create(
            format(sErrFieldMustBeIntegerLessOrEqualThan, [ refValue ]),
            refValue
        );
    end;

    function TLessOrEqualThanValidator.compareIntWithRef(
        const aInt: integer;
        const refInt : integer
    ) : boolean;
    begin
        result := (aInt <= refInt);
    end;

end.
