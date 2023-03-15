{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BeforeDateTimeFieldValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    CompareFieldValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate date time field that must be before than
     * other datetime field
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TBeforeDateTimeFieldValidator = class(TCompareFieldValidator)
    protected

        (*!------------------------------------------------
         * compare data with other data from field
         *-------------------------------------------------
         * @param dataToValidate input data
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
        function compare(
            const dataToValidate : string;
            const otherFieldData : string
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create(const comparedField : shortstring);
    end;

implementation

uses

    SysUtils,
    DateUtils;

resourcestring

    sErrFieldMustBeBeforeDateTimeField = 'Field %s must be before field ';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TBeforeDateTimeFieldValidator.create(const comparedField : shortstring);
    begin
        inherited create(sErrFieldMustBeBeforeDateTimeField + comparedField, comparedField);
    end;


    (*!------------------------------------------------
     * compare data with data from other field
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TBeforeDateTimeFieldValidator.compare(
        const dataToValidate : string;
        const otherFieldData : string
    ) : boolean;
    var adateTime, otherDateTime : TDateTime;
    begin
        result := tryStrToDateTime(dataToValidate, adateTime) and
            tryStrToDateTime(otherFieldData, otherDateTime) and
            (compareDateTime(adateTime, otherDateTime) < 0);
    end;
end.
