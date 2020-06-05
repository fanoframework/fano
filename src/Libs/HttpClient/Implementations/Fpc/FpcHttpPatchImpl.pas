{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpcHttpPatchImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    HttpPatchClientIntf,
    ResponseStreamIntf,
    SerializeableIntf,
    FpcHttpMethodImpl;

type

    (*!------------------------------------------------
     * class that send HTTP PATCH to server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFpcHttpPatch = class(TFpcHttpMethod, IHttpPatchClient)
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

    end;

implementation

    (*!------------------------------------------------
     * send actual HTTP request
     *-----------------------------------------------
     * @param url url to send request
     * @param stream response stream
     *-----------------------------------------------*)
    procedure TFpcHttpPatch.sendRequest(const url : string; const stream : TStream);
    begin
        fHttpClient.httpMethod('PATCH', url, stream, []);
    end;

    (*!------------------------------------------------
     * send HTTP PATCH request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TFpcHttpPatch.patch(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := send(url, data);
    end;

end.
