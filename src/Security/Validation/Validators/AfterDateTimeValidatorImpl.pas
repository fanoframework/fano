{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AfterDateTimeValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ValidatorIntf,
    CompareDateTimeValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate date is after a reference date
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAfterDateTimeValidator = class(TCompareDateTimeValidator)
    protected
        function compareDateTimeWithRef(
            const adate: TDateTime;
            const refDateTime : TDateTime
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create(const refDatetime : TDateTime);
    end;

implementation

uses

    SysUtils,
    DateUtils;

resourcestring

    sErrFieldMustBeAfterDateTime = 'Field %s must be after date ';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TAfterDateTimeValidator.create(const refDatetime : TDateTime);
    begin
        inherited create(sErrFieldMustBeAfterDateTime + DateTimeToStr(refDatetime));
        fRefDateTime := refDatetime;
    end;

    function TAfterDateTimeValidator.compareDateTimeWithRef(
        const adate: TDateTime;
        const refDateTime : TDateTime
    ) : boolean;
    begin
        result := (compareDateTime(adate, refDateTime) > 0);
    end;
end.
