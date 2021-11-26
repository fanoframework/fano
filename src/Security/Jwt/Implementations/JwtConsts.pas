{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JwtConsts;

interface

{$MODE OBJFPC}
{$H+}

const

    (*!------------------------------------------------
     * JWT data
     *-------------------------------------------------*)
    JWT_ISSUER = 'iss';
    JWT_AUDIENCE = 'aud';
    JWT_SUBJECT = 'sub';

    (*!------------------------------------------------
     * Supported JWT signing algorithm
     *-------------------------------------------------
     * NONE = No signing
     * HS256 = HMAC SHA2-256
     * HS384 = HMAC SHA2-384
     * HS512 = HMAC SHA2-512
     *-------------------------------------------------*)
    ALG_NONE = 'none';
    ALG_HS256 = 'HS256';
    ALG_HS384 = 'HS384';
    ALG_HS512 = 'HS512';

    {$IF FPC_FULLVERSION <= 30400}
        //FPC <= 3.0.4 does not properly base64 url encode/decode
        //JWT so we provide utility for it
        function base64UrlEncode(const aValue: string) : string;
        function base64UrlDecode(const aValue: string) : string;
    {$ENDIF}

implementation

{$IF FPC_FULLVERSION <= 30400}
uses

    SysUtils,
    Base64,
    StrUtils;

    //FPC <= 3.0.4 does not properly base64 url encode/decode
    //JWT so we provide utility for it
    function base64UrlEncode(const aValue: string) : string;
    begin
        result := EncodeStringBase64(aValue);

        //replace + with - and / with _ and trim = padding
        result := TrimRightSet(
            stringsReplace(result, ['+', '/'], ['-', '_'], [rfReplaceAll]),
            ['=']
        );
    end;

    function base64UrlDecode(const aValue: string) : string;
    var padLen: integer;
    begin
        result := StringsReplace(AValue, ['-', '_'], ['+', '/'], [rfReplaceAll]);
        padLen := length(result) mod 4;
        if padLen > 0 then
        begin
            //add padding =
            result := result + StringOfChar('=', 4 - padLen);
        end;
        result := DecodeStringBase64(result, true);
    end;
{$ENDIF}
end.
