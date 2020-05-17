{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CacheControlMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    HttpCacheIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TCacheControlMiddleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCacheControlMiddlewareFactory = class(TFactory, IDependencyFactory)
    private
        fCacheType : TCacheControlType;
        fNoStore : boolean;
        fMustRevalidate : boolean;
        fMaxAge : integer;
        fUseETag : boolean;
    public
        constructor create();
        function cacheType(const ctype : TCacheControlType) : TCacheControlMiddlewareFactory;
        function noStore() : TCacheControlMiddlewareFactory;
        function mustRevalidate() : TCacheControlMiddlewareFactory;
        function maxAge(const age : integer) : TCacheControlMiddlewareFactory;
        function useETag() : TCacheControlMiddlewareFactory;

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

    HttpCacheImpl,
    CacheControlMiddlewareImpl;

    constructor TCacheControlMiddlewareFactory.create();
    begin
        fCacheType := ctPrivate;
        fNoStore := false;
        fMustRevalidate := false;
        fMaxAge := MAX_AGE_1_DAY;
        fUseETag := false;
    end;

    function TCacheControlMiddlewareFactory.cacheType(const ctype : TCacheControlType) : TCacheControlMiddlewareFactory;
    begin
        fCacheType := ctype;
        result := self;
    end;

    function TCacheControlMiddlewareFactory.noStore() : TCacheControlMiddlewareFactory;
    begin
        fNoStore := true;
        result := self;
    end;

    function TCacheControlMiddlewareFactory.mustRevalidate() : TCacheControlMiddlewareFactory;
    begin
        fMustRevalidate := true;
        result := self;
    end;

    function TCacheControlMiddlewareFactory.useETag() : TCacheControlMiddlewareFactory;
    begin
        fUseETag := true;
        result := self;
    end;

    function TCacheControlMiddlewareFactory.maxAge(const age : integer) : TCacheControlMiddlewareFactory;
    begin
        fMaxAge := age;
        result := self;
    end;

    function TCacheControlMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    var cache : IHttpCache;
    begin
        cache := THttpCache.create(fCacheType, fMaxAge, fMustRevalidate);
        cache.noStore := fNoStore;
        cache.useETag := fUseETag;
        result := TCacheControlMiddleware.create(cache);
    end;

end.
