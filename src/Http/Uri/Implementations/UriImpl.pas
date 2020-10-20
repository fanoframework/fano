{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UriImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    UriIntf,
    EnvironmentIntf;

type

    (*!------------------------------------------------
     * basic class having capability to retrieve
     * URI from current request
     *
     * @link https://tools.ietf.org/html/rfc3986
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUri = class(TInterfacedObject, IUri)
    private
        fScheme : string;
        fAuthority : string;
        fPathQueryFragment : string;
        fUserInfo : string;
        fHost : string;
        fPort : string;
        fPath : string;
        fQuery : string;
        fFragment : string;

        function getUserInfoFromAuthority(const authority : string) : string;
        function getHostFromAuthority(const authority : string) : string;
        function getPortFromAuthority(const authority : string) : string;
        function getPathFromPathQuery(const pathQuery : string) : string;
    public
        constructor create(const env : ICGIEnvironment);
        constructor create(const url : string);
        function getScheme() : string;
        function getAuthority() : string;
        function getSchemeAuthority() : string;
        function getUserInfo() : string;
        function getHost() : string;
        function getPort() : string;
        function getPath() : string;
        function getQuery() : string;
        function getFragment() : string;
        function serialize() : string;
    end;

implementation

uses

    SysUtils,
    uriparser;

    constructor TUri.create(const env : ICGIEnvironment);
    begin
        fScheme := env.requestScheme();
        fAuthority := env.httpHost();
        fPathQueryFragment := env.requestUri();
        fQuery := env.queryString();
        fUserInfo := getUserInfoFromAuthority(fAuthority);
        fHost := getHostFromAuthority(fAuthority);
        fPort := getPortFromAuthority(fAuthority);
        fPath := getPathFromPathQuery(fPathQueryFragment);
        //server side application will never receive fragment from browser
        //so we just set empty
        fFragment := '';
    end;

    constructor TUri.create(const url : string);
    var uri : uriparser.TURI;
    begin
        uri := parseURI(url);
        fScheme := uri.protocol;
        fHost := uri.host;
        fPort := inttostr(uri.port);
        fQuery := uri.params;
        fFragment := uri.bookmark;

        fUserInfo := '';
        if (uri.username <> '') then
        begin
            fUserInfo := fUserInfo + uri.username;
            if (uri.password <> '') then
            begin
                fUserInfo := fUserInfo + ':' + uri.password;
            end;
        end;

        fAuthority := fUserInfo + fHost;
        if (fPort <> '') then
        begin
            fAuthority := fAuthority + ':' + fPort;
        end;

        fPath := uri.path;
        if (uri.Document <> '') then
        begin
            fPath := fPath + '/' + uri.document;
        end;

        fPathQueryFragment := fPath + fQuery + fFragment;
    end;

    (*!------------------------------------------------
     * get user information part from authority
     *-------------------------------------------------
     * @param authority
     * @return user information or empty string if not found
     *-------------------------------------------------
     * input: authority = 'git@mydomain.com:4000'
     * output: result = 'git'
     *
     * input: authority = 'mydomain.com:4000'
     * output: result = ''
     *-------------------------------------------------*)
    function TUri.getUserInfoFromAuthority(const authority : string) : string;
    var atPos : integer;
    begin
        result := '';
        atPos := pos('@', authority);
        if atPos > 0 then
        begin
            result := copy(authority, 1, atPos - 1);
        end;
    end;

    (*!------------------------------------------------
     * get host part from authority
     *-------------------------------------------------
     * @param authority
     * @return host
     *-------------------------------------------------
     * input: authority = 'git@mydomain.com:4000'
     * output: result = 'mydomain.com'
     *
     * input: authority = 'git@mydomain.com'
     * output: result = 'mydomain.com'
     *
     * input: authority = 'mydomain.com:4000'
     * output: result = 'mydomain.com'
     *
     * input: authority = 'mydomain.com'
     * output: result = 'mydomain.com'
     *-------------------------------------------------*)
    function TUri.getHostFromAuthority(const authority : string) : string;
    var atPos, portPos : integer;
        startHost, countHost : integer;
    begin
        atPos := pos('@', authority);
        startHost := 1;
        if atPos > 0 then
        begin
            startHost := atPos + 1;
        end;

        portPos := pos(':', authority);
        countHost := length(authority);
        if portPos > 0 then
        begin
            countHost := portPos - startHost;
        end;

        result := copy(authority, startHost, countHost);
    end;

    (*!------------------------------------------------
     * get port part from authority
     *-------------------------------------------------
     * @param authority
     * @return port
     *-------------------------------------------------
     * input: authority = 'git@mydomain.com:4000'
     * output: result = '4000'
     *
     * input: authority = 'git@mydomain.com'
     * output: result = ''
     *
     * input: authority = 'mydomain.com:4000'
     * output: result = '400'
     *
     * input: authority = 'mydomain.com'
     * output: result = ''
     *-------------------------------------------------*)
    function TUri.getPortFromAuthority(const authority : string) : string;
    var portPos : integer;
    begin
        result := '';
        portPos := pos(':', authority);
        if portPos > 0 then
        begin
            result := copy(authority, portPos + 1, length(authority) - portPos);
        end;
    end;

    (*!------------------------------------------------
     * get path part from pathquery
     *-------------------------------------------------
     * @param pathquery
     * @return path
     *-------------------------------------------------
     * input: pathquery = '/test?yesy=ds&fds=1'
     * output: result = '/test'
     *
     * input: pathquery = '/?yesy=ds&fds=1'
     * output: result = '/'
     *-------------------------------------------------*)
    function TUri.getPathFromPathQuery(const pathQuery : string) : string;
    var queryPos : integer;
    begin
        result := pathQuery;
        queryPos := pos('?', pathQuery);
        if queryPos > 0 then
        begin
            result := copy(pathQuery, 1, queryPos - 1);
        end;
    end;

    function TUri.getScheme() : string;
    begin
        result := fScheme;
    end;

    function TUri.getAuthority() : string;
    begin
        result := fAuthority;
    end;

    function TUri.getUserInfo() : string;
    begin
        result := fUserInfo;
    end;

    function TUri.getHost() : string;
    begin
        result := fHost;
    end;

    function TUri.getPort() : string;
    begin
        result := fHost;
    end;

    function TUri.getPath() : string;
    begin
        result := fPath;
    end;

    function TUri.getQuery() : string;
    begin
        result := fQuery;
    end;

    function TUri.getFragment() : string;
    begin
        result := fFragment;
    end;

    function TUri.getSchemeAuthority() : string;
    begin
        result := fScheme + '://' + fAuthority;
    end;

    function TUri.serialize() : string;
    begin
        result := getSchemeAuthority() + fPathQueryFragment;
    end;
end.
