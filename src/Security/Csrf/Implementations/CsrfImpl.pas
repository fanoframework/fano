{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CsrfImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    CsrfIntf,
    SessionIntf;

type

    (*!------------------------------------------------
     * basic class having capability to
     * generate token to protect Cross-Site Request Forgery
     * (CSRF) attack
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCsrf = class(TInterfacedObject, ICsrf)
    private

        (*!------------------------------------------------
         * get token name and value from session
         *-------------------------------------------------
         * @param sess current session instance
         * @param nameKey name of key that hold token name
         * @param valueKey name of key that hold token value
         * @param tokenName token name retrived from session
         * @param tokenValue token value retrieved from session
         * @return true if token name and value is found in session
         *        false otherwise
         *-------------------------------------------------*)
        function getTokenFromSession(
            const sess : ISession;
            const nameKey : shortstring;
            const valueKey : shortstring;
            out tokenName : string;
            out tokenValue : string
        ) : boolean;
    protected
        fSecretKey : string;
    public
        constructor create(const secretKey : string);

        (*!------------------------------------------------
         * generate token name and value
         *-------------------------------------------------
         * @param tokenName token name
         * @param tokenValue token value
         * @return current instance
         *-------------------------------------------------*)
        function generateToken(out tokenName : string; out tokenValue : string) : ICsrf; virtual;

        (*!------------------------------------------------
         * test if request has valid token
         *-------------------------------------------------
         * @param request current request
         * @param sess current session
         * @param nameKey key contains name of token
         * @param valueKey key contains value of token
         * @return current instance
         *-------------------------------------------------*)
        function hasValidToken(
            const request : IRequest;
            const sess : ISession;
            const nameKey : shortstring;
            const valueKey : shortstring
        ) : boolean; virtual;
    end;

implementation

uses

    SysUtils,
    hmac,
    sha1,
    ESessionKeyNotFoundImpl;

    constructor TCsrf.create(const secretKey : string);
    begin
        fSecretKey := secretKey;
    end;


    (*!------------------------------------------------
     * generate token name and value
     *-------------------------------------------------
     * @param tokenName token name
     * @param tokenValue token value
     * @return current instance
     *-------------------------------------------------*)
    function TCsrf.generateToken(out tokenName : string; out tokenValue : string) : ICsrf;
    var id : TGUID;
        strId : string;
    begin
        createGUID(id);
        //convert GUID to string and remove { and } part
        strId := copy(GUIDToString(id), 2, 36);
        tokenValue := HMACSHA1(fSecretKey, strId);

        createGUID(id);
        //convert GUID to string and remove { and } part
        tokenName := copy(GUIDToString(id), 2, 36);
        result := self;
    end;

    (*!------------------------------------------------
     * get token name and value from session
     *-------------------------------------------------
     * @param sess current session instance
     * @param nameKey name of key that hold token name
     * @param valueKey name of key that hold token value
     * @param tokenName token name retrived from session
     * @param tokenValue token value retrieved from session
     * @return true if token name and value is found in session
     *        false otherwise
     *-------------------------------------------------*)
    function TCsrf.getTokenFromSession(
        const sess : ISession;
        const nameKey : shortstring;
        const valueKey : shortstring;
        out tokenName : string;
        out tokenValue : string
    ) : boolean;
    begin
        try
            tokenName := sess[nameKey];
            tokenValue := sess[valueKey];
            result := true;
        except
            on e : ESessionKeyNotFound do
            begin
                //if we get here, then session data not found
                result := false;
            end;
        end;
    end;

    (*!------------------------------------------------
     * test if request has valid token
     *-------------------------------------------------
     * @param request current request
     * @param session current session
     * @param nameKey key contains name of token
     * @param valueKey key contains value of token
     * @return current instance
     *-------------------------------------------------*)
    function TCsrf.hasValidToken(
        const request : IRequest;
        const sess : ISession;
        const nameKey : shortstring;
        const valueKey : shortstring
    ) : boolean;
    var tokenName, tokenValue : string;
        currTokenName, currTokenValue : string;
        tokenValueDigest : THMACSHA1Digest;
        currtokenValueDigest : THMACSHA1Digest;
    begin
        result:= getTokenFromSession(
            sess,
            nameKey,
            valueKey,
            currTokenName,
            currTokenValue
        );
        if not result then
        begin
            //if we get here, token not found in session.
            //Assume no valid token and just exit early
            exit(false);
        end;
        tokenName := request.getParsedBodyParam(nameKey);
        tokenValue := request.getParsedBodyParam(valueKey);
        tokenValueDigest := HMACSHA1Digest(fSecretKey, tokenValue);
        currTokenValueDigest := HMACSHA1Digest(fSecretKey, currTokenValue);
        result := (tokenName = currTokenName) and
            //we should use HMACSHA1Match(), but we can't because of infinite
            //recursion bug in this function in Free Pascal 3.04
            SHA1Match(tokenValueDigest, currTokenValueDigest);
    end;

end.
