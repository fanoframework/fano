{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit LuhnValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    RequestIntf,
    ValidatorIntf,
    BaseValidatorImpl;

type

    (*!------------------------------------------------
     * class having capability to validate input data
     * against Luhn algorithm
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TLuhnValidator = class(TBaseValidator)
    private
        (*!------------------------------------------------
         * validate against Luhn algorithm
         *-------------------------------------------------
         * @param arg input data
         * @return true if data is valid otherwise false
         *-------------------------------------------------
         * @credit https://rosettacode.org/wiki/Luhn_test_of_credit_card_numbers#Pascal
         *-------------------------------------------------*)
        function validateLuhn(const arg : string) : boolean;
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
        constructor create();

    end;

implementation

uses

    sysutils;

resourcestring

    sErrFieldIsLuhn = 'Field %s value must match credit card number';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TLuhnValidator.create();
    begin
        inherited create(sErrFieldIsLuhn);
    end;

    (*!------------------------------------------------
     * validate against Luhn algorithm
     *-------------------------------------------------
     * @param arg input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------
     * @credit https://rosettacode.org/wiki/Luhn_test_of_credit_card_numbers#Pascal
     *-------------------------------------------------*)
    function TLuhnValidator.validateLuhn(const arg : string) : boolean;
    const BYTE_ASCII_ZERO = 48;
    var i, sum : integer;
        temp : byte;
    begin
        sum := 0;
        for i := length(arg) downto 1 do
        begin
            //convert ASCII to byte
            temp := byte(arg[i]) - BYTE_ASCII_ZERO;
            if (length(arg) - i) mod 2 = 0 then
            begin
                //Odd characters, just add
                inc(sum, temp);
            end else
            begin
                //Even characters
                if temp < 5 then
                begin
                    //add double
                    inc(sum, 2 * temp);
                end else
                begin
                    //add sum of digit of doubling
                    inc(sum, 2 * temp - 9);
                end;
            end;
        end;
        result := sum mod 10 = 0;
    end;

    (*!------------------------------------------------
     * test actual data against Luhn algorithm
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TLuhnValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    begin
        result := validateLuhn(dataToValidate);
    end;
end.
