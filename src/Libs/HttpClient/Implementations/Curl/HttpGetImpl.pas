{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpGetImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    HttpMethodImpl,
    HttpGetClientIntf,
    ResponseStreamIntf,
    SerializeableIntf,
    QueryStrBuilderIntf;

type

    (*!------------------------------------------------
     * class that send HTTP GET to server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpGet = class(THttpMethod, IHttpGetClient)
    public
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

    end;

implementation

uses

    libcurl;

    (*!------------------------------------------------
     * send HTTP GET request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------
     * @credit: https://github.com/graemeg/freepascal/blob/master/packages/libcurl/examples/testcurl.pp
     *-----------------------------------------------*)
    function THttpGet.get(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    var fullUrl : string;
    begin
        raiseExceptionIfCurlNotInitialized();
        streamInst.reset();
        fullUrl := fQueryStrBuilder.buildUrlWithQueryParams(url, data);
        curl_easy_setopt(hCurl, CURLOPT_URL, [ pchar(fullUrl) ]);
        executeCurl(hCurl);
        result := streamInst;
    end;

end.
