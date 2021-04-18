{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BeforeDateTimeValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    CompareDateTimeValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate date is before a reference date
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TBeforeDateTimeValidator = class(TCompareDateTimeValidator)
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

    sErrFieldMustBeBeforeDateTime = 'Field %s must be before date ';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TBeforeDateTimeValidator.create(const refDatetime : TDateTime);
    begin
        inherited create(sErrFieldMustBeBeforeDateTime + DateTimeToStr(refDatetime));
        fRefDateTime := refDatetime;
    end;

    function TBeforeDateTimeValidator.compareDateTimeWithRef(
        const adate: TDateTime;
        const refDateTime : TDateTime
    ) : boolean;
    begin
        result := (compareDateTime(adate, refDateTime) < 0);
    end;
end.
