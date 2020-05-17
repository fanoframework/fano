{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BaseResponseImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    ResponseIntf,
    HeadersIntf,
    ResponseStreamIntf,
    CloneableIntf;

type
    (*!------------------------------------------------
     * base Http response class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TBaseResponse = class(TInterfacedObject, IResponse, ICloneable)
    private
        httpHeaders : IHeaders;
        bodyStream : IResponseStream;
        procedure writeToStdOutput(const respBody : IResponseStream);
    public
        constructor create(
            const hdrs : IHeaders;
            const bodyStrs : IResponseStream
        );
        destructor destroy(); override;

        (*!------------------------------------
         * get http headers instance
         *-------------------------------------
         * @return header instance
         *-------------------------------------*)
        function headers() : IHeaders;

        (*!------------------------------------
         * output http response to STDOUT
         *-------------------------------------
         * @return current instance
         *-------------------------------------*)
        function write() : IResponse;  virtual;

        (*!------------------------------------
         * get response body
         *-------------------------------------
         * @return response body
         *-------------------------------------*)
        function body() : IResponseStream;

        (*!------------------------------------
         * set new response body
         *-------------------------------------
         * @return response body
         *-------------------------------------*)
        function setBody(const newBody : IResponseStream) : IResponse;

        function clone() : ICloneable; virtual; abstract;
    end;

implementation

const

    BUFFER_SIZE = 8 * 1024;


    constructor TBaseResponse.create(
        const hdrs : IHeaders;
        const bodyStrs : IResponseStream
    );
    begin
        httpHeaders := hdrs;
        bodyStream := bodyStrs;
    end;

    destructor TBaseResponse.destroy();
    begin
        inherited destroy();
        httpHeaders := nil;
        bodyStream := nil
    end;

    (*!------------------------------------
     * get http headers instance
     *-------------------------------------
     * @return header instance
     *-------------------------------------*)
    function TBaseResponse.headers() : IHeaders;
    begin
        result := httpHeaders;
    end;

    (*!------------------------------------
     * read response body and output it to
     * standard output
     *-------------------------------------
     * @param respBody response stream to output
     *-------------------------------------*)
    procedure TBaseResponse.writeToStdOutput(const respBody : IResponseStream);
    var numBytesRead: longint;
        buff : string;
    begin
        setLength(buff, BUFFER_SIZE);
        respBody.seek(0);
        //stream maybe big in size, so read in loop
        //by using smaller buffer to avoid consuming too much resource
        repeat
            numBytesRead := respBody.read(buff[1], BUFFER_SIZE);
            if (numBytesRead < BUFFER_SIZE) then
            begin
                //setLength will allocate new memory
                //which expensive in a loop, so only doing it
                //when we are in end of buffer
                setLength(buff, numBytesRead);
            end;
            system.write(buff);
        until (numBytesRead < BUFFER_SIZE);
    end;

    function TBaseResponse.write() : IResponse;
    begin
        if (not httpHeaders.has('Content-Type')) then
        begin
            //if not Content-Type header defined assume html
            httpHeaders.setHeader('Content-Type', 'text/html');
        end;
        httpHeaders.writeHeaders();
        writeToStdOutput(bodyStream);
        result := self;
    end;

    (*!------------------------------------
     * get response body
     *-------------------------------------
     * @return response body
     *-------------------------------------*)
    function TBaseResponse.body() : IResponseStream;
    begin
        result := bodyStream;
    end;

    (*!------------------------------------
     * set new response body
     *-------------------------------------
     * @return response body
     *-------------------------------------*)
    function TBaseResponse.setBody(const newBody : IResponseStream) : IResponse;
    begin
        bodyStream := newBody;
        result := self;
    end;
end.
