{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StringUtilsTest;

interface

{$MODE OBJFPC}
{$H+}

uses

    fpcunit,
    testregistry,
    SysUtils,
    StringUtils;

type

    (*!------------------------------------------------
     * string utilities test case
     *--------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStringUtilsTest = class(TTestCase)
    protected
        procedure Setup(); override;
        procedure TearDown(); override;
    published
        procedure TestJoinMultipleShouldPass();
        procedure TestJoinSingleShouldPass();
        procedure TestJoinEmptyShouldPass();
        procedure TestExplodeEmptyShouldPass();
        procedure TestExplodeSingleShouldPass();
        procedure TestExplodeMultipleShouldPass();
        procedure TestSlugShouldReturnCorrectSlug();
    end;

implementation


    procedure TStringUtilsTest.Setup();
    begin
    end;

    procedure TStringUtilsTest.TearDown();
    begin
    end;

    procedure TStringUtilsTest.TestJoinMultipleShouldPass();
    var joinedStr : string;
    begin
        joinedStr := join('&', [ 'a=b', 'c=d', 'e=f']);
        AssertEquals('a=b&c=d&e=f', joinedStr);
    end;

    procedure TStringUtilsTest.TestJoinEmptyShouldPass();
    var joinedStr : string;
    begin
        joinedStr := join('&', []);
        AssertEquals('', joinedStr);
    end;

    procedure TStringUtilsTest.TestJoinSingleShouldPass();
    var joinedStr : string;
    begin
        joinedStr := join('&', [ 'a=b']);
        AssertEquals('a=b', joinedStr);
    end;

    procedure TStringUtilsTest.TestExplodeEmptyShouldPass();
    var explodedStr : TStringArray;
        len : integer;
    begin
        explodedStr := explode('&', '');
        len := length(explodedStr);
        AssertEquals(0, len);
    end;

    procedure TStringUtilsTest.TestExplodeSingleShouldPass();
    var explodedStr : TStringArray;
        len : integer;
    begin
        explodedStr := explode('&', 'a=b');
        len := length(explodedStr);
        AssertEquals(len, 1);
        AssertEquals('a=b', explodedStr[0]);
    end;

    procedure TStringUtilsTest.TestExplodeMultipleShouldPass();
    var explodedStr : TStringArray;
        len : integer;
    begin
        explodedStr := explode('&', 'a=b&c=d&e=f');
        len := length(explodedStr);
        AssertEquals(3, len);
        AssertEquals('a=b', explodedStr[0]);
        AssertEquals('c=d', explodedStr[1]);
        AssertEquals('e=f', explodedStr[2]);
    end;

    procedure TStringUtilsTest.TestSlugShouldReturnCorrectSlug();
    begin
        AssertEquals('', slug(''));
        AssertEquals('', slug('   '));
        AssertEquals('test-hei-slug-to-slug-10', slug('test hei$#@slug to Slug 10'));
        AssertEquals('test-hei-slug-to-slug-10', slug(' test hei$#@slug to Slug 10 '));
        AssertEquals('test-hei-slug-to-slug-10', slug('@#@!test hei$#@slug to Slug 10#@@'));
        AssertEquals('test-hei-slug-to-slug-10', slug('@#@!test---hei$#@slug-to Slug 10#@@'));
        AssertEquals('test-hei-slug-to-slug-10', slug('@#@!test--^-hei$#@slug-to Slug 10#@@'));
    end;

initialization
    RegisterTest(TStringUtilsTest);
end.
