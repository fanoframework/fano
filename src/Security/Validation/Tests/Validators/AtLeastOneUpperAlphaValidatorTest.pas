{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AtLeastOneUpperAlphaValidatorTest;

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
     * that input data at least contains one upper case character
     *--------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAtLeastOneUpperAlphaValidatorTest = class(TBaseValidatorTest)
    protected
        function buildValidator() : IValidator; override;
    published
        procedure TestInputContainsLowerAlphaShouldFails();
        procedure TestInputContainsDigitsShouldFails();
        procedure TestSymbolOnlyInputShouldFails();
        procedure TestSymbolWithLowerAlphaInputShouldFails();
        procedure TestSymbolWithUpperAlphaInputShouldPass();
        procedure TestOneLowerAlphaInputShouldFails();
        procedure TestMixedAlphaCapsInputShouldPass();
    end;

implementation

uses

    AtLeastOneUpperAlphaValidatorImpl,
    RegexImpl;

    function TAtLeastOneUpperAlphaValidatorTest.buildValidator() : IValidator;
    begin
        result := TAtLeastOneUpperAlphaValidator.create(TRegex.create());
    end;

    procedure TAtLeastOneUpperAlphaValidatorTest.TestInputContainsLowerAlphaShouldFails();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_key', fData, fRequest);
        AssertEquals(false, resValid);
    end;

    procedure TAtLeastOneUpperAlphaValidatorTest.TestInputContainsDigitsShouldFails();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_digit', fData, fRequest);
        AssertEquals(false, resValid);
    end;

    procedure TAtLeastOneUpperAlphaValidatorTest.TestSymbolOnlyInputShouldFails();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_symbol', fData, fRequest);
        AssertEquals(false, resValid);
    end;

    procedure TAtLeastOneUpperAlphaValidatorTest.TestSymbolWithLowerAlphaInputShouldFails();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_letter_symbol', fData, fRequest);
        AssertEquals(false, resValid);
    end;

    procedure TAtLeastOneUpperAlphaValidatorTest.TestSymbolWithUpperAlphaInputShouldPass();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_upper_letter_symbol', fData, fRequest);
        AssertEquals(true, resValid);
    end;

    procedure TAtLeastOneUpperAlphaValidatorTest.TestOneLowerAlphaInputShouldFails();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_a', fData, fRequest);
        AssertEquals(false, resValid);
    end;

    procedure TAtLeastOneUpperAlphaValidatorTest.TestMixedAlphaCapsInputShouldPass();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_abcd', fData, fRequest);
        AssertEquals(true, resValid);
    end;

initialization

    RegisterTest(TAtLeastOneUpperAlphaValidatorTest);

end.
