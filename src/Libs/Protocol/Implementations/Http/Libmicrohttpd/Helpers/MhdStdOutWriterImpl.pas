{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit MhdStdOutWriterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    libmicrohttpd,
    StreamAdapterIntf,
    StdOutIntf,
    StreamStdOutImpl,
    MhdConnectionAwareIntf;

type

    (*!-----------------------------------------------
     * IStdOut implementation having capability to write
     * response to libmicrohttpd
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMhdStdOutWriter = class(TStreamStdOut, IMhdConnectionAware)
    private
        fConnection : PMHD_Connection;

        function writeHeaders(
            const response : PMHD_Response;
            const headers : TStringArray
        ) : longword;
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
         * get libmicrohttpd connection
         *-----------------------------------------------
         * @return connection
         *-----------------------------------------------*)
        function getConnection() : PMHD_Connection;

        (*!------------------------------------------------
         * set libmicrohttpd connection
         *-----------------------------------------------*)
        procedure setConnection(aconnection : PMHD_Connection);
    end;

implementation

uses

    EInvalidRequestImpl;

const

    HEADER_SEPARATOR_STR = LineEnding + LineEnding;
    HEADER_SEPARATOR_LEN = length(HEADER_SEPARATOR_STR);

    function TMhdStdOutWriter.writeHeaders(
        const response : PMHD_Response;
        const headers : TStringArray
    ) : longword;
    var
        headerItem : TStringArray;
        i : integer;
    begin
        result := MHD_HTTP_OK;
        for i:= 0 to length(headers) - 1 do
        begin
            headerItem := headers[i].split(':');
            if (headerItem[0] <> 'Status') then
            begin
                MHD_add_response_header(
                    response,
                    pchar(headerItem[0]),
                    pchar(trim(headerItem[1]))
                );
            end else
            begin
                //read status
                try
                    result := strToInt(trim(headerItem[1]).split(' ')[0]);
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
    function TMhdStdOutWriter.writeStream(const stream : IStreamAdapter; const str : string) : IStdOut;
    var
        response: PMHD_Response;
        headers : TStringArray;
        separatorPos : integer;
        statusCode : longword;
    begin
        separatorPos := pos(HEADER_SEPARATOR_STR, str);

        headers := copy(str, 1, separatorPos + 1).split(
            LineEnding,
            TStringSplitOptions.ExcludeEmpty
        );

        response := MHD_create_response_from_buffer(
            //we need str without headers
            //this is simply to avoid having to copy response string
            //to another buffer which may quite big
            length(str) - separatorPos - HEADER_SEPARATOR_LEN + 1,
            pointer(pointer(str) + separatorPos + HEADER_SEPARATOR_LEN - 1),
            MHD_RESPMEM_MUST_COPY
        );

        statusCode := writeHeaders(response, headers);

        MHD_queue_response(fConnection, statusCode, response);
        MHD_destroy_response(response);

        result:= self;
    end;

    (*!------------------------------------------------
     * get libmicrohttpd connection
     *-----------------------------------------------
     * @return connection
     *-----------------------------------------------*)
    function TMhdStdOutWriter.getConnection() : PMHD_Connection;
    begin
        result := fConnection;
    end;

    (*!------------------------------------------------
     * set libmicrohttpd connection
     *-----------------------------------------------*)
    procedure TMhdStdOutWriter.setConnection(aconnection : PMHD_Connection);
    begin
        fConnection := aconnection;
    end;
end.
