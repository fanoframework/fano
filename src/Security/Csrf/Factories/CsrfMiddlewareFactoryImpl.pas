{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CsrfMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    RequestHandlerIntf,
    CsrfIntf,
    SessionManagerIntf;

type

    (*!------------------------------------------------
     * factory class for TCsrfMiddleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCsrfMiddlewareFactory = class(TFactory, IDependencyFactory)
    private
        fSessionManager : ISessionManager;
        fFailureHandler : IRequestHandler;
        fCsrf : ICsrf;
        fCsrfName : shortstring;
        fCsrfToken : shortstring;
        fSecretKey : string;
    public
        constructor create(const secretKey : string);
        destructor destroy(); override;

        (*!---------------------------------------
         * set CSRF helper
         *----------------------------------------
         * @param csrfHelper
         * @return current instance
         *----------------------------------------*)
        function csrf(const csrfHelper : ICsrf) : TCsrfMiddlewareFactory;

        (*!---------------------------------------
         * set session manager to use
         *----------------------------------------
         * @param sessMgr session manager
         * @return current instance
         *----------------------------------------*)
        function sessionManager(const sessMgr : ISessionManager) : TCsrfMiddlewareFactory;

        (*!---------------------------------------
         * set request handler to use when CSRF check fail
         *----------------------------------------
         * @param failHandler request handler
         * @return current instance
         *----------------------------------------*)
        function failureHandler(const failHandler : IRequestHandler) : TCsrfMiddlewareFactory;

        (*!---------------------------------------
         * set name of CSRF token name field
         *----------------------------------------
         * @param fname name of field
         * @return current instance
         *----------------------------------------
         * if you set fname = 'csrf_name' then
         * request is expected to have that field
         * <form method="post">
         *    <input type="hidden" name="csrf_name" value="some_random_name" >
         *    ...
         * </form>
         *----------------------------------------*)
        function nameField(const fname : shortstring) : TCsrfMiddlewareFactory;

        (*!---------------------------------------
         * set name of CSRF token value field
         *----------------------------------------
         * @param fvalue name of field
         * @return current instance
         *----------------------------------------
         * if you set fvalue = 'csrf_token' then
         * request is expected to have that field
         * <form method="post">
         *    <input type="hidden" name="csrf_token" value="some_random_token" >
         *    ...
         * </form>
         *----------------------------------------*)
        function tokenField(const fvalue : shortstring) : TCsrfMiddlewareFactory;

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
    CsrfConsts,
    CsrfImpl,
    CsrfMiddlewareImpl,
    DefaultFailCsrfHandlerImpl;

    constructor TCsrfMiddlewareFactory.create(const secretKey : string);
    begin
        fSessionManager := nil;
        fFailureHandler := nil;
        fCsrf := nil;
        fSecretKey := secretKey;
        fCsrfName := CSRF_NAME;
        fCsrfToken := CSRF_TOKEN;
    end;

    destructor TCsrfMiddlewareFactory.destroy();
    begin
        fSessionManager := nil;
        fFailureHandler := nil;
        fCsrf := nil;
        inherited destroy();
    end;

    (*!---------------------------------------
     * set CSRF helper
     *----------------------------------------
     * @param csrfHelper
     * @return current instance
     *----------------------------------------*)
    function TCsrfMiddlewareFactory.csrf(const csrfHelper : ICsrf) : TCsrfMiddlewareFactory;
    begin
        fCsrf := csrfHelper;
        result := self;
    end;

    (*!---------------------------------------
     * set session manager to use
     *----------------------------------------
     * @param sessMgr session manager
     * @return current instance
     *----------------------------------------*)
    function TCsrfMiddlewareFactory.sessionManager(const sessMgr : ISessionManager) : TCsrfMiddlewareFactory;
    begin
        fSessionManager := sessMgr;
        result := self;
    end;

    (*!---------------------------------------
     * set request handler to use when CSRF check fail
     *----------------------------------------
     * @param failHandler request handler
     * @return current instance
     *----------------------------------------*)
    function TCsrfMiddlewareFactory.failureHandler(const failHandler : IRequestHandler) : TCsrfMiddlewareFactory;
    begin
        fFailureHandler := failHandler;
        result := self;
    end;

    (*!---------------------------------------
     * set name of CSRF token name field
     *----------------------------------------
     * @param fname name of field
     * @return current instance
     *----------------------------------------
     * if you set fname = 'csrf_name' then
     * request is expected to have that field
     * <form method="post">
     *    <input type="hidden" name="csrf_name" value="some_random_name" >
     *    ...
     * </form>
     *----------------------------------------*)
    function TCsrfMiddlewareFactory.nameField(const fname : shortstring) : TCsrfMiddlewareFactory;
    begin
        fCsrfName := fname;
        result := self;
    end;

    (*!---------------------------------------
     * set name of CSRF token value field
     *----------------------------------------
     * @param fvalue name of field
     * @return current instance
     *----------------------------------------
     * if you set fvalue = 'csrf_token' then
     * request is expected to have that field
     * <form method="post">
     *    <input type="hidden" name="csrf_token" value="some_random_token" >
     *    ...
     * </form>
     *----------------------------------------*)
    function TCsrfMiddlewareFactory.tokenField(const fvalue : shortstring) : TCsrfMiddlewareFactory;
    begin
        fCsrfToken := fvalue;
        result := self;
    end;

    function TCsrfMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        if fSessionManager = nil then
        begin
            fSessionManager := container.get(GuidToString(ISessionManager)) as ISessionManager;
        end;

        if fFailureHandler = nil then
        begin
            fFailureHandler := TDefaultFailCsrfHandler.create();
        end;

        if fCsrf = nil then
        begin
            fCsrf := TCsrf.create(fSecretKey);
        end;

        result := TCsrfMiddleware.create(
            fCsrf,
            fSessionManager,
            fFailureHandler,
            fCsrfName,
            fCsrfToken
        );
    end;

end.
