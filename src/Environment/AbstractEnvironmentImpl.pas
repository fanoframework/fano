{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractEnvironmentImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    EnvironmentIntf,
    EnvironmentEnumeratorIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * base class for any class having capability to retrieve
     * CGI environment variable
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TAbstractCGIEnvironment = class(TInjectableObject, ICGIEnvironment, ICGIEnvironmentEnumerator)
    public
        (*!-----------------------------------------
         * Retrieve an environment variable
         *------------------------------------------
         * @param key name of variable
         * @return variable value
         *------------------------------------------*)
        function env(const keyName : string) : string; virtual; abstract;

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

        (*!------------------------------------------------
         * get number of variables
         *-----------------------------------------------
         * @return number of variables
         *-----------------------------------------------*)
        function count() : integer; virtual; abstract;

        (*!------------------------------------------------
         * get key by index
         *-----------------------------------------------
         * @param index index to use
         * @return key name
         *-----------------------------------------------*)
        function getKey(const indx : integer) : shortstring; virtual; abstract;

        (*!------------------------------------------------
         * get value by index
         *-----------------------------------------------
         * @param index index to use
         * @return value name
         *-----------------------------------------------*)
        function getValue(const indx : integer) : string; virtual;

        function getEnumerator() : ICGIEnvironmentEnumerator;
    end;

implementation

uses

    sysutils,
    EInvalidRequestImpl;

resourcestring

    sErrInvalidContentLength = 'Invalid content length';

    {-----------------------------------------
     Retrieve GATEWAY_INTERFACE environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.gatewayInterface() : string;
    begin
        result := env('GATEWAY_INTERFACE');
    end;

    {-----------------------------------------
     Retrieve REMOTE_ADDR environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.remoteAddr() : string;
    begin
        result := env('REMOTE_ADDR');
    end;

    {-----------------------------------------
     Retrieve REMOTE_PORT environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.remotePort() : string;
    begin
        result := env('REMOTE_PORT');
    end;

    {-----------------------------------------
     Retrieve REMOTE_HOST environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.remoteHost() : string;
    begin
        result := env('REMOTE_HOST');
    end;

    {-----------------------------------------
     Retrieve REMOTE_USER environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.remoteUser() : string;
    begin
        result := env('REMOTE_USER');
    end;

    {-----------------------------------------
     Retrieve REMOTE_IDENT environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.remoteIdent() : string;
    begin
        result := env('REMOTE_IDENT');
    end;

    {-----------------------------------------
     Retrieve AUTH_TYPE environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.authType() : string;
    begin
        result := env('AUTH_TYPE');
    end;

    {-----------------------------------------
     Retrieve SERVER_ADDR environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.serverAddr() : string;
    begin
        result := env('SERVER_ADDR');
    end;

    {-----------------------------------------
     Retrieve SERVER_PORT environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.serverPort() : string;
    begin
        result := env('SERVER_PORT');
    end;

    {-----------------------------------------
     Retrieve SERVER_NAME environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.serverName() : string;
    begin
        result := env('SERVER_NAME');
    end;

    {-----------------------------------------
     Retrieve SERVER_SOFTWARE environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.serverSoftware() : string;
    begin
        result := env('SERVER_SOFTWARE');
    end;

    {-----------------------------------------
     Retrieve SERVER_PROTOCOL environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.serverProtocol() : string;
    begin
        result := env('SERVER_PROTOCOL');
    end;

    {-----------------------------------------
     Retrieve DOCUMENT_ROOT environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.documentRoot() : string;
    begin
        result := env('DOCUMENT_ROOT');
    end;

    {-----------------------------------------
     Retrieve REQUEST_METHOD environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.requestMethod() : string;
    begin
        result := env('REQUEST_METHOD');
    end;

    {-----------------------------------------
     Retrieve REQUEST_SCHEME environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.requestScheme() : string;
    begin
        result := env('REQUEST_SCHEME');
    end;

    {-----------------------------------------
     Retrieve REQUEST_URI environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.requestUri() : string;
    begin
        result := env('REQUEST_URI');
    end;

    {-----------------------------------------
     Retrieve QUERY_STRING environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.queryString() : string;
    begin
        result := env('QUERY_STRING');
    end;

    {-----------------------------------------
     Retrieve SCRIPT_NAME environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.scriptName() : string;
    begin
        result := env('SCRIPT_NAME');
    end;

    {-----------------------------------------
     Retrieve PATH_INFO environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.pathInfo() : string;
    begin
        result := env('PATH_INFO');
    end;

    {-----------------------------------------
        Retrieve PATH_TRANSLATED environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.pathTranslated() : string;
    begin
        result := env('PATH_TRANSLATED');
    end;

    {-----------------------------------------
     Retrieve CONTENT_TYPE environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.contentType() : string;
    begin
        result := env('CONTENT_TYPE');
    end;

    {-----------------------------------------
    Retrieve CONTENT_LENGTH environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.contentLength() : string;
    begin
        result := env('CONTENT_LENGTH');
    end;

    (*-----------------------------------------
     * Retrieve CONTENT_LENGTH environment variable
     * as integer value
     *------------------------------------------
     * @return content length as integer value
     *------------------------------------------*)
    function TAbstractCGIEnvironment.intContentLength() : integer;
    begin
        try
            result := strToInt(contentLength());
        except
            on e:EConvertError do
            begin
                raise EInvalidRequest.create(sErrInvalidContentLength);
            end;
        end;
    end;

    {-----------------------------------------
     Retrieve HTTP_HOST environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.httpHost() : string;
    begin
        result := env('HTTP_HOST');
    end;

    {-----------------------------------------
     Retrieve HTTP_USER_AGENT environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.httpUserAgent() : string;
    begin
        result := env('HTTP_USER_AGENT');
    end;

    {-----------------------------------------
     Retrieve HTTP_ACCEPT environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.httpAccept() : string;
    begin
        result := env('HTTP_ACCEPT');
    end;

    {-----------------------------------------
     Retrieve HTTP_ACCEPT_LANGUAGE environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.httpAcceptLanguage() : string;
    begin
        result := env('HTTP_ACCEPT_LANGUAGE');
    end;

    {-----------------------------------------
     Retrieve HTTP_COOKIE environment variable
    ------------------------------------------}
    function TAbstractCGIEnvironment.httpCookie() : string;
    begin
        result := env('HTTP_COOKIE');
    end;

    (*!------------------------------------------------
     * get value by index
     *-----------------------------------------------
     * @param index index to use
     * @return key name
     *-----------------------------------------------*)
    function TAbstractCGIEnvironment.getValue(const indx : integer) : string;
    begin
        result := env(getKey(indx));
    end;

    function TAbstractCGIEnvironment.getEnumerator() : ICGIEnvironmentEnumerator;
    begin
        result := self;
    end;
end.
