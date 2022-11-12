{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AtLeastOneDigitValidatorTest;

interface

{$MODE OBJFPC}
{$H+}

uses

    fpcunit,
    testregistry,
    RegexIntf,
    ListIntf,
    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    BaseValidatorTest;

type

    (*!------------------------------------------------
     * test case for class having capability to validate
     * that input data at least contains one digit character
     *--------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAtLeastOneDigitValidatorTest = class(TBaseValidatorTest)
    protected
        function buildValidator() : IValidator; override;
    published
        procedure TestInputContainsAlphaShouldFails();
        procedure TestInputContainsDigitsShouldPass();
        procedure TestSymbolOnlyInputShouldFails();
        procedure TestSymbolWithAlphaInputShouldFails();
        procedure TestOneAlphaInputShouldFails();
        procedure TestMixedAlphaCapsInputShouldFails();
    end;

implementation

uses

    AtLeastOneDigitValidatorImpl,
    RegexImpl;

    function TAtLeastOneDigitValidatorTest.buildValidator() : IValidator;
    begin
        result := TAtLeastOneDigitValidator.create(TRegex.create());
    end;

    procedure TAtLeastOneDigitValidatorTest.TestInputContainsAlphaShouldFails();
    begin
        AssertEquals(fValidator.isValid('my_key', fData, fRequest), false);
    end;

    procedure TAtLeastOneDigitValidatorTest.TestInputContainsDigitsShouldPass();
    begin
        AssertEquals(fValidator.isValid('my_digit', fData, fRequest), true);
    end;

    procedure TAtLeastOneDigitValidatorTest.TestSymbolOnlyInputShouldFails();
    begin
        AssertEquals(fValidator.isValid('my_symbol', fData, fRequest), false);
    end;

    procedure TAtLeastOneDigitValidatorTest.TestSymbolWithAlphaInputShouldFails();
    begin
        AssertEquals(fValidator.isValid('my_letter_symbol', fData, fRequest), false);
    end;

    procedure TAtLeastOneDigitValidatorTest.TestOneAlphaInputShouldFails();
    begin
        AssertEquals(fValidator.isValid('my_a', fData, fRequest), false);
    end;

    procedure TAtLeastOneDigitValidatorTest.TestMixedAlphaCapsInputShouldFails();
    begin
        AssertEquals(fValidator.isValid('my_abcd', fData, fRequest), false);
    end;

initialization

    RegisterTest(TAtLeastOneDigitValidatorTest);

end.

