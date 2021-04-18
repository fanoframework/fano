{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullStdOutImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    StdOutIntf;

type

    (*!------------------------------------------------
     * null class having capability to
     * write string to standard output
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullStdOut = class(TInterfacedObject, IStdOut)
    public
        function setStream(const astream : IStreamAdapter) : IStdOut;
        function write(const str : string) : IStdOut;
        function writeln(const str : string = '') : IStdOut;
    end;

implementation

    function TNullStdOut.setStream(const astream : IStreamAdapter) : IStdOut;
    begin
        //intentionally does nothing
        result := self;
    end;

    function TNullStdOut.write(const str : string) : IStdOut;
    begin
        //intentionally does nothing
        result := self;
    end;

    function TNullStdOut.writeln(const str : string = '') : IStdOut;
    begin
        //intentionally does nothing
        result := self;
    end;

end.
