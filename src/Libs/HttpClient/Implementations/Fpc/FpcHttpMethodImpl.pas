{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpcHttpMethodImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    fphttpclient,
    InjectableObjectImpl,
    ResponseStreamIntf,
    SerializeableIntf,
    HttpClientHeadersIntf,
    HttpClientHandleAwareIntf,
    QueryStrBuilderIntf;

type

    (*!------------------------------------------------
     * base class for HTTP operation usng TFpHttpClient
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFpcHttpMethod = class abstract (TInjectableObject, IHttpClientHeaders)
    protected
        fQueryStrBuilder : IQueryStrBuilder;
        fHttpClient : TFPHTTPClient;

        (*!------------------------------------------------
         * send HTTP request
         *-----------------------------------------------
         * @param url url to send request
         * @param query data that is passed as query string
         * @param body data is passed as request body
         * @return current instance
        *-----------------------------------------------*)
        function send(
            const url : string;
            const query : ISerializeable = nil;
            const body : ISerializeable = nil
        ) : IResponseStream;

        (*!------------------------------------------------
         * send actual HTTP request
         *-----------------------------------------------
         * @param url url to send request
         * @param stream response stream
        *-----------------------------------------------*)
        procedure sendRequest(const url : string; const stream : TStream); virtual; abstract;
    public

        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param queryStrBuilder instance of object having
         *                        capability to build query
         *                        string
         *-----------------------------------------------*)
        constructor create(const queryStrBuilder : IQueryStrBuilder);

        (*!------------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         *  add header
         *-----------------------------------------------
         * @param aheader string contain header name
         * @param avalue string contain header value
         * @return current instance
         *-----------------------------------------------*)
        function add(const aheader : string; const avalue : string) : IHttpClientHeaders;

        (*!------------------------------------------------
         *  apply added header
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function apply() : IHttpClientHeaders;

    end;

implementation

uses

    ResponseStreamImpl,
    EHttpClientErrorImpl;

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------
     * @param queryStrBuilder instance of object having
     *                        capability to build query
     *                        string
     *-----------------------------------------------*)
    constructor TFpcHttpMethod.create(
        const queryStrBuilder : IQueryStrBuilder
    );
    begin
        fHttpClient := TFPHTTPClient.create(nil);
        fQueryStrBuilder := queryStrBuilder;
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TFpcHttpMethod.destroy();
    begin
        fQueryStrBuilder := nil;
        fHttpClient.free();
        inherited destroy();
    end;

    (*!------------------------------------------------
     *  add header
     *-----------------------------------------------
     * @param aheader string contain header name
     * @param avalue string contain header value
     * @return current instance
     *-----------------------------------------------*)
    function TFpcHttpMethod.add(const aheader : string; const avalue : string) : IHttpClientHeaders;
    begin
        fHttpClient.addHeader(aheader, avalue);
        result := self;
    end;

    (*!------------------------------------------------
     *  apply added header
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TFpcHttpMethod.apply() : IHttpClientHeaders;
    begin
        //do nothing as not relevant here
        result := self;
    end;

    (*!------------------------------------------------
     * send HTTP request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TFpcHttpMethod.send(
        const url : string;
        const query : ISerializeable = nil;
        const body : ISerializeable = nil
    ) : IResponseStream;
    var stream, bodyStream : TStream;
        fullUrl : string;
    begin
        fullUrl := fQueryStrBuilder.buildUrlWithQueryParams(url, query);
        try
            stream := TMemoryStream.create();
            if (assigned(body)) then
            begin
                bodyStream := TStringStream.create(body.serialize());
                try
                    fHttpClient.RequestBody := bodyStream;
                    sendRequest(fullUrl, stream);
                finally
                    bodyStream.free();
                end;
            end else
            begin
                sendRequest(fullUrl, stream);
            end;
            //wrap as IResponseStream and delete stream when goes out of scope
            result := TResponseStream.create(stream);
        except
            //something is wrong
            stream.free();
            result := nil;
        end;
    end;
end.
