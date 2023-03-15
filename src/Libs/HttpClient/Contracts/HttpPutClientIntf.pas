{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpPutClientIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    ResponseStreamIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to send
     * HTTP PUT request to a server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IHttpPutClient = interface
        ['{D3AC5625-A6D4-41D6-B69C-75EB75B1E982}']

        (*!------------------------------------------------
         * send HTTP PUT request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return HTTP response
         *-----------------------------------------------*)
        function put(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

    end;

implementation

end.
