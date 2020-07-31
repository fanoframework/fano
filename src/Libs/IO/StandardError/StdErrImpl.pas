{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdErrImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StdErrIntf,
    StdOutIntf;

type

    (*!------------------------------------------------
     * basic class having capability to
     * write string to standard error
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStdErr = class(TStdOut, IStdErr)
    public
        function write(const str : string) : IStdOut;
        function writeln(const str : string = '') : IStdOut;
    end;

implementation

    function TStdErr.write(const str : string) : IStdOut;
    begin
        write(StdErr, str);
        result := self;
    end;

    function TStdErr.writeln(const str : string = '') : IStdOut;
    begin
        writeln(StdErr, str);
        result := self;
    end;

end.
