{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AtLeastOneLowerAlphaValidatorTest;

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
     * that input data at least contains one lower case character
     *--------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAtLeastOneLowerAlphaValidatorTest = class(TBaseValidatorTest)
    protected
        function buildValidator() : IValidator; override;
    published
        procedure TestInputContainsLowerAlphaShouldPass();
        procedure TestInputContainsDigitsShouldFails();
        procedure TestSymbolOnlyInputShouldFails();
        procedure TestSymbolWithAlphaInputShouldPass();
        procedure TestOneAlphaInputShouldPass();
        procedure TestMixedAlphaCapsInputShouldPass();
    end;

implementation

uses

    AtLeastOneLowerAlphaValidatorImpl,
    RegexImpl;

    function TAtLeastOneLowerAlphaValidatorTest.buildValidator() : IValidator;
    begin
        result := TAtLeastOneLowerAlphaValidator.create(TRegex.create());
    end;

    procedure TAtLeastOneLowerAlphaValidatorTest.TestInputContainsLowerAlphaShouldPass();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_key', fData, fRequest);
        AssertEquals(resValid, true)
    end;

    procedure TAtLeastOneLowerAlphaValidatorTest.TestInputContainsDigitsShouldFails();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_digit', fData, fRequest);
        AssertEquals(resValid, false)
    end;

    procedure TAtLeastOneLowerAlphaValidatorTest.TestSymbolOnlyInputShouldFails();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_symbol', fData, fRequest);
        AssertEquals(resValid, false)
    end;

    procedure TAtLeastOneLowerAlphaValidatorTest.TestSymbolWithAlphaInputShouldPass();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_letter_symbol', fData, fRequest);
        AssertEquals(resValid, true)
    end;

    procedure TAtLeastOneLowerAlphaValidatorTest.TestOneAlphaInputShouldPass();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_a', fData, fRequest);
        AssertEquals(resValid, true)
    end;

    procedure TAtLeastOneLowerAlphaValidatorTest.TestMixedAlphaCapsInputShouldPass();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_abcd', fData, fRequest);
        AssertEquals(resValid, true)
    end;

initialization

    RegisterTest(TAtLeastOneLowerAlphaValidatorTest);

end.

