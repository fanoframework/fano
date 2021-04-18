{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

program testrunner;

{$MODE OBJFPC}
{$H+}

uses

    classes,
    consoletestrunner,
    {$INCLUDE src/tests.inc}
    fano;

type

    TFanoTestRunner = class(TTestRunner)
    end;

var

  fanoTestRunner: TFanoTestRunner;

begin
    DefaultFormat := fPlain;
    DefaultRunAllTests := true;
    fanoTestRunner := TFanoTestRunner.Create(nil);
    try
        fanoTestRunner.initialize();
        fanoTestRunner.title := 'Fano Test Runner';
        fanoTestRunner.run();
    finally
        fanoTestRunner.free();
    end;
end.
