{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpClientIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to send
     * HTTP request to a server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IHttpClient = interface
        ['{944E1D4F-08BA-446C-A662-9C1EC27DEF74}']

        (*!------------------------------------------------
         * send HTTP request
         *-----------------------------------------------
         * @param url url to send request
         * @param context object instance related to this message
         * @return current logger instance
         *-----------------------------------------------*)
        function send(
            const url : string;
            const context : ISerializeable = nil
        ) : IResponse;

    end;

implementation

end.
