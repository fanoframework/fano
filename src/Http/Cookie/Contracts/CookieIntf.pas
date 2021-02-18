{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CookieIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability as
     * manage one HTTP cookie (RFC 6265)
     *
     * @link https://tools.ietf.org/html/rfc6265
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ICookie = interface (ISerializeable)
        ['{7AC8B542-0E12-47F3-B652-DEB8D45070D2}']

        (*!------------------------------------------------
         * set cookie name
         *-------------------------------------------------
         * @param cookieName name of key
         * @return current instance
         *------------------------------------------------*)
        function setName(const cookieName : string) : ICookie;

        (*!------------------------------------------------
         * get cookie name
         *-------------------------------------------------
         * @return cookieName
         *------------------------------------------------*)
        function getName() : string;

        (*!------------------------------------------------
         * set cookie value
         *-------------------------------------------------
         * @param cookieValue cookie value
         * @return current instance
         *------------------------------------------------*)
        function setValue(const cookieValue : string) : ICookie;

        (*!------------------------------------------------
         * get cookie value
         *-------------------------------------------------
         * @return cookieValue cookie value
         *------------------------------------------------*)
        function getValue() : string;

        (*!------------------------------------------------
         * set cookie path
         *-------------------------------------------------
         * @param cookiePath cookie path
         * @return current instance
         *------------------------------------------------*)
        function setPath(const cookiePath : string) : ICookie;

        (*!------------------------------------------------
         * get cookie path
         *-------------------------------------------------
         * @return cookie path
         *------------------------------------------------*)
        function getPath() : string;

        (*!------------------------------------------------
         * set cookie domain
         *-------------------------------------------------
         * @param cookieDomain cookie domain
         * @return current instance
         *------------------------------------------------*)
        function setDomain(const cookieDomain : string) : ICookie;

        (*!------------------------------------------------
         * get cookie domain
         *-------------------------------------------------
         * @return cookie domain
         *------------------------------------------------*)
        function getDomain() : string;

        (*!------------------------------------------------
         * set cookie expires
         *-------------------------------------------------
         * @param cookieExpires expires date
         * @return current instance
         *------------------------------------------------*)
        function setExpires(const cookieExpires : TDateTime) : ICookie;

        (*!------------------------------------------------
         * get cookie expires
         *-------------------------------------------------
         * @param expires date
         *------------------------------------------------*)
        function getExpires() : TDateTime;

        (*!------------------------------------------------
         * set cookie max age
         *-------------------------------------------------
         * @param cookieMaxAge number of seconds until expires
         * @return current instance
         *------------------------------------------------*)
        function setMaxAge(const cookieMaxAge : integer) : ICookie;

        (*!------------------------------------------------
         * get cookie max age
         *-------------------------------------------------
         * @return number of seconds until expires
         *------------------------------------------------*)
        function getMaxAge() : integer;

        (*!------------------------------------------------
         * set cookie secure
         *-------------------------------------------------
         * @param cookieSecure secure cookie
         * @return current instance
         *------------------------------------------------*)
        function setSecure(const cookieSecure : boolean) : ICookie;

        (*!------------------------------------------------
         * get cookie secure
         *-------------------------------------------------
         * @return cookie secure
         *------------------------------------------------*)
        function getSecure() : boolean;

        (*!------------------------------------------------
         * set cookie http only
         *-------------------------------------------------
         * @param cookieHttpOnly http only cookie
         * @return current instance
         *------------------------------------------------*)
        function setHttpOnly(const cookieHttpOnly : boolean) : ICookie;

        (*!------------------------------------------------
         * get cookie http only
         *-------------------------------------------------
         * @return cookie http only
         *------------------------------------------------*)
        function getHttpOnly() : boolean;

        (*!------------------------------------------------
         * set cookie same site
         *-------------------------------------------------
         * @param cookieSameSite set cookie same site
         * @return current instance
         *------------------------------------------------*)
        function setSameSite(const cookieSameSite : string) : ICookie;

        (*!------------------------------------------------
         * get cookie same site
         *-------------------------------------------------
         * @return cookie same site
         *------------------------------------------------*)
        function getSameSite() : string;

    end;

implementation
end.
