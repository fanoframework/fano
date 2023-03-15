{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SessionMiddlewareExecutorImpl;

interface

{$MODE OBJFPC}

uses

    RequestIntf,
    ResponseIntf,
    RouteHandlerIntf,
    SessionManagerIntf,
    CookieFactoryIntf,
    SessionIntf,
    MiddlewareExecutorIntf;

type

    (*!------------------------------------------------
     * decorator middleware executor that support session
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSessionMiddlewareExecutor = class(TInterfacedObject, IMiddlewareExecutor)
    private
        fActualMiddlewareExecutor : IMiddlewareExecutor;
        fSessionMgr : ISessionManager;
        fCookieFactory : ICookieFactory;
        fExpiresInSec : integer;

        function addCookieHeader(
            const resp : IResponse;
            const sess : ISession;
            const cookieFactory : ICookieFactory
        ) : IResponse;

        function executeAndAddCookie(
            const request : IRequest;
            const response : IResponse;
            const routeHandler : IRouteHandler;
            sess : ISession
        ) : IResponse;

    public
        constructor create(
            const actualMiddlewareExecutor : IMiddlewareExecutor;
            const sessionMgr : ISessionManager;
            const cookieFactory : ICookieFactory;
            const expireInSec : integer
        );
        destructor destroy(); override;

        function execute(
            const request : IRequest;
            const response : IResponse;
            const routeHandler : IRouteHandler
        ) : IResponse;
    end;

implementation

uses

    CookieIntf,
    ESessionInvalidImpl,
    ESessionExpiredImpl;

    constructor TSessionMiddlewareExecutor.create(
        const actualMiddlewareExecutor : IMiddlewareExecutor;
        const sessionMgr : ISessionManager;
        const cookieFactory : ICookieFactory;
        const expireInSec : integer
    );
    begin
        inherited create();
        fActualMiddlewareExecutor := actualMiddlewareExecutor;
        fSessionMgr := sessionMgr;
        fCookieFactory := cookieFactory;
        fExpiresInSec := expireInSec;
    end;

    destructor TSessionMiddlewareExecutor.destroy();
    begin
        fActualMiddlewareExecutor := nil;
        fSessionMgr := nil;
        fCookieFactory := nil;
        inherited destroy();
    end;

    function TSessionMiddlewareExecutor.addCookieHeader(
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

    function TSessionMiddlewareExecutor.executeAndAddCookie(
        const request : IRequest;
        const response : IResponse;
        const routeHandler : IRouteHandler;
        sess : ISession
    ) : IResponse;
    var newResp : IResponse;
    begin
        newResp := fActualMiddlewareExecutor.execute(
            request,
            response,
            routeHandler
        );
        try
            result := addCookieHeader(newResp, sess, fCookieFactory);
        finally
            newResp := nil;
        end;
    end;

    function TSessionMiddlewareExecutor.execute(
        const request : IRequest;
        const response : IResponse;
        const routeHandler : IRouteHandler
    ) : IResponse;
    var sess : ISession;
    begin
        sess := fSessionMgr.beginSession(request, fExpiresInSec);
        try
            result := executeAndAddCookie(request, response, routeHandler, sess);
        finally
            fSessionMgr.endSession(sess);
            sess := nil;
        end;
    end;
end.
