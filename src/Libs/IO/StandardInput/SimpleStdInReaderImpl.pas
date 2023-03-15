{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SimpleStdInReaderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    sysutils,
    InjectableObjectImpl,
    StreamAdapterIntf,
    StdInIntf;

type

    (*!------------------------------------------------
     * class that read standard input to string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSimpleStdInReader = class(TInjectableObject, IStdIn)
    public
        (*!------------------------------------------------
         * set stream to write to if any
         *-----------------------------------------------
         * @param stream, stream to write to
         * @return current instance
         *-----------------------------------------------*)
        function setStream(const astream : IStreamAdapter) : IStdIn;

        function readStdIn(const contentLength : int64) : string;
    end;

implementation

    function TSimpleStdInReader.readStdIn(const contentLength : int64) : string;
    var ctr : int64;
        ch : char;
    begin
        //read STDIN
        ctr := 0;
        setLength(result, contentLength);
        while (ctr < contentLength) do
        begin
            read(ch);
            result[ctr+1] := ch;
            inc(ctr);
        end;
    end;

    (*!------------------------------------------------
     * set stream to write to if any
     *-----------------------------------------------
     * @param stream, stream to write to
     * @return current instance
     *-----------------------------------------------*)
    function TSimpleStdInReader.setStream(const astream : IStreamAdapter) : IStdIn;
    begin
        //intentionally does nothing
        result := self;
    end;
end.
