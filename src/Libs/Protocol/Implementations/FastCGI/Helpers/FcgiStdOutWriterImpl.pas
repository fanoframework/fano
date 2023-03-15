{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit FcgiStdOutWriterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    StdOutIntf,
    StreamStdOutImpl,
    FcgiRequestIdAwareIntf;

type

    (*!-----------------------------------------------
     * IStdOut implementation having capability to write
     * response to FCGI_STDOUT
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiStdOutWriter = class(TStreamStdOut)
    private
        fRequestIdAware : IFcgiRequestIdAware;

        (*!------------------------------------------------
         * write string to FCGI_STDOUT
         *-----------------------------------------------
         * @param str, string to output
         * @param requestId, FastCGI record request Id
         * @param stream, stream to write
         * @return current instance
         *-----------------------------------------------*)
        function writeStdOut(const str : string; const requestId : word; const stream : IStreamAdapter) : IStdOut;

        (*!------------------------------------------------
         * mark end of request
         *-----------------------------------------------
         * @param stream, stream to write
         * @return current instance
         *-----------------------------------------------*)
        function writeEnd(const requestId : word; const stream : IStreamAdapter) : IStdOut;

    protected

        (*!------------------------------------------------
         * write string to FCGI_STDOUT stream and
         * mark it end of request (if markEnd is true)
         *-----------------------------------------------
         * @param stream, stream to write
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------
         * very long string may be splitted into several
         * FCGI_STDOUT records
         *-----------------------------------------------*)
        function writeStream(const stream : IStreamAdapter; const str : string) : IStdOut; override;
    public

        constructor create(
            const requestIdAware : IFcgiRequestIdAware;
            const astream : IStreamAdapter = nil
        );

    end;

implementation

uses

    classes,
    math,
    strutils,
    FcgiRecordIntf,
    FcgiStdOut,
    FcgiEndRequest,
    StreamAdapterImpl;

    constructor TFcgiStdOutWriter.create(
        const requestIdAware : IFcgiRequestIdAware;
        const astream : IStreamAdapter = nil
    );
    begin
        inherited create(astream);
        fRequestIdAware := requestIdAware;
    end;

    (*!------------------------------------------------
     * write string to FCGI_STDOUT
     *-----------------------------------------------
     * @param str, string to output
     * @param requestId, FastCGI record request Id
     * @param stream, stream to write
     * @return current instance
     *-----------------------------------------------*)
    function TFcgiStdOutWriter.writeStdOut(const str : string; const requestId : word; const stream : IStreamAdapter) : IStdOut;
    var arecord : IFcgiRecord;
        strStream : IStreamAdapter;
    begin
        if (str <> '') then
        begin
            strStream := TStreamAdapter.create(TStringStream.create(str));
            strStream.seek(0);
            arecord := TFcgiStdOut.create(strStream, requestId);
            arecord.write(stream);
        end;
        result := self;
    end;

    (*!------------------------------------------------
     * mark end of request
     *-----------------------------------------------
     * @param stream, stream to write
     * @return current instance
     *-----------------------------------------------*)
    function TFcgiStdOutWriter.writeEnd(const requestId : word; const stream : IStreamAdapter) : IStdOut;
    var arecord : IFcgiRecord;
    begin
        arecord := TFcgiEndRequest.create(
            TStreamAdapter.create(TMemoryStream.create()),
            requestId
        );
        arecord.write(stream);
        result := self;
    end;

    (*!------------------------------------------------
     * write string to FCGI_STDOUT stream and
     * mark it end of request (if markEnd is true)
     *-----------------------------------------------
     * @param stream, stream to write
     * @param str, string to write
     * @return current instance
     *-----------------------------------------------
     * very long string may be splitted into several
     * FCGI_STDOUT records
     *-----------------------------------------------*)
    function TFcgiStdOutWriter.writeStream(const stream : IStreamAdapter; const str : string) : IStdOut;
    const MAX_STR_PER_RECORD = 32 * 1024;
    var i, totChunk, excess, len, astart, acount : integer;
        requestId : word;
    begin
        //get request id associated with current complete request
        requestId := fRequestIdAware.getRequestId();
        //split string into several shorter strings
        len := length(str);
        totChunk := len div MAX_STR_PER_RECORD;
        excess := len mod MAX_STR_PER_RECORD;
        if (excess > 0) then
        begin
            inc(totChunk);
        end;

        astart := 1;
        for i := 0 to totChunk-1 do
        begin
            acount := min(MAX_STR_PER_RECORD, len);
            writeStdOut(midStr(str, astart, acount), requestId, stream);
            inc(astart, acount);
        end;

        writeEnd(requestId, stream);
        result:= self;
    end;

end.
