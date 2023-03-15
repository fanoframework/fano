{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AtLeastOneSymbolValidatorTest;

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
     * that input data at least contains one symbol character
     *--------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAtLeastOneSymbolValidatorTest = class(TBaseValidatorTest)
    protected
        function buildValidator() : IValidator; override;
    published
        procedure TestInputContainsAlphaShouldFails();
        procedure TestInputContainsDigitsShouldFails();
        procedure TestSymbolOnlyInputShouldPass();
        procedure TestSymbolWithAlphaInputShouldPass();
        procedure TestOneAlphaInputShouldFails();
        procedure TestMixedAlphaCapsInputShouldFails();
    end;

implementation

uses

    AtLeastOneSymbolValidatorImpl,
    RegexImpl;

    function TAtLeastOneSymbolValidatorTest.buildValidator() : IValidator;
    begin
        result := TAtLeastOneSymbolValidator.create(TRegex.create());
    end;

    procedure TAtLeastOneSymbolValidatorTest.TestInputContainsAlphaShouldFails();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_key', fData, fRequest);
        AssertEquals(false, resValid);
    end;

    procedure TAtLeastOneSymbolValidatorTest.TestInputContainsDigitsShouldFails();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_digit', fData, fRequest);
        AssertEquals(false, resValid);
    end;

    procedure TAtLeastOneSymbolValidatorTest.TestSymbolOnlyInputShouldPass();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_symbol', fData, fRequest);
        AssertEquals(true, resValid);
    end;

    procedure TAtLeastOneSymbolValidatorTest.TestSymbolWithAlphaInputShouldPass();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_letter_symbol', fData, fRequest);
        AssertEquals(true, resValid);
    end;

    procedure TAtLeastOneSymbolValidatorTest.TestOneAlphaInputShouldFails();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_a', fData, fRequest);
        AssertEquals(false, resValid);
    end;

    procedure TAtLeastOneSymbolValidatorTest.TestMixedAlphaCapsInputShouldFails();
    var resValid : boolean;
    begin
        resValid := fValidator.isValid('my_abcd', fData, fRequest);
        AssertEquals(false, resValid);
    end;

initialization

    RegisterTest(TAtLeastOneSymbolValidatorTest);

end.
