{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompareDateTimeValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    BaseValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate date is after a reference date
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCompareDateTimeValidator = class(TBaseValidator)
    protected
        fRefDateTime : TDateTime;

        function compareDateTimeWithRef(
            const adate: TDateTime;
            const refDateTime : TDateTime
        ) : boolean; virtual; abstract;

        (*!------------------------------------------------
         * actual data validation
         *-------------------------------------------------
         * @param dataToValidate input data
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
        function isValidData(
            const dataToValidate : string;
            const dataCollection : IReadOnlyList;
            const request : IRequest
        ) : boolean; override;
    end;

implementation

uses

    SysUtils;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TCompareDateTimeValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var actualVal : TDateTime;
    begin
        //try to convert string to TDateTime
        result := tryStrToDateTime(dataToValidate, actualVal) and
            compareDateTimeWithRef(actualVal, fRefDateTime);
    end;
end.
