{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpcHttpPutImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    HttpPutClientIntf,
    ResponseStreamIntf,
    SerializeableIntf,
    FpcHttpMethodImpl;

type

    (*!------------------------------------------------
     * class that send HTTP PUT to server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFpcHttpPut = class(TFpcHttpMethod, IHttpPutClient)
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

    end;

implementation

    (*!------------------------------------------------
     * send actual HTTP request
     *-----------------------------------------------
     * @param url url to send request
     * @param stream response stream
     *-----------------------------------------------*)
    procedure TFpcHttpPut.sendRequest(const url : string; const stream : TStream);
    begin
        fHttpClient.put(url, stream);
    end;

    (*!------------------------------------------------
     * send HTTP PUT request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TFpcHttpPut.put(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := send(url, data);
    end;

end.
