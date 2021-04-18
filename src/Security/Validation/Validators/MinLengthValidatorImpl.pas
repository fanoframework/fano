{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MinLengthValidatorImpl;

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
     * validate if length of string must greater or equal reference
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMinLengthValidator = class(TBaseValidator)
    private
        fMinimumValue : integer;
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
         * @param minValue minimum value allowed
         *-------------------------------------------------*)
        constructor create(const minValue : integer);
    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeMinLength = 'Field %s must be have minimum length ';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TMinLengthValidator.create(const minValue : integer);
    begin
        inherited create(sErrFieldMustBeMinLength + intToStr(minValue));
        fMinimumValue := minValue;
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TMinLengthValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    begin
        result := (length(dataToValidate) >= fMinimumValue);
    end;
end.
