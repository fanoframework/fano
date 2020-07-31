{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpPatchClientIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    ResponseStreamIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to send
     * HTTP PATCH request to a server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IHttpPatchClient = interface
        ['{D6EC294C-FB0D-4219-9F2E-0ABF2F1E6DD4}']

        (*!------------------------------------------------
         * send HTTP PATCH request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return HTTP response
         *-----------------------------------------------*)
        function patch(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

    end;

implementation

end.
