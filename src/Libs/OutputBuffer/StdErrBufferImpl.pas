{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdErrBufferImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    classes,
    OutputBufferImpl;

type

    (*!------------------------------------------------
     * class having capability to buffer
     * standard error to a storage
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStdErrBuffer = class(TOutputBuffer)
    protected
        procedure redirectOutput(); override;
        procedure restoreOutput(); override;
    end;

implementation

    procedure TStdErrBuffer.redirectOutput();
    begin
        //save original standard error, we can restore it
        originalStdOutput := StdErr;
        StdErr := streamStdOutput;
    end;

    procedure TStdErrBuffer.restoreOutput();
    begin
        //restore original standard output
        StdErr := originalStdOutput;
    end;

end.
