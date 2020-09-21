{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CookieFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    CookieIntf,
    CookieFactoryIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * basic class having capability to create
     * ICookie interface instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCookieFactory = class(TInjectableObject, ICookieFactory)
    private
        fCookieName : string;
        fCookieValue : string;
        fCookiePath : string;
        fCookieDomain : string;
        fCookieExpires : TDateTime;
        fCookieMaxAge : integer;
        fCookieSecure : boolean;
        fCookieHttpOnly : boolean;
        fCookieSameSite : string;
    public
        constructor create();

        (*!------------------------------------------------
         * set cookie name
         *-------------------------------------------------
         * @param cookieName name of key
         * @return current instance
         *------------------------------------------------*)
        function name(const cookieName : string) : ICookieFactory;

        (*!------------------------------------------------
         * set cookie value
         *-------------------------------------------------
         * @param cookieValue cookie value
         * @return current instance
         *------------------------------------------------*)
        function value(const cookieValue : string) : ICookieFactory;

        (*!------------------------------------------------
         * set cookie path
         *-------------------------------------------------
         * @param cookiePath cookie path
         * @return current instance
         *------------------------------------------------*)
        function path(const cookiePath : string) : ICookieFactory;

        (*!------------------------------------------------
         * set cookie domain
         *-------------------------------------------------
         * @param cookieDomain cookie domain
         * @return current instance
         *------------------------------------------------*)
        function domain(const cookieDomain : string) : ICookieFactory;

        (*!------------------------------------------------
         * set cookie expires
         *-------------------------------------------------
         * @param cookieExpires expires date
         * @return current instance
         *------------------------------------------------*)
        function expires(const cookieExpires : TDateTime) : ICookieFactory;

        (*!------------------------------------------------
         * set cookie max age
         *-------------------------------------------------
         * @param cookieMaxAge number of seconds until expires
         * @return current instance
         *------------------------------------------------*)
        function maxAge(const cookieMaxAge : integer) : ICookieFactory;

        (*!------------------------------------------------
         * set cookie secure
         *-------------------------------------------------
         * @param cookieSecure secure cookie
         * @return current instance
         *------------------------------------------------*)
        function secure(const cookieSecure : boolean) : ICookieFactory;

        (*!------------------------------------------------
         * set cookie http only
         *-------------------------------------------------
         * @param cookieHttpOnly http only cookie
         * @return current instance
         *------------------------------------------------*)
        function httpOnly(const cookieHttpOnly : boolean) : ICookieFactory;

        (*!------------------------------------------------
         * set cookie same site
         *-------------------------------------------------
         * @param cookieSameSite set cookie same site
         * @return current instance
         *------------------------------------------------*)
        function sameSite(const cookieSameSite : string) : ICookieFactory;

        (*!------------------------------------------------
         * build cookie instance
         *-------------------------------------------------
         * @return ICookie instance
         *------------------------------------------------*)
        function build() : ICookie;
    end;

implementation

uses

    SysUtils,
    DateUtils,
    CookieImpl;

    constructor TCookieFactory.create();
    begin
        fCookieName := '';
        fCookieValue := '';
        fCookiePath := '/';
        fCookieDomain := '';
        fCookieMaxAge := 3600;
        fCookieExpires :=  incSecond(now(), fCookieMaxAge);
        fCookieSecure := false;
        fCookieHttpOnly := false;
        fCookieSameSite := 'Lax';
    end;

    (*!------------------------------------------------
     * set cookie name
     *-------------------------------------------------
     * @param cookieName name of key
     * @return current instance
     *------------------------------------------------*)
    function TCookieFactory.name(const cookieName : string) : ICookieFactory;
    begin
        fCookieName := cookieName;
        result := self;
    end;

    (*!------------------------------------------------
     * set cookie value
     *-------------------------------------------------
     * @param cookieValue cookie value
     * @return current instance
     *------------------------------------------------*)
    function TCookieFactory.value(const cookieValue : string) : ICookieFactory;
    begin
        fCookieValue := cookieValue;
        result := self;
    end;

    (*!------------------------------------------------
     * set cookie path
     *-------------------------------------------------
     * @param cookiePath cookie path
     * @return current instance
     *------------------------------------------------*)
    function TCookieFactory.path(const cookiePath : string) : ICookieFactory;
    begin
        fCookiePath := cookiePath;
        result := self;
    end;

    (*!------------------------------------------------
     * set cookie domain
     *-------------------------------------------------
     * @param cookieDomain cookie domain
     * @return current instance
     *------------------------------------------------*)
    function TCookieFactory.domain(const cookieDomain : string) : ICookieFactory;
    begin
        fCookieDomain := cookieDomain;
        result := self;
    end;

    (*!------------------------------------------------
     * set cookie expires
     *-------------------------------------------------
     * @param cookieExpires expires date
     * @return current instance
     *------------------------------------------------*)
    function TCookieFactory.expires(const cookieExpires : TDateTime) : ICookieFactory;
    begin
        fCookieExpires := cookieExpires;
        result := self;
    end;

    (*!------------------------------------------------
     * set cookie max age
     *-------------------------------------------------
     * @param cookieMaxAge number of seconds until expires
     * @return current instance
     *------------------------------------------------*)
    function TCookieFactory.maxAge(const cookieMaxAge : integer) : ICookieFactory;
    begin
        fCookieMaxAge := cookieMaxAge;
        result := self;
    end;

    (*!------------------------------------------------
     * set cookie secure
     *-------------------------------------------------
     * @param cookieSecure secure cookie
     * @return current instance
     *------------------------------------------------*)
    function TCookieFactory.secure(const cookieSecure : boolean) : ICookieFactory;
    begin
        fCookieSecure := cookieSecure;
        result := self;
    end;

    (*!------------------------------------------------
     * set cookie http only
     *-------------------------------------------------
     * @param cookieHttpOnly http only cookie
     * @return current instance
     *------------------------------------------------*)
    function TCookieFactory.httpOnly(const cookieHttpOnly : boolean) : ICookieFactory;
    begin
        fCookieHttpOnly := cookieHttpOnly;
        result := self;
    end;

    (*!------------------------------------------------
     * set cookie same site
     *-------------------------------------------------
     * @param cookieSameSite set cookie same site
     * @return current instance
     *------------------------------------------------*)
    function TCookieFactory.sameSite(const cookieSameSite : string) : ICookieFactory;
    begin
        fCookieSameSite := cookieSameSite;
        result := self;
    end;

    (*!------------------------------------------------
     * build cookie instance
     *-------------------------------------------------
     * @return ICookie instance
     *------------------------------------------------*)
    function TCookieFactory.build() : ICookie;
    begin
        result := TCookie.create(
            fCookieName,
            fCookieValue,
            fCookiePath,
            fCookieDomain,
            fCookieExpires,
            fCookieMaxAge,
            fCookieSecure,
            fCookieHttpOnly,
            fCookieSameSite
        );
    end;
end.
