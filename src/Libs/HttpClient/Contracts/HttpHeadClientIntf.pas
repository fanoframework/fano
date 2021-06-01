{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpHeadClientIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    ResponseStreamIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to send
     * HTTP HEAD request to a server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IHttpHeadClient = interface
        ['{3FCE96C4-FA4E-4F6A-9FA2-172EB431E886}']

        (*!------------------------------------------------
         * send HTTP HEAD request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return HTTP response
         *-----------------------------------------------*)
        function head(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

    end;

implementation

end.
