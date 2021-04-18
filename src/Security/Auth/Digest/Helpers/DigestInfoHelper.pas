{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DigestInfoHelper;

interface

{$MODE OBJFPC}
{$H+}

uses

    DigestInfoTypes,
    CredentialTypes;

    function initEmptyDigestInfo(const requestMethod : string) : PDigestInfo;

    function freeDigestInfo(di : PDigestInfo) : PDigestInfo;

    function fillDigestInfo(
        di : PDigestInfo;
        const key: string;
        const value : string
    ) : PDigestInfo;

    function getDigestInfo(
        const requestMethod : string;
        const authHeaderLine : string
    ) : PDigestInfo;

    function calcDigestResponse(
        const authCredDigest : PDigestInfo;
        const allowedCred : TCredential
    ) : string;

implementation

uses

    md5,
    regexpr;

    function initEmptyDigestInfo(const requestMethod : string) : PDigestInfo;
    begin
        new(result);
        with result^ do
        begin
            username := '';
            nonce := '';
            realm := '';
            uri := '';
            qop := '';
            nc := '';
            cnonce := '';
            response := '';
            opaque := '';
            method := requestMethod;
        end;
    end;

    function freeDigestInfo(di : PDigestInfo) : PDigestInfo;
    begin
        if (di <> nil) then
        begin
            dispose(di);
            di := nil;
        end;
        result := di;
    end;

    function fillDigestInfo(
        di : PDigestInfo;
        const key: string;
        const value : string
    ) : PDigestInfo;
    begin
        with di^ do
        begin
            case key of
                'username' : username := value;
                'nonce' : nonce := value;
                'realm' : realm := value;
                'uri' : uri := value;
                'qop' : qop := value;
                'nc' : nc := value;
                'cnonce' : cnonce := value;
                'response' : response := value;
                'opaque' : opaque := value;
            end;
        end;
        result := di;
    end;

    procedure extractKeyValuePair(re : TRegExpr; out key : string; out value : string);
    var
        lastMatchLen : integer;
        comaPos : integer;
    begin
        key := re.match[1];
        lastMatchLen := re.SubExprMatchCount;
        value := re.match[lastMatchLen];
        if lastMatchLen < 4 then
        begin
            //we dealing with unquoted value, value will contain trailing coma
            //remove them
            comaPos := pos(',', value);
            if (comaPos <> 0) then
            begin
                value := copy(value, 1, comaPos - 1);
            end;
        end
    end;

    (*!------------------------------------------------
     * extract value from Authorization: Digest ...
     *-------------------------------------------------
     * @param requestMethod current request method
     * @param authHeaderLine content of Authorization request header
     * @return parsed value
     *-------------------------------------------------
     *
     *   GET /dir/index.html HTTP/1.0
     *   Host: localhost
     *   Authorization: Digest username="Mufasa",
     *                       realm="testrealm@host.com",
     *                       nonce="dcd98b7102dd2f0e8b11d0f600bfb0c093",
     *                       uri="/dir/index.html",
     *                       qop=auth,
     *                       nc=00000001,
     *                      cnonce="0a4f113b",
     *                       response="6629fae49393a05397450978507c4ef1",
     *                       opaque="5ccc069c403ebaf9f0171e9517f40e41"
     *
     * Parse content of Authorization request header above into TDigestInfo
     * digestInfo.username='Mufasa'
     * digestInfo.realm='testrealm@host.com'
     * digestInfo.nonce='dcd98b7102dd2f0e8b11d0f600bfb0c093'
     *-------------------------------------------------*)
    function getDigestInfo(
        const requestMethod : string;
        const authHeaderLine : string
    ) : PDigestInfo;
    const REGEXPATTERN = '(\w+)[\s]*=[\s]*(([^"''\s]+)|''([^'']*)''|"([^"]*)")\s*,*';
    var re : TRegExpr;
        key, value : string;
    begin
        result := initEmptyDigestInfo(requestMethod);
        re := TRegExpr.create(REGEXPATTERN);
        try
            re.modifierG := true;
            re.modifierM := true;
            if re.exec(authHeaderLine) then
            begin
                extractKeyValuePair(re, key, value);
                result := fillDigestInfo(result, key, value);
                while (re.execNext()) do
                begin
                    extractKeyValuePair(re, key, value);
                    result := fillDigestInfo(result, key, value);
                end;
            end;
        finally
            re.free();
        end;
    end;

    function calcDigestResponse(
        const authCredDigest : PDigestInfo;
        const allowedCred : TCredential
    ) : string;
    var
        ha1, ha2, origResponse : string;
    begin
        ha1 := MD5Print(
            MD5String(
                allowedCred.username + ':' +
                authCredDigest^.realm + ':' +
                allowedCred.password
            )
        );

        ha2 := MD5Print(
            MD5String(authCredDigest^.method + ':' + authCredDigest^.uri)
        );

        if authCredDigest^.qop = '' then
        begin
            origResponse := ha1 + ':' + authCredDigest^.nonce + ':' + ha2;
        end else
        begin
            origResponse := ha1 + ':' +
                authCredDigest^.nonce + ':' +
                authCredDigest^.nc + ':' +
                authCredDigest^.cnonce + ':' +
                authCredDigest^.qop + ':' +
                ha2;
        end;

        result := MD5Print(MD5String(origResponse));
    end;


end.
