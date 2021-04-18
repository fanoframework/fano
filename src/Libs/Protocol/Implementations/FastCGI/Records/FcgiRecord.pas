{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiRecord;

interface

{$MODE OBJFPC}
{$H+}

uses

    fastcgi,
    StreamAdapterIntf,
    FcgiRecordIntf;

type

    (*!-----------------------------------------------
     * Base FastCGI record
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiRecord = class(TInterfacedObject, IFcgiRecord)
    protected
        fHeader : FCGI_Header;
        fRequestId : word;
        fContentData : IStreamAdapter;

        (*!------------------------------------------------
         * calculate number of bytes of padding to write per record
         *-----------------------------------------------
         * @param len, current data length
         * @return number of bytes of padding required
         *-----------------------------------------------*)
        function getPaddingLength(const len: word) : byte;
    public
        constructor create(
            const aVersion : byte;
            const aType : byte;
            const aRequestId : word;
            const dataStream : IStreamAdapter
        );

        constructor createFromStream(
            const srcStream : IStreamAdapter;
            const dataStream : IStreamAdapter
        );

        destructor destroy(); override;

        (*!------------------------------------------------
         * get current record type
         *-----------------------------------------------
         * @return type of record
         *-----------------------------------------------*)
        function getType() : byte;

        (*!------------------------------------------------
         * get request id
         *-----------------------------------------------
         * @return request id
         *-----------------------------------------------*)
        function getRequestId() : word;

        (*!------------------------------------------------
         * get content length
         *-----------------------------------------------
         * @return content length
         *-----------------------------------------------*)
        function getContentLength() : word;

        (*!------------------------------------------------
         * get content of record data
         *-----------------------------------------------
         * @return data as stream
         *-----------------------------------------------*)
        function data() : IStreamAdapter;

        (*!------------------------------------------------
         * calculate total record data size
         *-----------------------------------------------
         * @return number of bytes of current record
         *-----------------------------------------------*)
        function getRecordSize() : integer;

        (*!------------------------------------------------
         * write record data to destination stream
         *-----------------------------------------------
         * @param stream, stream instance where to write
         * @return number of bytes actually written
         *-----------------------------------------------*)
        function write(const dstStream : IStreamAdapter) : integer; virtual;
    end;

implementation

    constructor TFcgiRecord.create(
        const aVersion : byte;
        const aType : byte;
        const aRequestId : word;
        const dataStream : IStreamAdapter
    );
    begin
        inherited create();
        //fillDword(fHeader, sizeOf(FCGI_Header), 0);

        fHeader.version := aVersion;
        fHeader.reqtype := aType;
        //FastCGI specification required Big-Endian
        fHeader.requestID := NToBE(aRequestId);
        fHeader.contentLength := 0;
        fHeader.paddingLength := 0;
        fHeader.reserved :=0;

        fRequestId := aRequestId;
        fContentData := dataStream;
    end;

    constructor TFcgiRecord.createFromStream(
        const srcStream : IStreamAdapter;
        const dataStream : IStreamAdapter
    );
    var contentLength : word;
    begin
        fContentData := dataStream;
        srcStream.readBuffer(fHeader, sizeof(FCGI_Header));

        //FastCGI specification required requestID and contentLength
        //in big-endian format, need to convert it to native endian
        fRequestId := BEtoN(fHeader.requestID);
        contentLength := BEtoN(fHeader.contentLength);

        fContentData.resize(contentLength);
        fContentData.seek(0);

        srcStream.readStream(fContentData, contentLength);
        srcStream.seek(fHeader.paddingLength, FROM_CURRENT);

        fContentData.seek(0);
    end;

    destructor TFcgiRecord.destroy();
    begin
        fContentData := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * get current record type
     *-----------------------------------------------
     * @return type of record
     *-----------------------------------------------*)
    function TFcgiRecord.getType() : byte;
    begin
        result := fHeader.reqtype;
    end;

    (*!------------------------------------------------
     * get request id
     *-----------------------------------------------
     * @return request id
     *-----------------------------------------------*)
    function TFcgiRecord.getRequestId() : word;
    begin
        result := fRequestId;
    end;

    (*!------------------------------------------------
     * get content length
     *-----------------------------------------------
     * @return content length
     *-----------------------------------------------*)
    function TFcgiRecord.getContentLength() : word;
    begin
        result := word(fContentData.size());
    end;

    (*!------------------------------------------------
     * get content record data
     *-----------------------------------------------
     * @return stream
     *-----------------------------------------------*)
    function TFcgiRecord.data() : IStreamAdapter;
    begin
        result := fContentData;
    end;

    (*!------------------------------------------------
    * calculate total record data size
    *-----------------------------------------------
    * @return number of bytes of current record
    *-----------------------------------------------*)
    function TFcgiRecord.getRecordSize() : integer;
    var contentLength : word;
        paddingLength : byte;
    begin
        contentlength := getContentLength();
        paddingLength := getPaddingLength(contentLength);
        result := FCGI_HEADER_LEN + contentLength + paddingLength;
    end;

    (*!------------------------------------------------
     * calculate number of bytes to write per record
     *-----------------------------------------------
     * @param len, current data length
     * @param excess, current data length excess
     * @return number of bytes actually written
     *-----------------------------------------------*)
    function TFcgiRecord.getPaddingLength(const len: word) : byte;
    begin
        if ((len mod FCGI_HEADER_LEN) = 0) then
        begin
            result := 0;
        end else
        begin
            result := FCGI_HEADER_LEN - (len mod FCGI_HEADER_LEN);
        end;
    end;

    (*!------------------------------------------------
     * write record data to destination stream
     *-----------------------------------------------
     * @param dstStream, stream instance where to write
     * @return number of bytes actually written
     *-----------------------------------------------*)
    function TFcgiRecord.write(const dstStream : IStreamAdapter) : integer;
    var contentLength : word;
        padding : byte;
    begin
        contentlength := getContentLength();
        fHeader.contentLength := NtoBE(contentlength);
        fHeader.paddingLength := getPaddingLength(contentLength);

        //write header part
        dstStream.writeBuffer(fHeader, sizeof(FCGI_Header));
        //write data part
        dstStream.writeStream(fContentData, fContentData.size());
        //write padding part if any
        if (fHeader.paddingLength > 0) then
        begin
            padding := 0;
            dstStream.writeBuffer(padding, fHeader.paddingLength);
        end;

        result := getRecordSize();
    end;
end.
