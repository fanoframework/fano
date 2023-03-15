{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdErrBufferExImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    classes,
    OutputBufferExImpl;

type

    (*!------------------------------------------------
     * class having capability to buffer
     * standard error to a stream
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStdErrBufferEx = class(TOutputBufferEx)
    protected
        procedure redirectOutput(); override;
        procedure restoreOutput(); override;
    end;

implementation

    procedure TStdErrBufferEx.redirectOutput();
    begin
        //save original standard error, we can restore it
        originalStdOutput := StdErr;
        StdErr := streamStdOutput;
    end;

    procedure TStdErrBufferEx.restoreOutput();
    begin
        //restore original standard output
        StdErr := originalStdOutput;
    end;

end.
