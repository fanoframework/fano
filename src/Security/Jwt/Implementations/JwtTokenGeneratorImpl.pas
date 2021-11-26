{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JwtTokenGeneratorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    fpjson,
    TokenGeneratorIntf,
    JwtAlgSignerIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * class having capability to generate signed JWT token
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TJwtTokenGenerator = class (TInjectableObject, ITokenGenerator)
    private
        fAlgorithm : IJwtAlgSigner;
        fSecretKey : string;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param secretKey secret key used to sign signature
         * @param algo algorithm to use
         *-------------------------------------------------*)
        constructor create(
            const secretKey : string;
            const algo: IJwtAlgSigner
        );

        (*!------------------------------------------------
         * destructor
         *-------------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * generate JWT token
         *-------------------------------------------------
         * @param token token to verify
         * @return TVerificationResult. Field verified will
         *        be true if token is verified and not expired
         *        and issuer match
         *-------------------------------------------------*)
        function generateToken(const payload : TJSONObject) : string;

    end;

implementation

uses

    sysutils,
    dateutils,
    strutils,
    base64,
    fpjwt,
    JwtConsts,
    EJwtImpl;

resourcestring

    rsAlgoMustNotNil = 'Algorithm must not be nil';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param secretKey secret key used to sign signature
     * @param algo algorithm to use
     *-------------------------------------------------*)
    constructor TJwtTokenGenerator.create(
        const secretKey : string;
        const algo: IJwtAlgSigner
    );
    begin
        fSecretKey := secretKey;
        fAlgorithm := algo;

        if fAlgorithm = nil then
        begin
            raise EJwt.create(rsAlgoMustNotNil);
        end;
    end;

    (*!------------------------------------------------
     * destructor
     *-------------------------------------------------*)
    destructor TJwtTokenGenerator.destroy();
    begin
        fAlgorithm := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * generate JWT token
     *-------------------------------------------------
     * @param token token to verify
     * @return TVerificationResult. Field verified will
     *        be true if token is verified and not expired
     *        and issuer match
     *-------------------------------------------------*)
    function TJwtTokenGenerator.generateToken(const payload : TJSONObject) : string;
    var
        jwt : TJwt;
        jwtHeaderPayloadStr : string;
    begin
        jwt := TJwt.create();
        try
            jwt.JOSE.typ := 'JWT';
            jwt.JOSE.alg := fAlgorithm.name();
            jwt.Claims.LoadFromJSON(payload);

            {$IF FPC_FULLVERSION <= 30400}
                //FPC <= 3.0.4, asEncodedString returns base64 while JWT requires
                //base64url so we just build our base64url encode manually
                jwtHeaderPayloadStr := base64UrlEncode(jwt.JOSE.AsString) + '.' +
                    base64UrlEncode(jwt.Claims.AsString);
            {$ELSE}
                jwtHeaderPayloadStr := jwt.JOSE.AsEncodedString + '.' + jwt.Claims.AsEncodedString;
            {$ENDIF}

            result := jwtHeaderPayloadStr + '.' + fAlgorithm.sign(jwtHeaderPayloadStr, fSecretKey);

        finally
            jwt.free();
        end;
    end;
end.
