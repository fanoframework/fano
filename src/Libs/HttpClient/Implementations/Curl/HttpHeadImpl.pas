{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpHeadImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    HttpMethodImpl,
    HttpHeadClientIntf,
    ResponseStreamIntf,
    SerializeableIntf;

type

    (*!------------------------------------------------
     * class that send HTTP HEAD to server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpHead = class(THttpMethod, IHttpHeadClient)
    public

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
    function THttpHead.head(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    var fullUrl : string;
    begin
        raiseExceptionIfCurlNotInitialized();
        streamInst.reset();
        fullUrl := fQueryStrBuilder.buildUrlWithQueryParams(url, data);
        curl_easy_setopt(hCurl, CURLOPT_URL, [ pchar(fullUrl) ]);
        curl_easy_setopt(hCurl, CURLOPT_NOBODY, [ 1 ]);
        executeCurl(hCurl);
        result := streamInst;
    end;

end.
