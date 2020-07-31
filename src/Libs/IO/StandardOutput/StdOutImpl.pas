{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdOutImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    StdOutIntf;

type

    (*!------------------------------------------------
     * basic class having capability to
     * write string to standard output
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStdOut = class(TInterfacedObject, IStdOut)
    public
        function setStream(const astream : IStreamAdapter) : IStdOut;
        function write(const str : string) : IStdOut;
        function writeln(const str : string = '') : IStdOut;
    end;

implementation

    function TStdOut.setStream(const astream : IStreamAdapter) : IStdOut;
    begin
        //do nothing as it is not relevant here
        result := self;
    end;

    function TStdOut.write(const str : string) : IStdOut;
    begin
        write(str);
        result := self;
    end;

    function TStdOut.writeln(const str : string = '') : IStdOut;
    begin
        writeln(str);
        result := self;
    end;

end.
