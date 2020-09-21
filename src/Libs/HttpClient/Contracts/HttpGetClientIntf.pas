{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpGetClientIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    ResponseStreamIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to send
     * HTTP GET request to a server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IHttpGetClient = interface
        ['{A996BF42-7010-4652-B056-E457319DC300}']

        (*!------------------------------------------------
         * send HTTP GET request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return HTTP response
         *-----------------------------------------------*)
        function get(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

    end;

implementation

end.
