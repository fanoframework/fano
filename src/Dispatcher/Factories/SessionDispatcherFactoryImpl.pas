{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SessionDispatcherFactoryImpl;

interface

{$MODE OBJFPC}

uses
    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    RouteMatcherIntf,
    RequestResponseFactoryIntf,
    MiddlewareExecutorIntf,
    MiddlewareLinkListIntf,
    SessionManagerIntf,
    CookieFactoryIntf,
    DispatcherFactoryImpl;

type

    (*!--------------------------------------------------
     * factory class for TDispatcher,
     * route dispatcher implementation which support middleware
     * and session
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TSessionDispatcherFactory = class(TDispatcherFactory)
    private
        fSessionMgr : ISessionManager;
        fCookieFactory : ICookieFactory;
        fExpiresInSec : integer;
    protected
        function createMiddlewareExecutor() : IMiddlewareExecutor; override;
    public
        constructor create (
            const appMiddlewaresInst : IMiddlewareLinkList;
            const routeMatcherInst : IRouteMatcher;
            const requestResponseFactory : IRequestResponseFactory;
            const sessionMgr : ISessionManager;
            const cookieFactory : ICookieFactory;
            const expiresInSec : integer
        );

        destructor destroy(); override;
    end;

implementation

uses

    SessionMiddlewareExecutorImpl;

    constructor TSessionDispatcherFactory.create (
        const appMiddlewaresInst : IMiddlewareLinkList;
        const routeMatcherInst : IRouteMatcher;
        const requestResponseFactory : IRequestResponseFactory;
        const sessionMgr : ISessionManager;
        const cookieFactory : ICookieFactory;
        const expiresInSec : integer
    );
    begin
        inherited create(appMiddlewaresInst, routeMatcherInst, requestResponseFactory);
        fSessionMgr := sessionMgr;
        fCookieFactory := cookieFactory;
        fExpiresInSec := expiresInSec;
    end;

    destructor TSessionDispatcherFactory.destroy();
    begin
        fSessionMgr := nil;
        fCookieFactory := nil;
        inherited destroy();
    end;

    function TSessionDispatcherFactory.createMiddlewareExecutor() : IMiddlewareExecutor;
    var actualFactory : IMiddlewareExecutor;
    begin
        actualFactory := inherited createMiddlewareExecutor();
        result := TSessionMiddlewareExecutor.create(
            actualFactory,
            fSessionMgr,
            fCookieFactory,
            fExpiresInSec
        );
    end;

end.
