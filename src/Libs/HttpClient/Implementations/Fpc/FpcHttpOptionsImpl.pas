{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpcHttpOptionsImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    HttpOptionsClientIntf,
    ResponseStreamIntf,
    SerializeableIntf,
    FpcHttpMethodImpl;

type

    (*!------------------------------------------------
     * class that send HTTP OPTIONS to server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFpcHttpOptions = class(TFpcHttpMethod, IHttpOptionsClient)
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

    end;

implementation

    (*!------------------------------------------------
     * send actual HTTP request
     *-----------------------------------------------
     * @param url url to send request
     * @param stream response stream
     *-----------------------------------------------*)
    procedure TFpcHttpOptions.sendRequest(const url : string; const stream : TStream);
    begin
        fHttpClient.options(url, stream);
    end;

    (*!------------------------------------------------
     * send HTTP OPTIONS request
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return current instance
     *-----------------------------------------------*)
    function TFpcHttpOptions.options(
        const url : string;
        const data : ISerializeable = nil
    ) : IResponseStream;
    begin
        result := send(url, data);
    end;

end.
