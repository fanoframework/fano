{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MaxLengthValidatorImpl;

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
     * validate if length of string must less or equal reference
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMaxLengthValidator = class(TBaseValidator)
    private
        fMaximumValue : integer;
    protected
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
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param maxValue maximum value allowed
         *-------------------------------------------------*)
        constructor create(const maxValue : integer);
    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeMaxLength = 'Field %s must be have maximum length ';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TMaxLengthValidator.create(const maxValue : integer);
    begin
        inherited create(sErrFieldMustBeMaxLength + intToStr(maxValue));
        fMaximumValue := maxValue;
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TMaxLengthValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    begin
        result := (length(dataToValidate) <= fMaximumValue);
    end;
end.
