{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorEnvironmentImpl;

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
     * base decorator class for any class having capability to retrieve
     * CGI environment variable from external environment class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TDecoratorEnvironment = class(TInjectableObject, ICGIEnvironment, ICGIEnvironmentEnumerator)
    protected
        fDecoratedEnv : ICGIEnvironment;
    public
        constructor create(const aEnv : ICGIEnvironment);
        destructor destroy(); override;

        (*!-----------------------------------------
         * Retrieve an environment variable
         *------------------------------------------
         * @param key name of variable
         * @return variable value
         *------------------------------------------*)
        function env(const keyName : string) : string; virtual;

        {-----------------------------------------
         Retrieve GATEWAY_INTERFACE environment variable
        ------------------------------------------}
        function gatewayInterface() : string; virtual;

        {-----------------------------------------
         Retrieve REMOTE_ADDR environment variable
        ------------------------------------------}
        function remoteAddr() : string; virtual;

        {-----------------------------------------
         Retrieve REMOTE_PORT environment variable
        ------------------------------------------}
        function remotePort() : string; virtual;

        {-----------------------------------------
         Retrieve REMOTE_HOST environment variable
        ------------------------------------------}
        function remoteHost() : string; virtual;

        {-----------------------------------------
         Retrieve REMOTE_USER environment variable
        ------------------------------------------}
        function remoteUser() : string; virtual;

        {-----------------------------------------
         Retrieve REMOTE_IDENT environment variable
        ------------------------------------------}
        function remoteIdent() : string; virtual;

        {-----------------------------------------
         Retrieve AUTH_TYPE environment variable
        ------------------------------------------}
        function authType() : string; virtual;

        {-----------------------------------------
         Retrieve SERVER_ADDR environment variable
        ------------------------------------------}
        function serverAddr() : string; virtual;

        {-----------------------------------------
         Retrieve SERVER_PORT environment variable
        ------------------------------------------}
        function serverPort() : string; virtual;

        {-----------------------------------------
         Retrieve SERVER_NAME environment variable
        ------------------------------------------}
        function serverName() : string; virtual;

        {-----------------------------------------
         Retrieve SERVER_SOFTWARE environment variable
        ------------------------------------------}
        function serverSoftware() : string; virtual;

        {-----------------------------------------
         Retrieve SERVER_PROTOCOL environment variable
        ------------------------------------------}
        function serverProtocol() : string; virtual;

        {-----------------------------------------
         Retrieve DOCUMENT_ROOT environment variable
        ------------------------------------------}
        function documentRoot() : string; virtual;

        {-----------------------------------------
         Retrieve REQUEST_METHOD environment variable
        ------------------------------------------}
        function requestMethod() : string; virtual;

        {-----------------------------------------
         Retrieve REQUEST_SCHEME environment variable
        ------------------------------------------}
        function requestScheme() : string; virtual;

        {-----------------------------------------
         Retrieve REQUEST_URI environment variable
        ------------------------------------------}
        function requestUri() : string; virtual;

        {-----------------------------------------
         Retrieve QUERY_STRING environment variable
        ------------------------------------------}
        function queryString() : string; virtual;

        {-----------------------------------------
         Retrieve SCRIPT_NAME environment variable
        ------------------------------------------}
        function scriptName() : string; virtual;

        {-----------------------------------------
         Retrieve PATH_INFO environment variable
        ------------------------------------------}
        function pathInfo() : string; virtual;

        {-----------------------------------------
         Retrieve PATH_TRANSLATED environment variable
        ------------------------------------------}
        function pathTranslated() : string; virtual;

        {-----------------------------------------
         Retrieve CONTENT_TYPE environment variable
        ------------------------------------------}
        function contentType() : string; virtual;

        {-----------------------------------------
         Retrieve CONTENT_LENGTH environment variable
        ------------------------------------------}
        function contentLength() : string; virtual;

        (*-----------------------------------------
         * Retrieve CONTENT_LENGTH environment variable
         * as integer value
         *------------------------------------------
         * @return content length as integer value
         *------------------------------------------*)
        function intContentLength() : integer; virtual;

        {-----------------------------------------
         Retrieve HTTP_HOST environment variable
        ------------------------------------------}
        function httpHost() : string; virtual;

        {-----------------------------------------
         Retrieve HTTP_USER_AGENT environment variable
        ------------------------------------------}
        function httpUserAgent() : string; virtual;

        {-----------------------------------------
         Retrieve HTTP_ACCEPT environment variable
        ------------------------------------------}
        function httpAccept() : string; virtual;

        {-----------------------------------------
         Retrieve HTTP_ACCEPT_LANGUAGE environment variable
        ------------------------------------------}
        function httpAcceptLanguage() : string; virtual;

        {-----------------------------------------
         Retrieve HTTP_COOKIE environment variable
        ------------------------------------------}
        function httpCookie() : string; virtual;

        (*!------------------------------------------------
         * get number of variables
         *-----------------------------------------------
         * @return number of variables
         *-----------------------------------------------*)
        function count() : integer; virtual;

        (*!------------------------------------------------
         * get key by index
         *-----------------------------------------------
         * @param index index to use
         * @return key name
         *-----------------------------------------------*)
        function getKey(const indx : integer) : shortstring; virtual;

        (*!------------------------------------------------
         * get value by index
         *-----------------------------------------------
         * @param index index to use
         * @return value name
         *-----------------------------------------------*)
        function getValue(const indx : integer) : string; virtual;

        function getEnumerator() : ICGIEnvironmentEnumerator; virtual;
    end;

implementation

    constructor TDecoratorEnvironment.create(const aEnv : ICGIEnvironment);
    begin
        fDecoratedEnv := aEnv;
    end;

    destructor TDecoratorEnvironment.destroy();
    begin
        fDecoratedEnv := nil;
        inherited destroy();
    end;

    (*!-----------------------------------------
     * Retrieve an environment variable
     *------------------------------------------
     * @param key name of variable
     * @return variable value
     *------------------------------------------*)
    function TDecoratorEnvironment.env(const keyName : string) : string;
    begin
        result := fDecoratedEnv.env(keyName);
    end;

    {-----------------------------------------
     Retrieve GATEWAY_INTERFACE environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.gatewayInterface() : string;
    begin
        result := fDecoratedEnv.gatewayInterface();
    end;

    {-----------------------------------------
     Retrieve REMOTE_ADDR environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.remoteAddr() : string;
    begin
        result := fDecoratedEnv.remoteAddr();
    end;

    {-----------------------------------------
     Retrieve REMOTE_PORT environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.remotePort() : string;
    begin
        result := fDecoratedEnv.remotePort();
    end;

    {-----------------------------------------
     Retrieve REMOTE_HOST environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.remoteHost() : string;
    begin
        result := fDecoratedEnv.remoteHost();
    end;

    {-----------------------------------------
     Retrieve REMOTE_USER environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.remoteUser() : string;
    begin
        result := fDecoratedEnv.remoteUser();
    end;

    {-----------------------------------------
     Retrieve REMOTE_IDENT environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.remoteIdent() : string;
    begin
        result := fDecoratedEnv.remoteIdent();
    end;

    {-----------------------------------------
     Retrieve AUTH_TYPE environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.authType() : string;
    begin
        result := fDecoratedEnv.authType();
    end;

    {-----------------------------------------
     Retrieve SERVER_ADDR environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.serverAddr() : string;
    begin
        result := fDecoratedEnv.serverAddr();
    end;

    {-----------------------------------------
     Retrieve SERVER_PORT environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.serverPort() : string;
    begin
        result := fDecoratedEnv.serverPort();
    end;

    {-----------------------------------------
     Retrieve SERVER_NAME environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.serverName() : string;
    begin
        result := fDecoratedEnv.serverName();
    end;

    {-----------------------------------------
     Retrieve SERVER_SOFTWARE environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.serverSoftware() : string;
    begin
        result := fDecoratedEnv.serverSoftware();
    end;

    {-----------------------------------------
     Retrieve SERVER_PROTOCOL environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.serverProtocol() : string;
    begin
        result := fDecoratedEnv.serverProtocol();
    end;

    {-----------------------------------------
     Retrieve DOCUMENT_ROOT environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.documentRoot() : string;
    begin
        result := fDecoratedEnv.documentRoot();
    end;

    {-----------------------------------------
     Retrieve REQUEST_METHOD environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.requestMethod() : string;
    begin
        result := fDecoratedEnv.requestMethod();
    end;

    {-----------------------------------------
     Retrieve REQUEST_SCHEME environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.requestScheme() : string;
    begin
        result := fDecoratedEnv.requestScheme();
    end;

    {-----------------------------------------
     Retrieve REQUEST_URI environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.requestUri() : string;
    begin
        result := fDecoratedEnv.requestUri();
    end;

    {-----------------------------------------
     Retrieve QUERY_STRING environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.queryString() : string;
    begin
        result := fDecoratedEnv.queryString();
    end;

    {-----------------------------------------
     Retrieve SCRIPT_NAME environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.scriptName() : string;
    begin
        result := fDecoratedEnv.scriptName();
    end;

    {-----------------------------------------
     Retrieve PATH_INFO environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.pathInfo() : string;
    begin
        result := fDecoratedEnv.pathInfo();
    end;

    {-----------------------------------------
        Retrieve PATH_TRANSLATED environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.pathTranslated() : string;
    begin
        result := fDecoratedEnv.pathTranslated();
    end;

    {-----------------------------------------
     Retrieve CONTENT_TYPE environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.contentType() : string;
    begin
        result := fDecoratedEnv.contentType();
    end;

    {-----------------------------------------
    Retrieve CONTENT_LENGTH environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.contentLength() : string;
    begin
        result := fDecoratedEnv.contentLength();
    end;

    (*-----------------------------------------
     * Retrieve CONTENT_LENGTH environment variable
     * as integer value
     *------------------------------------------
     * @return content length as integer value
     *------------------------------------------*)
    function TDecoratorEnvironment.intContentLength() : integer;
    begin
        result := fDecoratedEnv.intContentLength();
    end;

    {-----------------------------------------
     Retrieve HTTP_HOST environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.httpHost() : string;
    begin
        result := fDecoratedEnv.httpHost();
    end;

    {-----------------------------------------
     Retrieve HTTP_USER_AGENT environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.httpUserAgent() : string;
    begin
        result := fDecoratedEnv.httpUserAgent();
    end;

    {-----------------------------------------
     Retrieve HTTP_ACCEPT environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.httpAccept() : string;
    begin
        result := fDecoratedEnv.httpAccept();
    end;

    {-----------------------------------------
     Retrieve HTTP_ACCEPT_LANGUAGE environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.httpAcceptLanguage() : string;
    begin
        result := fDecoratedEnv.httpAcceptLanguage();
    end;

    {-----------------------------------------
     Retrieve HTTP_COOKIE environment variable
    ------------------------------------------}
    function TDecoratorEnvironment.httpCookie() : string;
    begin
        result := fDecoratedEnv.httpCookie();
    end;

    (*!------------------------------------------------
     * get value by index
     *-----------------------------------------------
     * @param index index to use
     * @return key name
     *-----------------------------------------------*)
    function TDecoratorEnvironment.getValue(const indx : integer) : string;
    begin
        result := fDecoratedEnv.enumerator.getValue(indx);
    end;

    function TDecoratorEnvironment.getEnumerator() : ICGIEnvironmentEnumerator;
    begin
        result := self;
    end;

    (*!------------------------------------------------
     * get number of variables
     *-----------------------------------------------
     * @return number of variables
     *-----------------------------------------------*)
    function TDecoratorEnvironment.count() : integer;
    begin
        result := fDecoratedEnv.enumerator.count();
    end;

    (*!------------------------------------------------
     * get key by index
     *-----------------------------------------------
     * @param index index to use
     * @return key name
     *-----------------------------------------------*)
    function TDecoratorEnvironment.getKey(const indx : integer) : shortstring;
    begin
        result := fDecoratedEnv.enumerator.getKey(indx);
    end;

end.
