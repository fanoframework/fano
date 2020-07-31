{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UwsgiParserImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    UwsgiParserIntf,
    EnvironmentIntf;

type

    (*!-----------------------------------------------
     * Class which can process uwsgi stream from web server
     *
     * @link https://uwsgi-docs.readthedocs.io/en/latest/Protocol.html
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUwsgiParser = class(TInterfacedObject, IUwsgiParser)
    private
        fStdIn : IStreamAdapter;
        fEnv : ICGIEnvironment;

        (*!------------------------------------------------
         * parse string and return CGI environment variable
         *-----------------------------------------------*)
        function parseEnv(const stream : IStreamAdapter; const size : integer) : ICGIEnvironment;

        (*!------------------------------------------------
         * parse string and return POST data as stream
         *-----------------------------------------------*)
        procedure readRequestBodyIfAny(
            const stream : IStreamAdapter;
            const stdIn : IStreamAdapter
        );

        function getContentLength(const buff : IStreamAdapter) : int64;
        function readBufferToStr(const buff : IStreamAdapter) : string;
    public
        constructor create();
        destructor destroy(); override;

        (*!------------------------------------------------
         * parse request stream
         *-----------------------------------------------*)
        function parse(const stream : IStreamAdapter) : boolean;

        (*!------------------------------------------------
         * get StdIn stream for complete request
         *-----------------------------------------------*)
        function getStdIn() : IStreamAdapter;

        (*!------------------------------------------------
         * get StdIn stream for complete request
         *-----------------------------------------------*)
        function getEnv() : ICGIEnvironment;

        (*!------------------------------------------------
         * get total expected data in bytes in buffer
         *-----------------------------------------------
         * @return number of bytes
         *-----------------------------------------------*)
        function expectedSize(const buff : IStreamAdapter) : int64;
    end;

implementation

uses

    Classes,
    SysUtils,
    StreamAdapterImpl,
    NullStreamAdapterImpl,
    KeyValueEnvironmentImpl,
    NullEnvironmentImpl,
    UwsgiParamKeyValuePairImpl,
    EInvalidUwsgiHeaderImpl,
    MappedMemoryStreamImpl,
    NullMemoryDeallocatorImpl;

resourcestring

    sInvalidUwsgiHeader = 'Invalid uwsgi header';

type

    uwsgi_packet_header = packed record
        modifier1 : byte;
        datasize : word;
        modifier2 : byte;
    end;

const
    HDR_SIZE = sizeof(uwsgi_packet_header);

    constructor TUwsgiParser.create();
    begin
        inherited create();
        //initialize with null implementation
        fStdIn := TStreamAdapter.create(TStringStream.create(''));
        fEnv := TNullCGIEnvironment.create();
    end;

    destructor TUwsgiParser.destroy();
    begin
        fStdIn := nil;
        fEnv := nil;
        inherited destroy();
    end;

    function TUwsgiParser.parseEnv(const stream : IStreamAdapter; const size : integer) : ICGIEnvironment;
    var buff : pointer;
    begin
        //we get uwsgi block vars, read total data
        getMem(buff, size);
        try
            stream.readBuffer(buff^, size);
            result := TKeyValueEnvironment.create(
                TUwsgiParamKeyValuePair.create(
                    TStreamAdapter.create(
                        TMappedMemoryStream.create(
                            buff,
                            size,
                            TNullMemoryDeallocator.create()
                        )
                    )
                )
            );
        finally
            freeMem(buff);
        end;
    end;

    procedure TUwsgiParser.readRequestBodyIfAny(
        const stream : IStreamAdapter;
        const stdIn : IStreamAdapter
    );
    const BUFF_SIZE = 4096;
    var bodyRead : integer;
        buff : pointer;
    begin
        getMem(buff, BUFF_SIZE);
        bodyRead := 0;
        try
            repeat
                bodyRead := stream.read(buff^, BUFF_SIZE);
                stdIn.write(buff^, bodyRead);
            until (bodyRead = -1) or (bodyRead < BUFF_SIZE);
            stdIn.seek(0, FROM_BEGINNING);
        finally
            freeMem(buff);
        end;
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    function TUwsgiParser.parse(const stream : IStreamAdapter) : boolean;
    var hdr : uwsgi_packet_header;
        bytesRead : integer;
    begin
        bytesRead := stream.read(hdr, HDR_SIZE);
        if (bytesRead = HDR_SIZE) then
        begin
            if (hdr.modifier1 = 0) and ((hdr.modifier2 = 0)) then
            begin
                //we get uwsgi block vars, read total data
                fEnv := parseEnv(stream, hdr.datasize);
                readRequestBodyIfAny(stream, fStdIn);
            end;
        end else
        begin
            raise EInvalidUwsgiHeader.create(sInvalidUwsgiHeader);
        end;
        result := (bytesRead = HDR_SIZE);
    end;

    (*!------------------------------------------------
     * get StdIn stream for complete request
     *-----------------------------------------------*)
    function TUwsgiParser.getStdIn() : IStreamAdapter;
    begin
        result := fStdIn;
    end;

    (*!------------------------------------------------
     * get environment for complete request
     *-----------------------------------------------*)
    function TUwsgiParser.getEnv() : ICGIEnvironment;
    begin
        result := fEnv;
    end;

    function TUwsgiParser.readBufferToStr(const buff : IStreamAdapter) : string;
    var totSize : integer;
    begin
        totSize := buff.size();
        if totSize > 0 then
        begin
            setLength(result, totSize);
            buff.seek(0, FROM_BEGINNING);
            buff.read(result[1], totSize);
        end else
        begin
            result := '';
        end;
    end;

    function TUwsgiParser.getContentLength(const buff : IStreamAdapter) : int64;
    var envvars : string;
        contentLenPos : integer;
        varLen : word;
        contentLenStr : string;
    begin
        result := -1;
        envvars := readBufferToStr(buff);
        contentLenPos := pos('CONTENT_LENGTH', envvars);
        if contentLenPos > 0 then
        begin
            //this request has request body, find total body in bytes
            //14 is length of CONTENT_LENGTH string. so we basically seek to read
            //number of character. Need to decrease 1 byte because pos() is start from 1
            //while buff.seek() is zero-based.
            buff.seek(contentLenPos + 14 - 1, FROM_BEGINNING);
            buff.read(varLen, 2);
            if varLen <> 0 then
            begin
                setLength(contentLenStr, varLen);
                buff.read(contentLenStr[1], varLen);
                result := strToInt(contentLenStr);
            end else
            begin
                //TODO: In nginx, somehow we get here. Must inspect further why
                //this request does not have request body
                result := 0;
            end;
        end else
        begin
            //this request does not have request body
            result := 0;
        end
    end;

    (*!------------------------------------------------
     * get total expected data in bytes in buffer
     *-----------------------------------------------
     * @return number of bytes
     *-----------------------------------------------*)
    function TUwsgiParser.expectedSize(const buff : IStreamAdapter) : int64;
    var hdr : uwsgi_packet_header;
        envLenFound : boolean;
        contentLenFound : boolean;
        contentLen : integer;
        lenValue : integer;
        bytesRead : integer;
    begin
        result := -1;
        envLenFound := false;
        lenValue := -1;
        contentLenFound := false;
        contentLen := -1;
        if buff.size() >= HDR_SIZE then
        begin
            buff.seek(0, FROM_BEGINNING);
            bytesRead := buff.read(hdr, HDR_SIZE);
            if (bytesRead = HDR_SIZE) and
               (hdr.modifier1 = 0) and
               (hdr.modifier2 = 0) then
            begin
                envLenFound := true;
                lenValue := hdr.dataSize;

                if buff.size() >= (HDR_SIZE + lenValue) then
                begin
                    //all env vars  is available, get content length if any
                    contentLen := getContentLength(buff);
                    if contentLen >= 0 then
                    begin
                        contentLenFound := true;
                    end;
                end;
            end;
            buff.seek(0, FROM_END);
        end;
        if (envLenFound) and (contentLenFound) then
        begin
            result := HDR_SIZE + lenValue + contentLen;
        end;
    end;

end.
