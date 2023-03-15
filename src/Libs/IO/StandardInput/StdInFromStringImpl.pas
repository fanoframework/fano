{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdInFromStringImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    InjectableObjectImpl,
    StreamAdapterIntf,
    StdInIntf;

type

    (*!------------------------------------------------
     * class simulate that read standard input to string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStdInFromString = class(TInjectableObject, IStdIn)
    private
        fInputStr : string;
    public
        constructor create(const inputStr : string);
        function readStdIn(const contentLength : int64) : string;
        (*!------------------------------------------------
         * set stream to write to if any
         *-----------------------------------------------
         * @param stream, stream to write to
         * @return current instance
         *-----------------------------------------------*)
        function setStream(const astream : IStreamAdapter) : IStdIn;
    end;

implementation

    constructor TStdInFromString.create(const inputStr : string);
    begin
        fInputStr := inputStr;
    end;

    function TStdInFromString.readStdIn(const contentLength : int64) : string;
    begin
        result := copy(fInputStr, 1, contentLength);
    end;

    (*!------------------------------------------------
     * set stream to write to if any
     *-----------------------------------------------
     * @param stream, stream to write to
     * @return current instance
     *-----------------------------------------------*)
    function TStdInFromString.setStream(const astream : IStreamAdapter) : IStdIn;
    begin
        setLength(fInputStr, astream.size());
        aStream.readBuffer(fInputStr[1], length(fInputStr));
        result := self;
    end;
end.
