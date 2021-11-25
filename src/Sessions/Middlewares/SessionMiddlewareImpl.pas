{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SessionMiddlewareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    MiddlewareIntf,
    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    SessionManagerIntf,
    CookieIntf,
    CookieFactoryIntf,
    SessionIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------------
     * Middleware that setup session. This is provided so
     * session can be initiated based on routes. For example
     * when certain routes need session but others does not need
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *------------------------------------------------------*)
    TSessionMiddleware = class(TInjectableObject, IMiddleware)
    private
        fSessionMgr : ISessionManager;
        fCookieFactory : ICookieFactory;
        fExpiresInSec : integer;

        function addCookieHeader(
            const resp : IResponse;
            const sess : ISession;
            const cookieFactory : ICookieFactory
        ) : IResponse;

    public
        constructor create(
            const sessionMgr : ISessionManager;
            const cookieFactory : ICookieFactory;
            const expireInSec : integer
        );

        (*!-------------------------------------------
         * handle request
         *--------------------------------------------
         * @param request object represent current request
         * @param response object represent current response
         * @param args object represent current route arguments
         * @param next next middleware
         * @return new response
         *--------------------------------------------*)
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;
    end;

implementation


    constructor TSessionMiddleware.create(
        const sessionMgr : ISessionManager;
        const cookieFactory : ICookieFactory;
        const expireInSec : integer
    );
    begin
        fSessionMgr := sessionMgr;
        fCookieFactory := cookieFactory;
        fExpiresInSec := expireInSec;
    end;

    function TSessionMiddleware.addCookieHeader(
        const resp : IResponse;
        const sess : ISession;
        const cookieFactory : ICookieFactory
    ) : IResponse;
    var cookie : ICookie;
    begin
        cookie := cookieFactory.name(sess.name()).value(sess.id()).build();
        try
            resp.headers().addHeader('Set-Cookie', cookie.serialize());
            result := resp;
        finally
            cookie := nil;
        end;
    end;

    (*!-------------------------------------------
     * handle request
     *--------------------------------------------
     * @param request object represent current request
     * @param response object represent current response
     * @param args object represent current route arguments
     * @param next next middleware
     * @return new response
     *--------------------------------------------*)
    function TSessionMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    var sess : ISession;
    begin
        sess := fSessionMgr.beginSession(request, fExpiresInSec);
        try
            result := next.handleRequest(request, response, args);
            result := addCookieHeader(result, sess, fCookieFactory);
        finally
            fSessionMgr.endSession(sess);
            sess := nil;
        end;
    end;
end.
