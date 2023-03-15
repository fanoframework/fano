{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BetweenValidatorImpl;

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
     * validate value between certain values
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TBetweenValidator = class(TBaseValidator)
    private
        fLowValue : integer;
        fHighValue : integer;
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
        constructor create(const lowValue: integer; const highValue : integer);

    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeIntBetween = 'Field %s must be integer value between %d to %d';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TBetweenValidator.create(
        const lowValue: integer;
        const highValue : integer
    );
    begin
        fLowValue := lowValue;
        fHighValue := highValue;
        inherited create(format(sErrFieldMustBeIntBetween,[ fLowValue, fHighValue ]));
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TBetweenValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var actualVal : integer;
    begin
        //try to convert string to integer
        result := tryStrToInt(dataToValidate, actualVal) and
            (actualVal >= fLowValue) and (actualVal <= fHighValue);
    end;
end.
