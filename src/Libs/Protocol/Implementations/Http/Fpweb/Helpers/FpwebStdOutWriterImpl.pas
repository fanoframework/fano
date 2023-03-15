{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit FpwebStdOutWriterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    fphttpserver,
    StreamAdapterIntf,
    StdOutIntf,
    StreamStdOutImpl,
    FpwebResponseAwareIntf;

type

    (*!-----------------------------------------------
     * IStdOut implementation having capability to write
     * response to TFpHttpServer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFpwebStdOutWriter = class(TStreamStdOut, IFpwebResponseAware)
    private
        fResponse : TFPHTTPConnectionResponse;

        procedure writeHeaders(
            const aresponse : TFPHTTPConnectionResponse;
            const headers : TStringArray
        );
    protected

        (*!------------------------------------------------
         * write string to stream and
         *-----------------------------------------------
         * @param stream, stream to write
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function writeStream(const stream : IStreamAdapter; const str : string) : IStdOut; override;
    public
        (*!------------------------------------------------
         * get TFpHttpServer response connection
         *-----------------------------------------------
         * @return connection
         *-----------------------------------------------*)
        function getResponse() : TFPHTTPConnectionResponse;

        (*!------------------------------------------------
         * set TFpHttpServer response connection
         *-----------------------------------------------*)
        procedure setResponse(aresponse : TFPHTTPConnectionResponse);

        property response : TFPHTTPConnectionResponse read getResponse write setResponse;
    end;

implementation

uses

    MappedMemoryStreamImpl,
    NullMemoryDeallocatorImpl,
    EInvalidRequestImpl;

const

    HEADER_SEPARATOR_STR = LineEnding + LineEnding;
    HEADER_SEPARATOR_LEN = length(HEADER_SEPARATOR_STR);

    procedure TFpwebStdOutWriter.writeHeaders(
        const aresponse : TFPHTTPConnectionResponse;
        const headers : TStringArray
    );
    var
        headerItem : TStringArray;
        i : integer;
    begin
        for i:= 0 to length(headers) - 1 do
        begin
            headerItem := headers[i].split(':');
            if length(headerItem) = 0 then
            begin
                //skip invalid header
                continue;
            end;

            if length(headerItem) = 1 then
            begin
                //force to use empty value
                setLength(headerItem, 2);
                headerItem[1] := '';
            end;

            if (headerItem[0] <> 'Status') then
            begin
                aresponse.setFieldByName(headerItem[0], trim(headerItem[1]));
            end else
            begin
                //read status
                try
                    aresponse.code := strToInt(trim(headerItem[1]).split(' ')[0]);
                except
                    on e : EConvertError do
                    begin
                        //no status code provided
                        raise EInvalidRequest.create('Bad request');
                    end;
                end;
            end;
        end;
    end;

    (*!------------------------------------------------
     * write string to STDOUT stream
     *-----------------------------------------------
     * @param stream, stream to write
     * @param str, string to write
     * @return current instance
     *-----------------------------------------------*)
    function TFpwebStdOutWriter.writeStream(const stream : IStreamAdapter; const str : string) : IStdOut;
    var
        headers : TStringArray;
        separatorPos : integer;
        content : TMappedMemoryStream;
    begin
        separatorPos := pos(HEADER_SEPARATOR_STR, str);

        headers := copy(str, 1, separatorPos + 1).split(
            LineEnding,
            TStringSplitOptions.ExcludeEmpty
        );

        writeHeaders(fResponse, headers);

        //we need str without headers
        //this is simply to avoid having to copy response string
        //to another buffer which may quite big
        content := TMappedMemoryStream.create(
            pointer(pointer(str) + separatorPos + HEADER_SEPARATOR_LEN - 1),
            length(str) - separatorPos - HEADER_SEPARATOR_LEN + 1,
            TNullMemoryDeallocator.create()
        );
        try
            fResponse.contentStream := content;
            fResponse.SendContent();
            result:= self;
        finally
            content.free();
        end;
    end;


    (*!------------------------------------------------
     * get TFpHttpServer response connection
     *-----------------------------------------------
     * @return connection
     *-----------------------------------------------*)
    function TFpwebStdOutWriter.getResponse() : TFPHTTPConnectionResponse;
    begin
        result := fResponse;
    end;

    (*!------------------------------------------------
     * set TFpHttpServer response connection
     *-----------------------------------------------*)
    procedure TFpwebStdOutWriter.setResponse(aresponse : TFPHTTPConnectionResponse);
    begin
        fResponse := aresponse;
    end;

end.
