{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BaseValidatorTest;

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
    RegexValidatorImpl;

type

    (*!------------------------------------------------
     * base test case for class having capability to validate
     * that input data
     *--------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TBaseValidatorTest = class(TTestCase)
    protected
        fValidator : IValidator;
        fData : IList;
        fRequest : IRequest;

        function buildValidator() : IValidator; virtual; abstract;
        procedure Setup(); override;
        procedure TearDown(); override;
    end;

implementation

uses

    KeyValueTypes,
    RegexImpl,
    HashListImpl,
    NullRequestImpl;

    procedure TBaseValidatorTest.Setup();
    begin
        fData:= THashList.create();

        fData.add('my_key', NewKeyValue('my_key', 'abcdefg'));
        fData.add('my_abcd', NewKeyValue('my_abcd', 'Abcdef'));
        fData.add('my_a', NewKeyValue('my_a', 'a'));
        fData.add('my_digit', NewKeyValue('my_digit', '00000'));
        fData.add('my_symbol', NewKeyValue('my_symbol', '@#!$#'));
        fData.add('my_letter_symbol', NewKeyValue('my_letter_symbol', '@#!$#a'));
        fData.add('my_upper_letter_symbol', NewKeyValue('my_upper_letter_symbol', '@#!$#A'));

        fValidator := buildValidator();
        fRequest := TNullRequest.create();
    end;

    procedure TBaseValidatorTest.TearDown();
    var i: integer;
    begin
        for i:= fData.count()-1 downto 0 do
        begin
            DisposeKeyValue(PKeyValue(fData.get(i)));
            fData.delete(i);
        end;
    end;

end.


