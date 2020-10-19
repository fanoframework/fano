{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JwtTokenVerifierImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    fpjwt,
    ListIntf,
    TokenVerifierIntf,
    JwtAlgVerifierIntf,
    VerificationResultTypes,
    InjectableObjectImpl;

type

    //supported JWT algorithm
    TAlgArray = array of IJwtAlgVerifier;

    (*!------------------------------------------------
     * class having capability to verify JWT token validity
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TJwtTokenVerifier = class (TInjectableObject, ITokenVerifier)
    private
        fMetadata : IList;
        fAlgorithms : TAlgArray;
        fSecretKey : string;
        function findAlgoByName(const alg : shortstring) : IJwtAlgVerifier;
        function initAlgorithms(const algos: array of IJwtAlgVerifier) : TAlgArray;
        procedure cleanUpAlgorithms();
        procedure cleanUpMetadata();
    protected
        (*!------------------------------------------------
         * get credential found in verified JWT token
         *-------------------------------------------------
         * @param jose header part of JWT
         * @param claims claim part of JWT
         * @return string of credential
         *-------------------------------------------------
         * we return only subject of JWT claim as credential. If user requires
         * different data, they can override this method and returns what they need.
         *-------------------------------------------------*)
        function getCredential(const jose : TJOSE; const claims: TClaims) : string; virtual;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param metadata lits of additional data for verification
         * @param issuer JWT issuer string
         * @param secretKey secret key used to verify signature
         * @param algos array of supported algorithms
         *-------------------------------------------------*)
        constructor create(
            const metadata : IList;
            const issuer : string;
            const secretKey : string;
            const algos: array of IJwtAlgVerifier
        );

        (*!------------------------------------------------
         * destructor
         *-------------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * verify token
         *-------------------------------------------------
         * @param token token to verify
         * @return TVerificationResult. Field verified will
         *        be true if token is verified and not expired
         *        and issuer match
         *-------------------------------------------------*)
        function verify(const token : string) : TVerificationResult;

        (*!------------------------------------------------
         * set additional data for token verification (if any)
         *-------------------------------------------------
         * @param key name of data to set
         * @param metaData data to set
         *-------------------------------------------------*)
        procedure setData(const key : shortstring; const metaData : string);

        (*!------------------------------------------------
         * get additional data for token verification (if any)
         *-------------------------------------------------
         * @param key name of data to query
         * @@return meta data for key
         *-------------------------------------------------*)
        function getData(const key : shortstring) : string;

        (*!------------------------------------------------
         * test if contain meta data
         *-------------------------------------------------
         * @param key name of data to query
         * @return boolean true if contain key
         *-------------------------------------------------*)
        function has(const key : shortstring) : boolean;

        property data[const key : shortstring] : string read getData write setData; default;
    end;

implementation

uses

    sysutils,
    dateutils,
    base64,
    strutils,
    fpjson,
    JwtConsts,
    EJwtImpl;

type

    TMetadata = record
        strValue : string;
    end;
    PMetadata = ^TMetadata;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param issuer JWT issuer string
     * @param secretKey secret key used to verify signature
     * @param algos array of supported algorithms
     *-------------------------------------------------*)
    constructor TJwtTokenVerifier.create(
        const metadata : IList;
        const issuer : string;
        const secretKey : string;
        const algos: array of IJwtAlgVerifier
    );
    begin
        fMetadata := metadata;
        fSecretKey := secretKey;
        fAlgorithms := initAlgorithms(algos);
        setData(JWT_ISSUER, issuer);
    end;

    (*!------------------------------------------------
     * destructor
     *-------------------------------------------------*)
    destructor TJwtTokenVerifier.destroy();
    begin
        cleanUpMetadata();
        cleanUpAlgorithms();
        fAlgorithms := nil;
        inherited destroy();
    end;

    function TJwtTokenVerifier.initAlgorithms(const algos: array of IJwtAlgVerifier) : TAlgArray;
    var i: integer;
    begin
        setLength(result, high(algos) - low(algos) + 1);
        for i:= low(algos) to high(algos) do
        begin
            result[i] := algos[i];
        end;
    end;

    procedure TJwtTokenVerifier.cleanUpMetadata();
    var i : integer;
        meta : PMetadata;
    begin
        for i := fMetadata.count-1 downto 0 do
        begin
            meta := fMetadata.get(i);
            dispose(meta);
            fMetadata.delete(i);
        end;
    end;

    procedure TJwtTokenVerifier.cleanUpAlgorithms();
    var i : integer;
    begin
        for i := length(fAlgorithms)-1 downto 0 do
        begin
            fAlgorithms[i] := nil;
        end;
    end;

    function TJwtTokenVerifier.findAlgoByName(const alg : shortstring) : IJwtAlgVerifier;
    var i, len : integer;
    begin
        //number of algorithms is very small, sequential search is good enough
        result := nil;
        len := length(fAlgorithms);
        for i := 0 to len-1 do
        begin
            if (alg = fAlgorithms[i].name()) then
            begin
                //algorithm found
                result := fAlgorithms[i];
                break;
            end;
        end;
    end;

    (*!------------------------------------------------
     * get credential found in verified JWT token
     *-------------------------------------------------
     * @param jose header part of JWT
     * @param claims claim part of JWT
     * @return string of credential
     *-------------------------------------------------
     * we return only subject of JWT claim as credential. If user requires
     * different data, they can override this method and returns what they need.
     *-------------------------------------------------*)
    function TJwtTokenVerifier.getCredential(const jose : TJOSE; const claims: TClaims) : string;
    begin
        result := claims.sub;
    end;

    (*!------------------------------------------------
     * verify token
     *-------------------------------------------------
     * @param token token to verify
     * @return TVerificationResult. Field verified will
     *        be true if token is verified and not expired
     *        and issuer match
     *-------------------------------------------------*)
    function TJwtTokenVerifier.verify(const token : string) : TVerificationResult;
    var jwt : TJwt;
        alg : IJwtAlgVerifier;
        aAudience : string;
        aIssuer : string;
        jwtHeaderPayloadStr : string;
    begin
        jwt := TJwt.create();
        try
            try
                //this may raise EJSON when token is not well-formed JWT
                {$IF FPC_FULLVERSION <= 30400}
                    //FPC <= 3.0.4, TJWT.asEncodedString assume base64 decode
                    //while JWT requirse base64url decode. Here we do it manually
                    jwt.JOSE.asString := base64UrlDecode(extractword(1, token, ['.']));
                    jwt.Claims.asString := base64UrlDecode(extractword(2, token, ['.']));
                    jwt.Signature := extractword(3, token, ['.']);
                {$ELSE}
                    jwt.asEncodedString := token;
                {$ENDIF}

                //if we get here, token is well-formed JWT
                alg := findAlgoByName(jwt.JOSE.alg);

                if has(JWT_AUDIENCE) then
                begin
                    aAudience := getData(JWT_AUDIENCE);
                end else
                begin
                    aAudience := '';
                end;

                if has(JWT_ISSUER) then
                begin
                    aIssuer := getData(JWT_ISSUER);
                end else
                begin
                    aIssuer := '';
                end;

                result.credential := '';

                {$IF FPC_FULLVERSION <= 30400}
                    //FPC <= 3.0.4, asEncodedString returns base64 while JWT requires
                    //base64url so we just build our base64url encode manually
                    jwtHeaderPayloadStr := base64UrlEncode(jwt.JOSE.AsString) + '.' +
                        base64UrlEncode(jwt.Claims.AsString);
                {$ELSE}
                    jwtHeaderPayloadStr := jwt.JOSE.AsEncodedString + '.' + jwt.Claims.AsEncodedString;
                {$ENDIF}

                //test if signing algorithm is known, if not, then token is
                //definitely not generated by us or token has been tampered.
                result.verified := (alg <> nil) and

                    //if algorithm is known, check signature
                    alg.verify(
                        jwtHeaderPayloadStr,
                        jwt.Signature,
                        fSecretKey
                    ) and

                    //if signature valid, check if expired
                    ((jwt.Claims.exp = 0) or
                    ((jwt.Claims.exp <> 0) and (jwt.Claims.exp > DateTimeToUnix(Now)))) and

                    //if not expired, check if audience and issuer match
                    (jwt.Claims.aud = aAudience) and
                    (jwt.Claims.iss = aIssuer);

                if result.verified then
                begin
                    result.credential := getCredential(jwt.JOSE, jwt.Claims);
                    setData(JWT_SUBJECT, jwt.Claims.sub);
                end;
            except
                on e : EJSON do
                begin
                    //if we get here, token is not valid JWT
                    result.verified := false;
                    result.credential := '';
                end;
            end;
        finally
            jwt.free();
        end;
    end;

    procedure TJwtTokenVerifier.setData(const key : shortstring; const metaData : string);
    var meta : PMetadata;
    begin
        meta := fMetadata.find(key);
        if (meta = nil) then
        begin
            new(meta);
            fMetadata.add(key, meta);
        end;
        meta^.strValue := metaData;
    end;

    procedure raiseMetadataNotFound(const key : shortstring);
    begin
        raise EJwt.createFmt('Jwt token meta data "%s" not found.', [key]);
    end;

    function TJwtTokenVerifier.getData(const key : shortstring) : string;
    var meta : PMetadata;
    begin
        meta := fMetadata.find(key);
        if meta <> nil then
        begin
            result := meta^.strValue;
        end else
        begin
            raiseMetadataNotFound(key);
            result := '';
        end;
    end;

    (*!------------------------------------------------
     * test if contain meta data
     *-------------------------------------------------
     * @param key name of data to query
     * @return boolean true if contain key
     *-------------------------------------------------*)
    function TJwtTokenVerifier.has(const key : shortstring) : boolean;
    begin
        result := (fMetadata.find(key) <> nil);
    end;
end.
