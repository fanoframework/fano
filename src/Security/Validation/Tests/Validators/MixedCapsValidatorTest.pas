{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MixedCapsValidatorTest;

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
     * that input data at least contains one lower case and
     * one upper case character
     *--------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMixedCapsValidatorTest = class(TBaseValidatorTest)
    protected
        function buildValidator() : IValidator; override;
    published
        procedure TestInputContainsLowerAlphaShouldFails();
        procedure TestInputContainsDigitsShouldFails();
        procedure TestSymbolOnlyInputShouldFails();
        procedure TestSymbolWithAlphaInputShouldFails();
        procedure TestOneAlphaInputShouldFails();
        procedure TestMixedAlphaCapsInputShouldPass();
    end;

implementation

uses

    MixedCapsValidatorImpl,
    RegexImpl;

    function TMixedCapsValidatorTest.buildValidator() : IValidator;
    begin
        result := TMixedCapsValidator.create(TRegex.create());
    end;

    procedure TMixedCapsValidatorTest.TestInputContainsLowerAlphaShouldFails();
    begin
        AssertEquals(fValidator.isValid('my_key', fData, fRequest), false);
    end;

    procedure TMixedCapsValidatorTest.TestInputContainsDigitsShouldFails();
    begin
        AssertEquals(fValidator.isValid('my_digit', fData, fRequest), false);
    end;

    procedure TMixedCapsValidatorTest.TestSymbolOnlyInputShouldFails();
    begin
        AssertEquals(fValidator.isValid('my_symbol', fData, fRequest), false);
    end;

    procedure TMixedCapsValidatorTest.TestSymbolWithAlphaInputShouldFails();
    begin
        AssertEquals(fValidator.isValid('my_letter_symbol', fData, fRequest), false);
    end;

    procedure TMixedCapsValidatorTest.TestOneAlphaInputShouldFails();
    begin
        AssertEquals(fValidator.isValid('my_a', fData, fRequest), false);
    end;

    procedure TMixedCapsValidatorTest.TestMixedAlphaCapsInputShouldPass();
    begin
        AssertEquals(fValidator.isValid('my_abcd', fData, fRequest), true);
    end;

initialization

    RegisterTest(TMixedCapsValidatorTest);

end.

