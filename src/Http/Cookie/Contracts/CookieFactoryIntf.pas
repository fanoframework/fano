{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CookieFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    CookieIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to create
     * ICookie interface instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ICookieFactory = interface
        ['{1BCEABF6-2432-419F-B90E-D329EAFEA4E9}']

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
end.
