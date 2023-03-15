{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpPostClientIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    ResponseStreamIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to send
     * HTTP POST request to a server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IHttpPostClient = interface
        ['{5EF1CEAC-CF87-4EBE-AE19-7701EA150A61}']

        (*!------------------------------------------------
         * send HTTP POST request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return HTTP response
         *-----------------------------------------------*)
        function post(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponseStream;

    end;

implementation

end.
