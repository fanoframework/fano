{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EnvironmentIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    EnvironmentEnumeratorIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to retrieve
     * CGI environment variable
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ICGIEnvironment = interface
        ['{48E2E809-1176-4863-B940-D1E05CF1355C}']

        {-----------------------------------------
         Retrieve an environment variable
        ------------------------------------------}
        function env(const keyName : string) : string;

        {-----------------------------------------
         Retrieve GATEWAY_INTERFACE environment variable
        ------------------------------------------}
        function gatewayInterface() : string;

        {-----------------------------------------
         Retrieve REMOTE_ADDR environment variable
        ------------------------------------------}
        function remoteAddr() : string;

        {-----------------------------------------
         Retrieve REMOTE_PORT environment variable
        ------------------------------------------}
        function remotePort() : string;

        {-----------------------------------------
         Retrieve REMOTE_HOST environment variable
        ------------------------------------------}
        function remoteHost() : string;

        {-----------------------------------------
         Retrieve REMOTE_USER environment variable
        ------------------------------------------}
        function remoteUser() : string;

        {-----------------------------------------
         Retrieve REMOTE_IDENT environment variable
        ------------------------------------------}
        function remoteIdent() : string;

        {-----------------------------------------
         Retrieve AUTH_TYPE environment variable
        ------------------------------------------}
        function authType() : string;

        {-----------------------------------------
         Retrieve SERVER_ADDR environment variable
        ------------------------------------------}
        function serverAddr() : string;

        {-----------------------------------------
         Retrieve SERVER_PORT environment variable
        ------------------------------------------}
        function serverPort() : string;

        {-----------------------------------------
         Retrieve SERVER_NAME environment variable
        ------------------------------------------}
        function serverName() : string;

        {-----------------------------------------
         Retrieve SERVER_SOFTWARE environment variable
        ------------------------------------------}
        function serverSoftware() : string;

        {-----------------------------------------
         Retrieve SERVER_PROTOCOL environment variable
        ------------------------------------------}
        function serverProtocol() : string;

        {-----------------------------------------
         Retrieve DOCUMENT_ROOT environment variable
        ------------------------------------------}
        function documentRoot() : string;

        {-----------------------------------------
         Retrieve REQUEST_METHOD environment variable
        ------------------------------------------}
        function requestMethod() : string;

        {-----------------------------------------
         Retrieve REQUEST_SCHEME environment variable
        ------------------------------------------}
        function requestScheme() : string;

        {-----------------------------------------
         Retrieve REQUEST_URI environment variable
        ------------------------------------------}
        function requestUri() : string;

        {-----------------------------------------
         Retrieve QUERY_STRING environment variable
        ------------------------------------------}
        function queryString() : string;

        {-----------------------------------------
         Retrieve SCRIPT_NAME environment variable
        ------------------------------------------}
        function scriptName() : string;

        {-----------------------------------------
         Retrieve PATH_INFO environment variable
        ------------------------------------------}
        function pathInfo() : string;

        {-----------------------------------------
         Retrieve PATH_TRANSLATED environment variable
        ------------------------------------------}
        function pathTranslated() : string;

        {-----------------------------------------
         Retrieve CONTENT_TYPE environment variable
        ------------------------------------------}
        function contentType() : string;

        {-----------------------------------------
         Retrieve CONTENT_LENGTH environment variable
        ------------------------------------------}
        function contentLength() : string;

        (*-----------------------------------------
         * Retrieve CONTENT_LENGTH environment variable
         * as integer value
         *------------------------------------------
         * @return content length as integer value
         *------------------------------------------*)
        function intContentLength() : integer;

        {-----------------------------------------
         Retrieve HTTP_HOST environment variable
        ------------------------------------------}
        function httpHost() : string;

        {-----------------------------------------
         Retrieve HTTP_USER_AGENT environment variable
        ------------------------------------------}
        function httpUserAgent() : string;

        {-----------------------------------------
         Retrieve HTTP_ACCEPT environment variable
        ------------------------------------------}
        function httpAccept() : string;

        {-----------------------------------------
         Retrieve HTTP_ACCEPT_LANGUAGE environment variable
        ------------------------------------------}
        function httpAcceptLanguage() : string;

        {-----------------------------------------
         Retrieve HTTP_COOKIE environment variable
        ------------------------------------------}
        function httpCookie() : string;

        function getEnumerator() : ICGIEnvironmentEnumerator;

        property vars[const keyName : string] : string read env; default;
        property enumerator : ICGIEnvironmentEnumerator read getEnumerator;
    end;

implementation
end.
