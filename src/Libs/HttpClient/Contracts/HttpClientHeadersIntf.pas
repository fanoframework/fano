{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpClientHeadersIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to set
     * HTTP headers
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IHttpClientHeaders = interface
        ['{23EE22AE-7A81-49F9-876F-5B35DD0862B0}']

        (*!------------------------------------------------
         *  add header
         *-----------------------------------------------
         * @param aheader string contain header name
         * @param avalue string contain header value
         * @return current instance
         *-----------------------------------------------*)
        function add(const aheader : string; const avalue : string) : IHttpClientHeaders;

        (*!------------------------------------------------
         *  apply added header
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function apply() : IHttpClientHeaders;
    end;

implementation

end.
