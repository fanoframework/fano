{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EqualDateTimeValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    CompareDateTimeValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate date is equal a reference date
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TEqualDateTimeValidator = class(TCompareDateTimeValidator)
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

    sErrFieldMustBeEqualDateTime = 'Field %s must be equal date ';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TEqualDateTimeValidator.create(const refDatetime : TDateTime);
    begin
        inherited create(sErrFieldMustBeEqualDateTime + DateTimeToStr(refDatetime));
        fRefDateTime := refDatetime;
    end;

    function TEqualDateTimeValidator.compareDateTimeWithRef(
        const adate: TDateTime;
        const refDateTime : TDateTime
    ) : boolean;
    begin
        result := (compareDateTime(adate, refDateTime) = 0);
    end;
end.
