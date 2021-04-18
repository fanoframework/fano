{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonResponseImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ResponseIntf,
    ResponseStreamIntf,
    HeadersIntf,
    CloneableIntf;

type
    (*!------------------------------------------------
     * base JSON response class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TJsonResponse = class(TInterfacedObject, IResponse, ICloneable)
    private
        httpHeaders : IHeaders;
        responseStream : IResponseStream;
    public
        constructor create(const hdrs : IHeaders; const json : string);
        destructor destroy(); override;

        (*!------------------------------------
         * get http headers instance
         *-------------------------------------
         * @return header instance
         *-------------------------------------*)
        function headers() : IHeaders;

        function write() : IResponse;
        function clone() : ICloneable;

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
    end;

implementation

uses

    classes,
    sysutils,
    httpprotocol,
    ResponseStreamImpl;

    constructor TJsonResponse.create(const hdrs : IHeaders; const json : string);
    begin
        httpHeaders := hdrs;
        responseStream := TResponseStream.create(TStringStream.create(json));
    end;

    destructor TJsonResponse.destroy();
    begin
        responseStream := nil;
        httpHeaders := nil;
        inherited destroy();
    end;

    (*!------------------------------------
     * get http headers instance
     *-------------------------------------
     * @return header instance
     *-------------------------------------*)
    function TJsonResponse.headers() : IHeaders;
    begin
        result := httpHeaders;
    end;

    function TJsonResponse.write() : IResponse;
    begin
        httpHeaders.setHeader('Content-Type', 'application/json');
        httpHeaders.setHeader('Content-Length', intToStr(responseStream.size()));
        httpHeaders.writeHeaders();
        writeln(responseStream.read());
        result := self;
    end;

    function TJsonResponse.clone() : ICloneable;
    var clonedObj : IResponse;
    begin
        clonedObj := TJsonResponse.create(
            httpHeaders.clone() as IHeaders,
            responseStream.read()
        );
        result := clonedObj;
    end;

    (*!------------------------------------
     * get response body
     *-------------------------------------
     * @return response body
     *-------------------------------------*)
    function TJsonResponse.body() : IResponseStream;
    begin
        result := responseStream;
    end;

    (*!------------------------------------
     * set new response body
     *-------------------------------------
     * @return response body
     *-------------------------------------*)
    function TJsonResponse.setBody(const newBody : IResponseStream) : IResponse;
    begin
        responseStream := newBody;
        result := self;
    end;
end.
