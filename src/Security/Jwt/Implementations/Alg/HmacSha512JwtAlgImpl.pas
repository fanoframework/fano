{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HmacSha512JwtAlgImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    AbstractHmacJwtAlgImpl;

type

    (*!------------------------------------------------
     * class having capability to verify JWT token validity
     * with HMAC SHA-2 512
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    THmacSha512JwtAlg = class (TAbstractHmacJwtAlg)
    protected
        (*!------------------------------------------------
         * compute HMAC SHA2-512 of string
         *-------------------------------------------------
         * @param signature signature to compare
         * @param secretKey secret key
         * @return hash value
         *-------------------------------------------------*)
        function hmac(const inpStr : string; const secretKey: string) : string; override;
    public
        (*!------------------------------------------------
         * get JWT algorithm name
         *-------------------------------------------------
         * @return string name of algorithm
         *-------------------------------------------------*)
        function name() : shortstring; override;
    end;

implementation

uses

    SysUtils,
    HlpIHashInfo,
    HlpConverters,
    HlpHashFactory,
    SbpBase64,
    JwtConsts;

    (*!------------------------------------------------
     * compute HMAC SHA2-256 of string
     *-------------------------------------------------
     * @param signature signature to compare
     * @param secretKey secret key
     * @return hash value
     *-------------------------------------------------*)
    function THmacSha512JwtAlg.hmac(
        const inpStr : string;
        const secretKey : string
    ) : string;
    var hmacInst : IHMAC;
    begin
        hmacInst := THashFactory.THMAC.CreateHMAC(
            THashFactory.TCrypto.CreateSHA2_512
        );
        hmacInst.Key := TConverters.ConvertStringToBytes(secretKey, TEncoding.UTF8);
        result := TBase64.UrlEncoding.Encode(
            hmacInst.ComputeString(inpStr, TEncoding.UTF8).GetBytes()
        );
    end;

    (*!------------------------------------------------
     * get JWT algorithm name
     *-------------------------------------------------
     * @return string name of algorithm
     *-------------------------------------------------*)
    function THmacSha512JwtAlg.name() : shortstring;
    begin
        result := ALG_HS512;
    end;
end.
