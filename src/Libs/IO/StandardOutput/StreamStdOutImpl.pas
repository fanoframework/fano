{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit StreamStdOutImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    StdOutIntf;

type

    (*!-----------------------------------------------
     * Base abstract class that write to stdout that use
     * stream adapter
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStreamStdOut = class(TInterfacedObject, IStdOut)
    protected
        fStream : IStreamAdapter;

        (*!------------------------------------------------
         * write string to stream and
         *-----------------------------------------------
         * @param stream, stream to write
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function writeStream(const stream : IStreamAdapter; const str : string) : IStdOut; virtual; abstract;
    public

        constructor create(const astream : IStreamAdapter = nil);
        destructor destroy(); override;

        function setStream(const astream : IStreamAdapter) : IStdOut;

        (*!------------------------------------------------
         * write string to STDOUT stream
         *-----------------------------------------------
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function write(const str : string) : IStdOut;

        (*!------------------------------------------------
         * write string with newline to STDOUT stream
         *-----------------------------------------------
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function writeln(const str : string) : IStdOut;

    end;

implementation

    constructor TStreamStdOut.create(const astream : IStreamAdapter = nil);
    begin
        fStream := astream;
    end;

    destructor TStreamStdOut.destroy();
    begin
        inherited destroy();
        fStream := nil;
    end;

    function TStreamStdOut.setStream(const astream : IStreamAdapter) : IStdOut;
    begin
        fStream := astream;
        result := self;
    end;

    (*!------------------------------------------------
     * write string to STDOUT stream
     *-----------------------------------------------
     * @param str, string to write
     * @return current instance
     *-----------------------------------------------*)
    function TStreamStdOut.write(const str : string) : IStdOut;
    begin
        result := writeStream(fStream, str);
    end;

    (*!------------------------------------------------
     * write string with newline to STDOUT stream
     *-----------------------------------------------
     * @param str, string to write
     * @return current instance
     *-----------------------------------------------*)
    function TStreamStdOut.writeln(const str : string) : IStdOut;
    begin
        result := writeStream(fStream, str + LineEnding);
    end;
end.
