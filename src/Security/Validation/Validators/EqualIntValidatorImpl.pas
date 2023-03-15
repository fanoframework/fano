{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EqualIntValidatorImpl;

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
     * validate data equality against a reference integer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TEqualIntValidator = class(TCompareIntValidator)
    protected

        function compareIntWithRef(
            const aInt: integer;
            const refInt : integer
        ) : boolean; override;
    public
        (*!------------------------------------------------
        * constructor
        *-------------------------------------------------*)
        constructor create(const refInt : integer);

    end;

implementation

uses

    sysutils;

resourcestring

    sErrFieldMustBeEqualInt = 'Field %%s must be equal to "%d"';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TEqualIntValidator.create(const refInt : integer);
    begin
        inherited create(
            format(sErrFieldMustBeEqualInt, [refInt]),
            refInt
        );
    end;

    function TEqualIntValidator.compareIntWithRef(
        const aInt: integer;
        const refInt : integer
    ) : boolean;
    begin
        result := (aInt = refInt);
    end;

end.
