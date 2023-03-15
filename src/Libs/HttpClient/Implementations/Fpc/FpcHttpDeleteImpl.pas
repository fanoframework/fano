{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpcHttpDeleteImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    HttpDeleteClientIntf,
    ResponseStreamIntf,
    SerializeableIntf,
    FpcHttpMethodImpl;

type

    (*!------------------------------------------------
     * class that send HTTP DELETE to server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFpcHttpDelete = class(TFpcHttpMethod, IHttpDeleteClient)
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

    end;

implementation

    (*!------------------------------------------------
     * send actual HTTP request
     *-----------------------------------------------
     * @param url url to send request
     * @param stream response stream
     *-----------------------------------------------*)
    procedure TFpcHttpDelete.sendRequest(const url : string; const stream : TStream);
    begin
        fHttpClient.delete(url, stream);
    end;

    (*!------------------------------------------------
     * send HTTP DELETE request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TFpcHttpDelete.delete(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := send(url, data);
    end;

end.
