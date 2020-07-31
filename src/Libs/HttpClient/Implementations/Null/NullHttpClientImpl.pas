{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullHttpClientImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    ResponseStreamIntf,
    SerializeableIntf,
    HttpClientHeadersIntf,
    HttpGetClientIntf,
    HttpPostClientIntf,
    HttpPutClientIntf,
    HttpDeleteClientIntf,
    HttpPatchClientIntf,
    HttpOptionsClientIntf,
    HttpHeadClientIntf;

type

    (*!------------------------------------------------
     * null class for HTTP operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullHttpClient = class(
        TInjectableObject,
        IHttpClientHeaders,
        IHttpGetClient,
        IHttpPostClient,
        IHttpPutClient,
        IHttpDeleteClient,
        IHttpPatchClient,
        IHttpOptionsClient,
        IHttpHeadClient
    )
    protected
        fResponseStream : IResponseStream;
    public

        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param headersInst instance class that can set headers
         * @param fStream stream instance that will be used to
         *                store data coming from server
         *-----------------------------------------------*)
        constructor create();

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

        (*!------------------------------------------------
         * send HTTP GET request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return response from server
         *-----------------------------------------------*)
        function get(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

        (*!------------------------------------------------
         * send HTTP POST request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return response from server
         *-----------------------------------------------*)
        function post(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

        (*!------------------------------------------------
         * send HTTP PUT request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return response from server
         *-----------------------------------------------*)
        function put(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

        (*!------------------------------------------------
         * send HTTP DELETE request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return response from server
         *-----------------------------------------------*)
        function delete(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

        (*!------------------------------------------------
         * send HTTP PATCH request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return response from server
         *-----------------------------------------------*)
        function patch(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

        (*!------------------------------------------------
         * send HTTP OPTIONS request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return response from server
         *-----------------------------------------------*)
        function options(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

        (*!------------------------------------------------
         * send HTTP HEAD request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return response from server
         *-----------------------------------------------*)
        function head(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

    end;

implementation

uses

    NullResponseStreamImpl;

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------*)
    constructor TNullHttpClient.create();
    begin
        fResponseStream := TNullResponseStream.create();
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TNullHttpClient.destroy();
    begin
        fResponseStream := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     *  add header
     *-----------------------------------------------
     * @param aheader string contain header name
     * @param avalue string contain header value
     * @return current instance
     *-----------------------------------------------*)
    function TNullHttpClient.add(const aheader : string; const avalue : string) : IHttpClientHeaders;
    begin
        //intentionally does nothing
        result := self;
    end;

    (*!------------------------------------------------
     *  apply added header
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TNullHttpClient.apply() : IHttpClientHeaders;
    begin
        //intentionally does nothing
        result := self;
    end;

    (*!------------------------------------------------
     * send HTTP GET request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TNullHttpClient.get(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := fResponseStream;
    end;

    (*!------------------------------------------------
     * send HTTP POST request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TNullHttpClient.post(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := fResponseStream;
    end;

    (*!------------------------------------------------
     * send HTTP PUT request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TNullHttpClient.put(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := fResponseStream;
    end;

    (*!------------------------------------------------
     * send HTTP DELETE request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TNullHttpClient.delete(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := fResponseStream;
    end;

    (*!------------------------------------------------
     * send HTTP PATCH request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TNullHttpClient.patch(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := fResponseStream;
    end;

    (*!------------------------------------------------
     * send HTTP OPTIONS request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TNullHttpClient.options(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := fResponseStream;
    end;

    (*!------------------------------------------------
     * send HTTP HEAD request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TNullHttpClient.head(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := fResponseStream;
    end;

end.
