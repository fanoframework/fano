{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpCurlImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    libcurl,
    InjectableObjectImpl,
    HttpClientHandleAwareIntf;

type

    (*!------------------------------------------------
     * basic class that manage Curl handle
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpCurl = class(TInjectableObject, IHttpClientHandleAware)
    private
        (*!------------------------------------------------
        * internal variable that holds curl handle
        *-----------------------------------------------*)
        hCurl : pCurl;
    public
        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------*)
        constructor create();

        (*!------------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * get handle
         *-----------------------------------------------
         * @return handle
         *-----------------------------------------------*)
        function handle(): pointer;
    end;

implementation

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------*)
    constructor THttpCurl.create();
    begin
        //initialize curl
        hCurl := curl_easy_init();
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor THttpCurl.destroy();
    begin
        curl_easy_cleanup(hCurl);
        inherited destroy();
    end;

    (*!------------------------------------------------
     * get handle
     *-----------------------------------------------
     * @return handle
     *-----------------------------------------------*)
    function THttpCurl.handle(): pointer;
    begin
        result := hCurl;
    end;

initialization
    curl_global_init(CURL_GLOBAL_DEFAULT);
finalization
    curl_global_cleanup();
end.
