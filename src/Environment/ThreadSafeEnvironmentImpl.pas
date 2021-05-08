{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeEnvironmentImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    EnvironmentIntf,
    EnvironmentEnumeratorIntf,
    DecoratorEnvironmentImpl;

type

    (*!------------------------------------------------
     * thread-safe decorator ICGIEnvironment class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TThreadSafeEnvironment = class(TDecoratorEnvironment)
    private
        fCriticalSection : TCriticalSection;
    public
        constructor create(const aEnv : ICGIEnvironment);
        destructor destroy(); override;

        (*!-----------------------------------------
         * Retrieve an environment variable
         *------------------------------------------
         * @param key name of variable
         * @return variable value
         *------------------------------------------*)
        function env(const keyName : string) : string; override;

        {-----------------------------------------
         Retrieve GATEWAY_INTERFACE environment variable
        ------------------------------------------}
        function gatewayInterface() : string; override;

        {-----------------------------------------
         Retrieve REMOTE_ADDR environment variable
        ------------------------------------------}
        function remoteAddr() : string; override;

        {-----------------------------------------
         Retrieve REMOTE_PORT environment variable
        ------------------------------------------}
        function remotePort() : string; override;

        {-----------------------------------------
         Retrieve REMOTE_HOST environment variable
        ------------------------------------------}
        function remoteHost() : string; override;

        {-----------------------------------------
         Retrieve REMOTE_USER environment variable
        ------------------------------------------}
        function remoteUser() : string; override;

        {-----------------------------------------
         Retrieve REMOTE_IDENT environment variable
        ------------------------------------------}
        function remoteIdent() : string; override;

        {-----------------------------------------
         Retrieve AUTH_TYPE environment variable
        ------------------------------------------}
        function authType() : string; override;

        {-----------------------------------------
         Retrieve SERVER_ADDR environment variable
        ------------------------------------------}
        function serverAddr() : string; override;

        {-----------------------------------------
         Retrieve SERVER_PORT environment variable
        ------------------------------------------}
        function serverPort() : string; override;

        {-----------------------------------------
         Retrieve SERVER_NAME environment variable
        ------------------------------------------}
        function serverName() : string; override;

        {-----------------------------------------
         Retrieve SERVER_SOFTWARE environment variable
        ------------------------------------------}
        function serverSoftware() : string; override;

        {-----------------------------------------
         Retrieve SERVER_PROTOCOL environment variable
        ------------------------------------------}
        function serverProtocol() : string; override;

        {-----------------------------------------
         Retrieve DOCUMENT_ROOT environment variable
        ------------------------------------------}
        function documentRoot() : string; override;

        {-----------------------------------------
         Retrieve REQUEST_METHOD environment variable
        ------------------------------------------}
        function requestMethod() : string; override;

        {-----------------------------------------
         Retrieve REQUEST_SCHEME environment variable
        ------------------------------------------}
        function requestScheme() : string; override;

        {-----------------------------------------
         Retrieve REQUEST_URI environment variable
        ------------------------------------------}
        function requestUri() : string; override;

        {-----------------------------------------
         Retrieve QUERY_STRING environment variable
        ------------------------------------------}
        function queryString() : string; override;

        {-----------------------------------------
         Retrieve SCRIPT_NAME environment variable
        ------------------------------------------}
        function scriptName() : string; override;

        {-----------------------------------------
         Retrieve PATH_INFO environment variable
        ------------------------------------------}
        function pathInfo() : string; override;

        {-----------------------------------------
         Retrieve PATH_TRANSLATED environment variable
        ------------------------------------------}
        function pathTranslated() : string; override;

        {-----------------------------------------
         Retrieve CONTENT_TYPE environment variable
        ------------------------------------------}
        function contentType() : string; override;

        {-----------------------------------------
         Retrieve CONTENT_LENGTH environment variable
        ------------------------------------------}
        function contentLength() : string; override;

        (*-----------------------------------------
         * Retrieve CONTENT_LENGTH environment variable
         * as integer value
         *------------------------------------------
         * @return content length as integer value
         *------------------------------------------*)
        function intContentLength() : integer; override;

        {-----------------------------------------
         Retrieve HTTP_HOST environment variable
        ------------------------------------------}
        function httpHost() : string; override;

        {-----------------------------------------
         Retrieve HTTP_USER_AGENT environment variable
        ------------------------------------------}
        function httpUserAgent() : string; override;

        {-----------------------------------------
         Retrieve HTTP_ACCEPT environment variable
        ------------------------------------------}
        function httpAccept() : string; override;

        {-----------------------------------------
         Retrieve HTTP_ACCEPT_LANGUAGE environment variable
        ------------------------------------------}
        function httpAcceptLanguage() : string; override;

        {-----------------------------------------
         Retrieve HTTP_COOKIE environment variable
        ------------------------------------------}
        function httpCookie() : string; override;

        (*!------------------------------------------------
         * get number of variables
         *-----------------------------------------------
         * @return number of variables
         *-----------------------------------------------*)
        function count() : integer; override;

        (*!------------------------------------------------
         * get key by index
         *-----------------------------------------------
         * @param index index to use
         * @return key name
         *-----------------------------------------------*)
        function getKey(const indx : integer) : shortstring; override;

        (*!------------------------------------------------
         * get value by index
         *-----------------------------------------------
         * @param index index to use
         * @return value name
         *-----------------------------------------------*)
        function getValue(const indx : integer) : string; override;
    end;

implementation

    constructor TThreadSafeEnvironment.create(const aEnv : ICGIEnvironment);
    begin
        inherited create(aEnv);
        fCriticalSection := TCriticalSection.create();
    end;

    destructor TThreadSafeEnvironment.destroy();
    begin
        fCriticalSection.free();
        inherited destroy();
    end;

    (*!-----------------------------------------
     * Retrieve an environment variable
     *------------------------------------------
     * @param key name of variable
     * @return variable value
     *------------------------------------------*)
    function TThreadSafeEnvironment.env(const keyName : string) : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited env(keyName);
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve GATEWAY_INTERFACE environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.gatewayInterface() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited gatewayInterface();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve REMOTE_ADDR environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.remoteAddr() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited remoteAddr();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve REMOTE_PORT environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.remotePort() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited remotePort();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve REMOTE_HOST environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.remoteHost() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited remoteHost();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve REMOTE_USER environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.remoteUser() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited remoteUser();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve REMOTE_IDENT environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.remoteIdent() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited remoteIdent();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve AUTH_TYPE environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.authType() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited authType();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve SERVER_ADDR environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.serverAddr() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited serverAddr();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve SERVER_PORT environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.serverPort() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited serverPort();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve SERVER_NAME environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.serverName() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited serverName();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve SERVER_SOFTWARE environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.serverSoftware() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited serverSoftware();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve SERVER_PROTOCOL environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.serverProtocol() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited serverProtocol();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve DOCUMENT_ROOT environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.documentRoot() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited documentRoot();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve REQUEST_METHOD environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.requestMethod() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited requestMethod();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve REQUEST_SCHEME environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.requestScheme() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited requestScheme();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve REQUEST_URI environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.requestUri() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited requestUri();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve QUERY_STRING environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.queryString() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited queryString();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve SCRIPT_NAME environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.scriptName() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited scriptName();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve PATH_INFO environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.pathInfo() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited pathInfo();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
        Retrieve PATH_TRANSLATED environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.pathTranslated() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited pathTranslated();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve CONTENT_TYPE environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.contentType() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited contentType();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
    Retrieve CONTENT_LENGTH environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.contentLength() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited contentLength();
        finally
            fCriticalSection.release();
        end;
    end;

    (*-----------------------------------------
     * Retrieve CONTENT_LENGTH environment variable
     * as integer value
     *------------------------------------------
     * @return content length as integer value
     *------------------------------------------*)
    function TThreadSafeEnvironment.intContentLength() : integer;
    begin
        fCriticalSection.acquire();
        try
            result := inherited intContentLength();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve HTTP_HOST environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.httpHost() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited httpHost();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve HTTP_USER_AGENT environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.httpUserAgent() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited httpUserAgent();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve HTTP_ACCEPT environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.httpAccept() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited httpAccept();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve HTTP_ACCEPT_LANGUAGE environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.httpAcceptLanguage() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited httpAcceptLanguage();
        finally
            fCriticalSection.release();
        end;
    end;

    {-----------------------------------------
     Retrieve HTTP_COOKIE environment variable
    ------------------------------------------}
    function TThreadSafeEnvironment.httpCookie() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited httpCookie();
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------------
     * get value by index
     *-----------------------------------------------
     * @param index index to use
     * @return key name
     *-----------------------------------------------*)
    function TThreadSafeEnvironment.getValue(const indx : integer) : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited getValue(indx);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------------
     * get number of variables
     *-----------------------------------------------
     * @return number of variables
     *-----------------------------------------------*)
    function TThreadSafeEnvironment.count() : integer;
    begin
        fCriticalSection.acquire();
        try
            result := inherited count();
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------------
     * get key by index
     *-----------------------------------------------
     * @param index index to use
     * @return key name
     *-----------------------------------------------*)
    function TThreadSafeEnvironment.getKey(const indx : integer) : shortstring;
    begin
        fCriticalSection.acquire();
        try
            result := inherited getKey(indx);
        finally
            fCriticalSection.release();
        end;
    end;

end.
