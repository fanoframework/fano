{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CookieImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Consts,
    CookieIntf;

type

    (*!------------------------------------------------
     * basic class implement ICookie having capability as
     * manage one HTTP cookie (RFC 6265)
     *
     * @link https://tools.ietf.org/html/rfc6265
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCookie = class(TInterfacedObject, ICookie)
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

        (*!------------------------------------------------
         * convert datetime according tp RFC 7231
         *------------------------------------------------
         * @link https://tools.ietf.org/html/rfc7231#section-7.1.1.2
         *-------------------------------------------------
         * @param adateTime a date time
         * @return RFC 7231 Date string
         *------------------------------------------------*)
        function getRfc7231Date(const adateTime : TDateTime) : string;
    public
        constructor create(
            const cookieName : string = '';
            const cookieValue : string = '';
            const cookiePath : string = '';
            const cookieDomain : string = '';
            const cookieExpires : TDateTime = UNASSIGNED_DATETIME;
            const cookieMaxAge : integer = -1;
            const cookieSecure : boolean = false;
            const cookieHttpOnly : boolean = false;
            const cookieSameSite : string = 'Lax'
        );

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

        (*!------------------------------------------------
         * serialize cookie as string
         *-------------------------------------------------
         * @return cookie string
         *------------------------------------------------*)
        function serialize() : string;
    end;

implementation

uses

    SysUtils,
    EInvalidCookieImpl;

resourcestring

    sErrCookieNameNotSet = 'Cookie name is not set';
    sErrCookieAttrInvalidValue = 'Cookie attribute %s value is invalid (%s)';

    constructor TCookie.create(
        const cookieName : string = '';
        const cookieValue : string = '';
        const cookiePath : string = '';
        const cookieDomain : string = '';
        const cookieExpires : TDateTime = UNASSIGNED_DATETIME;
        const cookieMaxAge : integer = -1;
        const cookieSecure : boolean = false;
        const cookieHttpOnly : boolean = false;
        const cookieSameSite : string = 'Lax'
    );
    begin
        fCookieName := cookieName;
        fCookieValue := cookieValue;
        fCookiePath := cookiePath;
        fCookieDomain := cookieDomain;
        fCookieExpires := cookieExpires;
        fCookieMaxAge := cookieMaxAge;
        fCookieSecure := cookieSecure;
        fCookieHttpOnly := cookieHttpOnly;
        fCookieSameSite := cookieSameSite;
    end;

    (*!------------------------------------------------
     * set cookie name
     *-------------------------------------------------
     * @param cookieName name of key
     * @return current instance
     *------------------------------------------------*)
    function TCookie.setName(const cookieName : string) : ICookie;
    begin
        fCookieName := cookieName;
        result := self;
    end;

    (*!------------------------------------------------
     * get cookie name
     *-------------------------------------------------
     * @return cookieName
     *------------------------------------------------*)
    function TCookie.getName() : string;
    begin
        result := fCookieName;
    end;

    (*!------------------------------------------------
     * set cookie value
     *-------------------------------------------------
     * @param cookieValue cookie value
     * @return current instance
     *------------------------------------------------*)
    function TCookie.setValue(const cookieValue : string) : ICookie;
    begin
        fCookieValue := cookieValue;
        result := self;
    end;

    (*!------------------------------------------------
     * get cookie value
     *-------------------------------------------------
     * @return cookieValue cookie value
     *------------------------------------------------*)
    function TCookie.getValue() : string;
    begin
        result := fCookieValue;
    end;

    (*!------------------------------------------------
     * set cookie path
     *-------------------------------------------------
     * @param cookiePath cookie path
     * @return current instance
     *------------------------------------------------*)
    function TCookie.setPath(const cookiePath : string) : ICookie;
    begin
        fCookiePath := cookiePath;
        result := self;
    end;

    (*!------------------------------------------------
     * get cookie path
     *-------------------------------------------------
     * @return cookie path
     *------------------------------------------------*)
    function TCookie.getPath() : string;
    begin
        result := fCookiePath;
    end;

    (*!------------------------------------------------
     * set cookie domain
     *-------------------------------------------------
     * @param cookieDomain cookie domain
     * @return current instance
     *------------------------------------------------*)
    function TCookie.setDomain(const cookieDomain : string) : ICookie;
    begin
        fCookieDomain := cookieDomain;
        result := self;
    end;

    (*!------------------------------------------------
     * get cookie domain
     *-------------------------------------------------
     * @return cookie domain
     *------------------------------------------------*)
    function TCookie.getDomain() : string;
    begin
        result := fCookieDomain;
    end;

    (*!------------------------------------------------
     * set cookie expires
     *-------------------------------------------------
     * @param cookieExpires expires date
     * @return current instance
     *------------------------------------------------*)
    function TCookie.setExpires(const cookieExpires : TDateTime) : ICookie;
    begin
        fCookieExpires := cookieExpires;
        result := self;
    end;

    (*!------------------------------------------------
     * get cookie expires
     *-------------------------------------------------
     * @param expires date
     *------------------------------------------------*)
    function TCookie.getExpires() : TDateTime;
    begin
        result := fCookieExpires;
    end;

    (*!------------------------------------------------
     * set cookie max age
     *-------------------------------------------------
     * @param cookieMaxAge number of seconds until expires
     * @return current instance
     *------------------------------------------------*)
    function TCookie.setMaxAge(const cookieMaxAge : integer) : ICookie;
    begin
        fCookieMaxAge := cookieMaxAge;
        result := self;
    end;

    (*!------------------------------------------------
     * get cookie max age
     *-------------------------------------------------
     * @return number of seconds until expires
     *------------------------------------------------*)
    function TCookie.getMaxAge() : integer;
    begin
        result := fCookieMaxAge;
    end;

    (*!------------------------------------------------
     * set cookie secure
     *-------------------------------------------------
     * @param cookieSecure secure cookie
     * @return current instance
     *------------------------------------------------*)
    function TCookie.setSecure(const cookieSecure : boolean) : ICookie;
    begin
        fCookieSecure := cookieSecure;
        result := self;
    end;

    (*!------------------------------------------------
     * get cookie secure
     *-------------------------------------------------
     * @return cookie secure
     *------------------------------------------------*)
    function TCookie.getSecure() : boolean;
    begin
        result := fCookieSecure;
    end;

    (*!------------------------------------------------
     * set cookie http only
     *-------------------------------------------------
     * @param cookieHttpOnly http only cookie
     * @return current instance
     *------------------------------------------------*)
    function TCookie.setHttpOnly(const cookieHttpOnly : boolean) : ICookie;
    begin
        fCookieHttpOnly := cookieHttpOnly;
        result := self;
    end;

    (*!------------------------------------------------
     * get cookie http only
     *-------------------------------------------------
     * @return cookie http only
     *------------------------------------------------*)
    function TCookie.getHttpOnly() : boolean;
    begin
        result := fCookieHttpOnly;
    end;

    (*!------------------------------------------------
     * set cookie same site
     *-------------------------------------------------
     * @param cookieSameSite set cookie same site
     * @return current instance
     *------------------------------------------------*)
    function TCookie.setSameSite(const cookieSameSite : string) : ICookie;
    var isValid : boolean;
    begin
        isValid := (cookieSameSite = 'Strict') or
            (cookieSameSite =  'Lax') or
            (cookieSameSite = 'None');

        if not isValid then
        begin
            raise EInvalidCookie.createFmt(
                sErrCookieAttrInvalidValue,
                ['SameSite', cookieSameSite]
            );
        end;

        fCookieSameSite := cookieSameSite;
        result := self;
    end;

    (*!------------------------------------------------
     * get cookie same site
     *-------------------------------------------------
     * @return cookie same site
     *------------------------------------------------*)
    function TCookie.getSameSite() : string;
    begin
        result := fCookieSameSite;
    end;

    (*!------------------------------------------------
     * convert datetime according tp RFC 7231
     *------------------------------------------------
     * @link https://tools.ietf.org/html/rfc7231#section-7.1.1.2
     *-------------------------------------------------
     * @param adateTime a date time
     * @return RFC 7231 Date string
     *------------------------------------------------*)
    function TCookie.getRfc7231Date(const adateTime : TDateTime) : string;
    begin
        result := formatDateTime('ddd, DD mmm YYYY hh:nn:ss "GMT"', adateTime);
    end;

    (*!------------------------------------------------
     * serialize cookie as string
     *-------------------------------------------------
     * @return cookie string
     *------------------------------------------------*)
    function TCookie.serialize() : string;
    var cookieStr : string;
    begin
        if (fCookieName = '') then
        begin
            //cookie name must be set
            raise EInvalidCookie.create(sErrCookieNameNotSet);
        end;

        cookieStr := fCookieName + '=' + fCookieValue + ';';

        if (fCookiePath <> '') then
        begin
            cookieStr := cookieStr + ' Path=' + fCookiePath + ';';
        end;

        if (fCookieDomain <> '') then
        begin
            cookieStr := cookieStr + ' Domain=' + fCookieDomain + ';';
        end;

        if (fCookieExpires <> UNASSIGNED_DATETIME) then
        begin
            //format Date according to RFC 7231
            cookieStr := cookieStr + ' Expires=' + getRfc7231Date(fCookieExpires) + ';';
        end;

        if (fCookieMaxAge <> -1) then
        begin
            cookieStr := cookieStr + ' Max-Age=' + intToStr(fCookieMaxAge) + ';';
        end;

        if (fCookieSecure) then
        begin
            cookieStr := cookieStr + ' Secure;';
        end;

        if (fCookieHttpOnly) then
        begin
            cookieStr := cookieStr + ' HttpOnly;';
        end;

        if (fCookieSameSite <> '') then
        begin
            cookieStr := cookieStr + ' SameSite=' + fCookieSameSite + ';';
        end;

        result := cookieStr;
    end;
end.
