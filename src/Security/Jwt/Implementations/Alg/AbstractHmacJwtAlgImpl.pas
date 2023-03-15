{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractHmacJwtAlgImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    JwtAlgVerifierIntf,
    JwtAlgSignerIntf;

type

    (*!------------------------------------------------
     * class having capability to verify JWT token validity
     * with HMAC
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAbstractHmacJwtAlg = class abstract (TInterfacedObject, IJwtAlgVerifier, IJwtAlgSigner)
    protected
        (*!------------------------------------------------
         * compute HMAC of string
         *-------------------------------------------------
         * @param signature signature to compare
         * @param secretKey secret key
         * @return hash value
         *-------------------------------------------------*)
        function hmac(const inpStr : string; const secretKey: string) : string; virtual; abstract;
    public
        (*!------------------------------------------------
         * verify token
         *-------------------------------------------------
         * @param payload payload to verify
         * @param signature signature to compare
         * @param secretKey secret key
         * @return boolean true if payload is verified
         *-------------------------------------------------
         * Note: payload is concatenated value of
         * base64url_header + '.' + base64url_claim
         *-------------------------------------------------*)
        function verify(
            const payload : string;
            const signature : string;
            const secretKey: string
        ) : boolean;

        (*!------------------------------------------------
         * compute JWT signature of payload
         *-------------------------------------------------
         * @param payload payload to sign
         * @param secretKey secret key
         * @return string signature
         *-------------------------------------------------
         * Note: payload is assumed concatenated value of
         * base64url_header + '.' + base64url_claim
         *-------------------------------------------------*)
        function sign(const payload : string; const secretKey: string) : string;

        (*!------------------------------------------------
         * get JWT algorithm name
         *-------------------------------------------------
         * @return string name of algorithm
         *-------------------------------------------------*)
        function name() : shortstring; virtual; abstract;
    end;

implementation

    (*!------------------------------------------------
     * verify token
     *-------------------------------------------------
     * @param payload payload to verify
     * @param signature signature to compare
     * @param secretKey secret key
     * @return boolean true if payload is verified
     *-------------------------------------------------
     * Note: payload is concatenated value of
     * base64url_header + '.' + base64url_claim
     *-------------------------------------------------*)
    function TAbstractHmacJwtAlg.verify(
        const payload: string;
        const signature : string;
        const secretKey: string
    ) : boolean;
    begin
        result := hmac(payload, secretKey) = signature;
    end;

    (*!------------------------------------------------
     * compute JWT signature of payload
     *-------------------------------------------------
     * @param payload payload to sign
     * @param secretKey secret key
     * @return string signature
     *-------------------------------------------------
     * Note: payload is assumed concatenated value of
     * base64url_header + '.' + base64url_claim
     *-------------------------------------------------*)
    function TAbstractHmacJwtAlg.sign(const payload : string; const secretKey: string) : string;
    begin
        result := hmac(payload, secretKey);
    end;
end.
