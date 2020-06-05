{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit LessThanValidatorImpl;

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
     * validate if data less than a reference value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TLessThanValidator = class(TCompareIntValidator)
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

    sErrFieldMustBeIntegerLessThan = 'Field %%s must be integer less than %d';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TLessThanValidator.create(const refValue : integer);
    begin
        inherited create(
            format(sErrFieldMustBeIntegerLessThan, [ refValue ]),
            refValue
        );
    end;

    function TLessThanValidator.compareIntWithRef(
        const aInt: integer;
        const refInt : integer
    ) : boolean;
    begin
        result := (aInt < refInt);
    end;

end.
