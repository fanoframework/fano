{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpClientHeadersImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    libcurl,
    HttpClientHeadersIntf,
    HttpClientHandleAwareIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * class that set/get Curl HTTP options
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpClientHeaders = class(TInjectableObject, IHttpClientHeaders)
    private
        (*!------------------------------------------------
        * internal variable that holds curl handle
        *-----------------------------------------------*)
        hCurl : PCurl;
        headerList : Pcurl_slist;
    public
        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param curlHandle instance class that can get handle
         *-----------------------------------------------*)
        constructor create(const curlHandle : IHttpClientHandleAware);

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

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------*)
    constructor THttpClientHeaders.create(const curlHandle : IHttpClientHandleAware);
    begin
        hCurl := curlHandle.handle();
        headerList := nil;
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor THttpClientHeaders.destroy();
    begin
        inherited destroy();
        curl_slist_free_all(headerList);
        headerList := nil;
        hCurl := nil;
    end;

    (*!------------------------------------------------
     *  add header
     *-----------------------------------------------
     * @param aheader string contain header name
     * @param avalue string contain header value
     * @return current instance
     *-----------------------------------------------*)
    function THttpClientHeaders.add(const aheader : string; const avalue : string) : IHttpClientHeaders;
    begin
        headerList := curl_slist_append(headerList, pchar(aheader + ': ' + avalue));
        result := self;
    end;

    (*!------------------------------------------------
     *  apply added header
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function THttpClientHeaders.apply() : IHttpClientHeaders;
    begin
        curl_easy_setopt(hCurl, CURLOPT_HTTPHEADER, [ headerList ]);
        result := self;
    end;

end.
