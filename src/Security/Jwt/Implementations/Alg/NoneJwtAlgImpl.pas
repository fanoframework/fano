{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NoneJwtAlgImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    JwtAlgVerifierIntf,
    JwtAlgSignerIntf;

type

    (*!------------------------------------------------
     * class that does nothing. This is provided
     * to allow verify/sign unsecured JWT token without
     * signature
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNoneJwtAlg = class (TInterfacedObject, IJwtAlgVerifier, IJwtAlgSigner)
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
    public
        (*!------------------------------------------------
         * get JWT algorithm name
         *-------------------------------------------------
         * @return string name of algorithm
         *-------------------------------------------------*)
        function name() : shortstring;
    end;

implementation

uses

    JwtConsts;

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
    function TNoneJwtAlg.verify(
        const payload: string;
        const signature : string;
        const secretKey: string
    ) : boolean;
    begin
        //intentionally assume payload always verified
        result := true;
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
    function TNoneJwtAlg.sign(const payload : string; const secretKey: string) : string;
    begin
        //intentionally returns empty signature.
        result := '';
    end;

    (*!------------------------------------------------
     * get JWT algorithm name
     *-------------------------------------------------
     * @return string name of algorithm
     *-------------------------------------------------*)
    function TNoneJwtAlg.name() : shortstring;
    begin
        result := ALG_NONE;
    end;
end.
