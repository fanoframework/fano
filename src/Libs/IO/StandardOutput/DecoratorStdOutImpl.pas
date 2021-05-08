{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorStdOutImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    StdOutIntf;

type

    (*!------------------------------------------------
     * decorator class having capability to
     * write string to standard output
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDecoratorStdOut = class(TInterfacedObject, IStdOut)
    protected
        fActualStdOut : IStdOut;
    public
        constructor create(const actualStdOut : IStdOut);
        function setStream(const astream : IStreamAdapter) : IStdOut; virtual;
        function write(const str : string) : IStdOut; virtual;
        function writeln(const str : string = '') : IStdOut; virtual;
    end;

implementation

    constructor TDecoratorStdOut.create(const actualStdOut : IStdOut);
    begin
        fActualStdOut := actualStdOut;
    end;

    function TDecoratorStdOut.setStream(const astream : IStreamAdapter) : IStdOut;
    begin
        fActualStdOut.setStream(astream);
        result := self;
    end;

    function TDecoratorStdOut.write(const str : string) : IStdOut;
    begin
        fActualStdOut.write(str);
        result := self;
    end;

    function TDecoratorStdOut.writeln(const str : string = '') : IStdOut;
    begin
        fActualStdOut.writeln(str);
        result := self;
    end;

end.
