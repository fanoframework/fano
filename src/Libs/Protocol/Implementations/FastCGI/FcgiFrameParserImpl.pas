{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiFrameParserImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    FcgiRecordIntf,
    FcgiRecordFactoryIntf,
    FcgiFrameParserIntf,
    StreamAdapterIntf,
    FcgiBaseParserImpl;

type

    (*!-----------------------------------------------
     * FastCGI Frame Parser
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiFrameParser = class (TFcgiBaseParser)
    private

        function readBytes(
            const stream : IStreamAdapter;
            buf : pointer;
            amountToRead : integer;
            out streamEmpty : boolean
        ) : integer;
    public

        (*!------------------------------------------------
         * read stream and return found record in memory buffer
         *-----------------------------------------------
         * @param bufPtr, memory buffer to store FastCGI record
         * @param bufSize, memory buffer size
         * @return true if stream is exhausted
         *-----------------------------------------------*)
        function readRecord(
            const stream : IStreamAdapter;
            out bufPtr : pointer;
            out bufSize : ptrUint
        ) : boolean; override;

    end;

implementation

uses

    fastcgi,
    EInvalidFcgiBufferImpl,
    EInvalidFcgiRecordTypeImpl,
    EInvalidFcgiHeaderLenImpl,
    ESockWouldBlockImpl;

    (*!------------------------------------------------
     * read stream and return found record in memory buffer
     *-----------------------------------------------
     * @param bufPtr, memory buffer to store FastCGI record
     * @param bufSize, memory buffer size
     * @return true if stream is exhausted
     *-----------------------------------------------*)
    function TFcgiFrameParser.readRecord(
        const stream : IStreamAdapter;
        out bufPtr : pointer;
        out bufSize : ptrUint
    ) : boolean;
    var tmp : pointer;
        header : FCGI_HEADER;
        totBytes, headerSize : integer;
        streamEmpty : boolean;
    begin
        result:= false;
        bufPtr := nil;
        bufSize := 0;
        headerSize := sizeof(FCGI_HEADER);
        totBytes := readBytes(stream, @header, headerSize, streamEmpty);

        if (streamEmpty) then
        begin
            result := true;
            exit;
        end;

        if (totBytes <> headerSize) then
        begin
            raise EInvalidFcgiHeaderLen.createFmt('Invalid header length %d', [totBytes]);
        end;

        bufSize := FCGI_HEADER_LEN + BEtoN(header.contentLength) + header.paddingLength;
        bufPtr := allocate(bufSize);
        //copy header and advance position to skip header part
        tmp := bufPtr;
        PFCGI_HEADER(tmp)^ := header;
        inc(tmp, headerSize);

        //read content and padding
        totBytes := readBytes(stream, tmp, bufSize - headerSize, streamEmpty) + totBytes;
        result := streamEmpty;
    end;

    function TFcgiFrameParser.readBytes(
        const stream : IStreamAdapter;
        buf : pointer;
        amountToRead : integer;
        out streamEmpty : boolean
    ) : integer;
    var bytesRead : int64;
    begin
        result := 0;
        if amountToRead <= 0 then
        begin
            exit;
        end;

        streamEmpty := false;
        repeat
            try
                bytesRead := stream.read(buf^, amountToRead);
                if (bytesRead > 0) then
                begin
                    dec(amountToRead, bytesRead);
                    inc(buf, bytesRead);
                    inc(result, bytesRead);
                end else
                begin
                    streamEmpty := true;
                end;
            except
                on e : ESockWouldBlock do
                begin
                    streamEmpty := true;
                end;
            end;
        until (amountToRead = 0) or streamEmpty;
    end;

end.
