{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpcHttpHeadImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    HttpHeadClientIntf,
    ResponseStreamIntf,
    SerializeableIntf,
    FpcHttpMethodImpl;

type

    (*!------------------------------------------------
     * class that send HTTP HEAD to server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFpcHttpHead = class(TFpcHttpMethod, IHttpHeadClient)
    protected
        (*!------------------------------------------------
         * send actual HTTP request
         *-----------------------------------------------
         * @param url url to send request
         * @param stream response stream
        *-----------------------------------------------*)
        procedure sendRequest(const url : string; const stream : TStream); override;
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


    (*!------------------------------------------------
     * send actual HTTP request
     *-----------------------------------------------
     * @param url url to send request
     * @param stream response stream
     *-----------------------------------------------*)
    procedure TFpcHttpHead.sendRequest(const url : string; const stream : TStream);
    var s : TStrings;
    begin
        s := TStringList.create();
        try
            //FPC 3.0.4, TFPHTTPClient head() only accept TStrings
            //so we need to manually save to stream.
            fHttpClient.head(url, s);
            s.saveToStream(stream);
        finally
            s.free();
        end;
    end;

    (*!------------------------------------------------
     * send HTTP HEAD request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TFpcHttpHead.head(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := send(url, data);
    end;

end.
