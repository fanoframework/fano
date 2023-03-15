{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CacheControlMiddlewareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    MiddlewareIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    HttpCacheIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * middleware class that add Cache-Control (RFC 7234)
     * and also doing conditional GET check, replace response
     * with HTTP 304 if not modified
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCacheControlMiddleware = class(TInjectableObject, IMiddleware)
    private
        fCache : IHttpCache;
        function isCacheable(
            const request : IRequest;
            const response : IResponse
        ) : boolean;

        function isSameETag(
            const request : IRequest;
            const response : IResponse
        ) : boolean;

        function isOlderLastModifiedDate(
            const request : IRequest;
            const response : IResponse
        ) : boolean;
    public
        constructor create(const cache : IHttpCache);
        destructor destroy(); override;

        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const nextMdlwr : IRequestHandler
        ) : IResponse;
    end;

implementation

uses

    httpprotocol,
    md5,
    dateutils,
    HeadersIntf,
    NotModifiedResponseImpl;

const

    HTTP_DATE = 'ddd, dd mmm yyyy hh:mm:ss';

    constructor TCacheControlMiddleware.create(const cache : IHttpCache);
    begin
        fCache := cache;
    end;

    destructor TCacheControlMiddleware.destroy();
    begin
        fCache := nil;
        inherited destroy();
    end;

    function TCacheControlMiddleware.isCacheable(
        const request : IRequest;
        const response : IResponse
    ) : boolean;
    begin
        result := ((request.method = 'GET') or (request.method ='HEAD')) and
            (response.body().size() > 0);
    end;

    function TCacheControlMiddleware.isSameETag(
        const request : IRequest;
        const response : IResponse
    ) : boolean;
    var svrETag : string;
        clientEtag : string;
    begin
        result := false;
        svrETag := '';
        if request.headers.has(HeaderIfNoneMatch) then
        begin
            clientETag := request.headers[HeaderIfNoneMatch];
            if clientETag = '"*"' then
            begin
                result := true;
            end else
            begin
                if response.headers.has(HeaderETag) then
                begin
                    svrETag := response.headers[HeaderETag];
                end else if (fCache.useETag) then
                begin
                    svrETag := MD5Print(MD5String(response.body().read()));
                    response.headers.addHeader(HeaderETag, '"' + svrETag + '"');
                end;
                //If-None-match value an be multiple values such as
                //If-None-Match : "value1","value2"
                result := pos(svrETag, clientETag) > 0;
            end;
        end;
        if (svrETag = '') and (fCache.useETag) then
        begin
            svrETag := MD5Print(MD5String(response.body().read()));
            response.headers.addHeader(HeaderETag, '"' + svrETag + '"');
        end;
    end;

    function TCacheControlMiddleware.isOlderLastModifiedDate(
        const request : IRequest;
        const response : IResponse
    ) : boolean;
    var lastModified, ifModifiedSince : TDateTime;
    begin
        result := false;
        if response.headers.has(HeaderLastModified) then
        begin
            if (request.headers.has(HeaderIfModifiedSince)) then
            begin
                lastModified := scanDateTime(
                    HTTP_DATE,
                    response.headers[HeaderLastModified]
                );
                ifModifiedSince := scanDateTime(
                    HTTP_DATE,
                    request.headers[HeaderIfModifiedSince]
                );
                result := (ifModifiedSince >= lastModified);
            end;
        end;
    end;

    function TCacheControlMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const nextMdlwr : IRequestHandler
    ) : IResponse;
    var notModified : boolean;
    begin
        result := nextMdlwr.handleRequest(request, response, args);
        if isCacheable(request, result) then
        begin
            if not result.headers.has(HeaderCacheControl) then
            begin
                result.headers.addHeaderLine(fCache.serialize());
            end;

            notModified := isSameETag(request, result) or
                isOlderLastModifiedDate(request, result);

            if notModified then
            begin
                result := TNotModifiedResponse.create(result.headers.clone() as IHeaders);
            end;
        end;
    end;
end.
