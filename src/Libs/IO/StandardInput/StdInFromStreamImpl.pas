{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdInFromStreamImpl;

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
     * class simulate that read standard input from stream
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStdInFromStream = class(TInjectableObject, IStdIn)
    private
        fInputStream : IStreamAdapter;
    public
        constructor create(const inputStream : IStreamAdapter);
        destructor destroy(); override;

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

    constructor TStdInFromStream.create(const inputStream : IStreamAdapter);
    begin
        inherited create();
        setStream(inputStream);
    end;

    destructor TStdInFromStream.destroy();
    begin
        fInputStream := nil;
        inherited destroy();
    end;

    function TStdInFromStream.readStdIn(const contentLength : int64) : string;
    begin
        if (contentLength > 0) then
        begin
            setLength(result, contentLength);
            fInputStream.readBuffer(result[1], contentLength);
        end else
        begin
            result := '';
        end;
    end;

    (*!------------------------------------------------
     * set stream to write to if any
     *-----------------------------------------------
     * @param stream, stream to write to
     * @return current instance
     *-----------------------------------------------*)
    function TStdInFromStream.setStream(const astream : IStreamAdapter) : IStdIn;
    begin
        fInputStream := aStream;
        result := self;
    end;

end.
