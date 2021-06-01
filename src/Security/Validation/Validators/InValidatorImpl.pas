{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit InValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    BaseValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate data that must included in given list of values
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TInValidator = class(TBaseValidator)
    protected
        fValidValues : TStringArray;

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
        constructor create(const validValues : array of string);

        (*!------------------------------------------------
         * destructor
         *-------------------------------------------------*)
        destructor destroy(); override;
    end;

implementation

uses

    StringUtils;

resourcestring

    sErrFieldMustBeIn = 'Field %%s must be in given values "%s"';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TInValidator.create(const validValues : array of string);
    begin
        inherited create(
            format(
                sErrFieldMustBeIn,
                [ join(', ', validValues) ]
            )
        );
        fValidValues := toStringArray(validValues);
    end;

    (*!------------------------------------------------
     * destructor
     *-------------------------------------------------*)
    destructor TInValidator.destroy();
    begin
        setLength(fValidValues, 0);
        inherited destroy();
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TInValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var i, len : integer;
    begin
        result := false;
        len := length(fValidValues);
        for i := 0 to len - 1 do
        begin
            if (dataToValidate = fValidValues[i]) then
            begin
                result := true;
                exit();
            end;
        end;
    end;
end.
