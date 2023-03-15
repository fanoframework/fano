{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorStdOutImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StdOutIntf,
    StreamAdapterIntf;

type

    (*!------------------------------------------------
     * IStdOut decorator implmentation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDecoratorStdOut = class(TInterfacedObject, IStdOut)
    protected
        fActualStdOut : IStdOut;
    public
        constructor create(const actualStdOut : IStdOut);

        (*!------------------------------------------------
         * set stream to write to if any
         *-----------------------------------------------
         * @param stream, stream to write to
         * @return current instance
         *-----------------------------------------------*)
        function setStream(const astream : IStreamAdapter) : IStdOut; virtual;

        (*!------------------------------------------------
         * write string to stdout
         *-----------------------------------------------
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function write(const str : string) : IStdOut; virtual;

        (*!------------------------------------------------
         * write string with newline to stdout
         *-----------------------------------------------
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function writeln(const str : string) : IStdOut; virtual;

    end;

implementation

    constructor TDecoratorStdout.create(const actualStdOut : IStdOut);
    begin
        fActualStdOut := actualStdOut;
    end;

    (*!------------------------------------------------
     * set stream to write to if any
     *-----------------------------------------------
     * @param stream, stream to write to
     * @return current instance
     *-----------------------------------------------*)
    function TDecoratorStdOut.setStream(const astream : IStreamAdapter) : IStdOut;
    begin
        fActualStdOut.setStream(astream);
        result := self;
    end;

    (*!------------------------------------------------
     * write string to stdout
     *-----------------------------------------------
     * @param str, string to write
     * @return current instance
     *-----------------------------------------------*)
    function TDecoratorStdOut.write(const str : string) : IStdOut;
    begin
        fActualStdOut.write(str);
        result := self;
    end;

    (*!------------------------------------------------
     * write string with newline to stdout
     *-----------------------------------------------
     * @param str, string to write
     * @return current instance
     *-----------------------------------------------*)
    function TDecoratorStdOut.writeln(const str : string) : IStdOut;
    begin
        fActualStdOut.writeln(str);
        result := self;
    end;

end.
