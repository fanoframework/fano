{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SessionMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    SessionManagerIntf,
    CookieFactoryIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TSessionMiddleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TSessionMiddlewareFactory = class(TFactory, IDependencyFactory)
    private
        fSessionMgr : ISessionManager;
        fCookieFactory : ICookieFactory;
        fExpiresInSec : integer;
    public
        constructor create(const aSessionMgr : ISessionManager);

        function expiresInSec(const aExpiresInSec : integer) : TSessionMiddlewareFactory;
        function cookieFactory(const aCookieFactory : ICookieFactory) : TSessionMiddlewareFactory;

        (*!---------------------------------------
         * build middleware instance
         *----------------------------------------
         * @param container dependency container
         * @return instance of middleware
         *----------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    SysUtils,
    JsonFileSessionManagerFactoryImpl,
    CookieFactoryImpl,
    SessionMiddlewareImpl;

const

    EXPIRES_30_MIN = 30 * 60;

    constructor TSessionMiddlewareFactory.create(const aSessionMgr : ISessionManager);
    begin
        fSessionMgr := aSessionMgr;

        if fSessionMgr = nil then
        begin
            raise EArgumentNilException.create('Session manager can not be nil');
        end;

        fCookieFactory := nil;
        fExpiresInSec := EXPIRES_30_MIN;
    end;

    function TSessionMiddlewareFactory.expiresInSec(
        const aExpiresInSec : integer
    ) : TSessionMiddlewareFactory;
    begin
        fExpiresInSec := aExpiresInSec;
        result := self;
    end;

    function TSessionMiddlewareFactory.cookieFactory(
        const aCookieFactory : ICookieFactory
    ) : TSessionMiddlewareFactory;
    begin
        fCookieFactory := aCookieFactory;
        result := self;
    end;


    function TSessionMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        if fCookieFactory = nil then
        begin
            fCookieFactory := TCookieFactory.create();
        end;

        result := TSessionMiddleware.create(fSessionMgr, fCookieFactory, fExpiresInSec);
    end;

end.
