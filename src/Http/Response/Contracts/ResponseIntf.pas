{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ResponseIntf;

interface

{$MODE OBJFPC}

uses

    HeadersIntf,
    ResponseStreamIntf,
    CloneableIntf;

type

    (*!----------------------------------------------
     * interface for any class having capability as
     * HTTP response
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IResponse = interface(ICloneable)
        ['{36D6274C-3EE1-4262-BACB-2A313C673206}']

        (*!------------------------------------
         * get http headers instance
         *-------------------------------------
         * @return header instance
         *-------------------------------------*)
        function headers() : IHeaders;

        (*!------------------------------------
         * output http response to STDOUT
         *-------------------------------------
         * @return current instance
         *-------------------------------------*)
        function write() : IResponse;

        (*!------------------------------------
         * get response body
         *-------------------------------------
         * @return response body
         *-------------------------------------*)
        function body() : IResponseStream;

        (*!------------------------------------
         * set new response body
         *-------------------------------------
         * @return response body
         *-------------------------------------*)
        function setBody(const newBody : IResponseStream) : IResponse;
    end;

implementation
end.
