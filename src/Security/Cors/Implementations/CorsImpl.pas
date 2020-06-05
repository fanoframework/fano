{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CorsImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    CorsIntf,
    CorsConfigIntf,
    HeadersIntf,
    RegexIntf;

type

    (*!------------------------------------------------
     * basic class having capability to
     * handle CORS request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCors = class(TInterfacedObject, ICors)
    private
        fConfig : ICorsConfig;
        fRegex : IRegex;

        (*!------------------------------------------------
         * test of current request is in same host
         *-------------------------------------------------
         * @param requestHeaders request header
         * @return true if request is same host
         *-------------------------------------------------*)
        function isSameHost(const request : IRequest) : boolean;

        function isOriginAllowed(const request : IRequest) : boolean;
        function isMethodAllowed(const request : IRequest) : boolean;
        function isHeaderAllowed(const request : IRequest) : boolean;
    public
        constructor create(const config : ICorsConfig; const regex : IRegex);
        destructor destroy(); override;

        (*!------------------------------------------------
         * test of current request is allowed
         *-------------------------------------------------
         * @param request current request
         * @return true if request is allowed
         *-------------------------------------------------*)
        function isAllowed(const request : IRequest) : boolean;

        (*!------------------------------------------------
         * test of current request is CORS request
         *-------------------------------------------------
         * @param request current request
         * @return true if request is CORS request
         *-------------------------------------------------*)
        function isCorsRequest(const request : IRequest) : boolean;

        (*!------------------------------------------------
         * test of current request is preflight request
         *-------------------------------------------------
         * @param request current request
         * @return true if request is preflight request
         *-------------------------------------------------*)
        function isPreflightRequest(const request : IRequest) : boolean;

        (*!------------------------------------------------
         * handle prefight request
         *-------------------------------------------------
         * @param response current response object
         * @param request current request object
         * @return response
         *-------------------------------------------------*)
        function handlePreflightRequest(
            const request : IRequest;
            const response : IResponse
        ) : IResponse;

        (*!------------------------------------------------
         * add CORS header to response headers
         *-------------------------------------------------
         * @param request current request
         * @param response current response
         * @return response with added header
         *-------------------------------------------------*)
        function addCorsResponseHeaders(
            const request : IRequest;
            const response : IResponse
        ) : IResponse;
    end;

implementation

uses

    SysUtils,
    StrUtils,
    HttpCodeResponseImpl;

    constructor TCors.create(const config : ICorsConfig; const regex : IRegex);
    begin
        fConfig := config;
        fRegex := regex;
    end;

    destructor TCors.destroy();
    begin
        fConfig := nil;
        fRegex := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * test of current request origin is allowed
     *-------------------------------------------------
     * @param request current request
     * @return true if request is allowed
     *-------------------------------------------------*)
    function TCors.isOriginAllowed(const request : IRequest) : boolean;
    var origin : string;
        i, len : integer;
        matchRes : TRegexMatchResult;
    begin
        result := false;

        if (ansiMatchStr('*', fConfig.allowedOrigins)) then
        begin
            result := true;
        end;

        origin := request.headers().getHeader('Origin');
        if (ansiMatchStr(origin, fConfig.allowedOrigins)) then
        begin
            result := true;
        end;

        len := length(fConfig.allowedOriginsPatterns);
        for i:= 0 to len - 1 do
        begin
            matchRes := fRegex.match(fConfig.allowedOriginsPatterns[i], origin);
            if (matchRes.matched) then
            begin
                result := true;
                break;
            end;
        end;
    end;

    (*!------------------------------------------------
     * test of current request method is allowed
     *-------------------------------------------------
     * @param request current request
     * @return true if request is allowed
     *-------------------------------------------------*)
    function TCors.isMethodAllowed(const request : IRequest) : boolean;
    var method : string;
    begin
        result := false;

        if (ansiMatchStr('*', fConfig.allowedMethods)) then
        begin
            result := true;
            exit;
        end;

        method := request.headers().getHeader('Access-Control-Request-Method');
        if (ansiMatchStr(upperCase(method), fConfig.allowedMethods)) then
        begin
            result := true;
        end;
    end;

    (*!------------------------------------------------
     * test of current request header is allowed
     *-------------------------------------------------
     * @param request current request
     * @return true if request header is allowed
     *-------------------------------------------------*)
    function TCors.isHeaderAllowed(const request : IRequest) : boolean;
    var header : string;
        i, len : integer;
        headers : TStringArray;
    begin
        result := false;

        if (ansiMatchStr('*', fConfig.allowedHeaders)) then
        begin
            result := true;
            exit;
        end;

        if (request.headers().has('Access-Control-Request-Headers')) then
        begin
            header := request.headers().getHeader('Access-Control-Request-Headers');
            headers := header.split([',']);
            len := length(headers);
            result := true;
            for i:= 0 to len-1 do
            begin
                if not ansiMatchStr(lowercase(trim(headers[i])), fConfig.allowedHeaders) then
                begin
                    result := false;
                    break;
                end;
            end;
        end;
    end;

    (*!------------------------------------------------
     * test of current request is allowed
     *-------------------------------------------------
     * @param request current request
     * @return true if request is allowed
     *-------------------------------------------------*)
    function TCors.isAllowed(const request : IRequest) : boolean;
    begin
        result := isOriginAllowed(request);
    end;

    (*!------------------------------------------------
     * test of current request is in same host
     *-------------------------------------------------
     * @param requestHeaders request header
     * @return true if request is same host
     *-------------------------------------------------*)
    function TCors.isSameHost(const request : IRequest) : boolean;
    var origin, schemeAndHost : string;
    begin
        origin := request.headers().getHeader('Origin');
        schemeAndHost := request.uri().schemeAuthority;
        result := (origin = schemeAndHost);
    end;

    (*!------------------------------------------------
     * test of current request is CORS request
     *-------------------------------------------------
     * @param requestHeaders request
     * @return true if request is CORS request
     *-------------------------------------------------*)
    function TCors.isCorsRequest(const request : IRequest) : boolean;
    begin
        result := request.headers().has('Origin') and (not isSameHost(request));
    end;

    (*!------------------------------------------------
     * test of current request is preflight request
     *-------------------------------------------------
     * @param requestHeaders request header
     * @return true if request is preflight request
     *-------------------------------------------------*)
    function TCors.isPreflightRequest(const request : IRequest) : boolean;
    begin
        result := isCorsRequest(request) and
            (request.method = 'OPTIONS') and
            request.headers().has('Access-Control-Request-Method');
    end;

    (*!------------------------------------------------
     * handle prefight request
     *-------------------------------------------------
     * @param response current response object
     * @param request current request object
     * @return response
     *-------------------------------------------------*)
    function TCors.handlePreflightRequest(
        const request : IRequest;
        const response : IResponse
    ) : IResponse;
    var respHeaders : IHeaders;
        str : string;
    begin
        if (not isOriginAllowed(request)) then
        begin
            result := THttpCodeResponse.create(403, 'Origin not allowed', response.headers());
            exit;
        end;

        if (not isMethodAllowed(request)) then
        begin
            result := THttpCodeResponse.create(405, 'Method not allowed', response.headers());
            exit;
        end;

        if (not isHeaderAllowed(request)) then
        begin
            result := THttpCodeResponse.create(403, 'Header not allowed', response.headers());
            exit;
        end;

        respHeaders := response.headers();
        respHeaders.setHeader(
            'Access-Control-Allow-Origin',
            request.headers().getHeader('Origin')
        );

        if (fConfig.supportsCredentials) then
        begin
            respHeaders.setHeader('Access-Control-Allow-Credentials', 'true');
        end;

        if (fConfig.maxAge > 0) then
        begin
            respHeaders.setHeader('Access-Control-Max-Age', intToStr(fConfig.maxAge));
        end;

        if (ansiMatchStr('*', fConfig.allowedMethods)) then
        begin
            str := request.headers().getHeader('Access-Control-Request-Method');
            respHeaders.setHeader('Access-Control-Allow-Methods', uppercase(str));
        end else
        begin
            if (length(fConfig.allowedMethods) > 0) then
            begin
                str:= ''.join(', ', fConfig.allowedMethods);
                respHeaders.setHeader('Access-Control-Allow-Methods', str);
            end;
        end;

        if (ansiMatchStr('*', fConfig.allowedHeaders)) then
        begin
            str := request.headers().getHeader('Access-Control-Request-Headers');
            respHeaders.setHeader('Access-Control-Allow-Headers', uppercase(str));
        end else
        begin
            if (length(fConfig.allowedHeaders) > 0) then
            begin
                str := ''.join(', ', fConfig.allowedHeaders);
                respHeaders.setHeader('Access-Control-Allow-Headers', str);
            end;
        end;

        result := response;
    end;

    (*!------------------------------------------------
     * add CORS header to response headers
     *-------------------------------------------------
     * @param request current request
     * @param response current response
     * @return response with added header
     *-------------------------------------------------*)
    function TCors.addCorsResponseHeaders(
        const request : IRequest;
        const response : IResponse
    ) : IResponse;
    var respHeaders : IHeaders;
        str : string;
    begin
        respHeaders := response.headers();
        respHeaders.setHeader(
            'Access-Control-Allow-Origin',
            request.headers().getHeader('Origin')
        );
        if (not respHeaders.has('Vary')) then
        begin
            respHeaders.setHeader('Vary', 'Origin');
        end else
        begin
            respHeaders.setHeader('Vary', respHeaders.getHeader('Vary') + ', Origin');
        end;

        if (fConfig.supportsCredentials) then
        begin
            respHeaders.setHeader('Access-Control-Allow-Credentials', 'true');
        end;

        if (length(fConfig.exposedHeaders) > 0) then
        begin
            str := ''.join(', ', fConfig.exposedHeaders);
            respHeaders.setHeader('Access-Control-Expose-Headers', str);
        end;

        result := response;
    end;

end.
