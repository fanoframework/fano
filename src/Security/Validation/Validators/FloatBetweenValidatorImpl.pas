{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FloatBetweenValidatorImpl;

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
     * validate value between certain float values
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TFloatBetweenValidator = class(TBaseValidator)
    private
        fLowValue : double;
        fHighValue : double;
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
         *-------------------------------------------------*)
        constructor create(const lowValue: double; const highValue : double);

    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeFloatBetween = 'Field %%s must be float value between %f to %f';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TFloatBetweenValidator.create(
        const lowValue: double;
        const highValue : double
    );
    begin
        fLowValue := lowValue;
        fHighValue := highValue;
        inherited create(format(sErrFieldMustBeFloatBetween, [fLowValue, fHighValue]));
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TFloatBetweenValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var actualVal : double;
    begin
        //try to convert string to float
        result := tryStrToFloat(dataToValidate, actualVal) and
            (actualVal >= fLowValue) and (actualVal <= fHighValue);
    end;
end.
