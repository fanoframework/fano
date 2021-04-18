{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpPutImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    HttpMethodImpl,
    HttpPutClientIntf,
    ResponseStreamIntf,
    SerializeableIntf;

type

    (*!------------------------------------------------
     * class that send HTTP PUT to server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpPut = class(THttpMethod, IHttpPutClient)
    public

        (*!------------------------------------------------
         * send HTTP PUT request
         *-----------------------------------------------
         * @param url url to send request
         * @param context object instance related to this message
         * @return response from server
         *-----------------------------------------------*)
        function put(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

    end;

implementation

uses

    libcurl;

    (*!------------------------------------------------
     * send HTTP PUT request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function THttpPut.put(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    var params : string;
    begin
        raiseExceptionIfCurlNotInitialized();
        streamInst.reset();
        curl_easy_setopt(hCurl, CURLOPT_URL, [ PChar(url) ]);
        curl_easy_setopt(hCurl, CURLOPT_UPLOAD, [ 1 ]);
        curl_easy_setopt(hCurl, CURLOPT_PUT, [ 1 ]);
        params := '';
        if (data <> nil) then
        begin
           params := data.serialize();
        end;
        curl_easy_setopt(hCurl , CURLOPT_READDATA, [ PChar(params) ]);
        executeCurl(hCurl);
        result := streamInst;
    end;

end.
