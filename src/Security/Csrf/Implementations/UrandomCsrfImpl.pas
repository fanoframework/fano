{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UrandomCsrfImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    CsrfIntf,
    RandomIntf,
    SessionIntf,
    CsrfImpl;

const

    DEFAULT_RANDOM_BYTES_LEN = 32;

type

    (*!------------------------------------------------
     * basic class having capability to
     * generate token to protect Cross-Site Request Forgery
     * (CSRF) attack using random generator
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TUrandomCsrf = class(TCsrf)
    private
        fRandom: IRandom;
        fStrength : integer;
    public

        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param randomInst random value generator
         * @param strength number of random bytes to generate
         *-------------------------------------------------*)
        constructor create(
            const secretKey : string;
            const randomInst : IRandom;
            const strength : integer = DEFAULT_RANDOM_BYTES_LEN
        );

        destructor destroy(); override;

        (*!------------------------------------------------
         * generate token name and value
         *-------------------------------------------------
         * @param tokenName token name
         * @param tokenValue token value
         * @return current instance
         *-------------------------------------------------*)
        function generateToken(out tokenName : string; out tokenValue : string) : ICsrf; override;

    end;

implementation

uses

    SysUtils,
    hmac;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param randomInst random value generator
     * @param strength number of random bytes to generate
     *-------------------------------------------------*)
    constructor TUrandomCsrf.create(
        const secretKey : string;
        const randomInst : IRandom;
        const strength : integer = DEFAULT_RANDOM_BYTES_LEN
    );
    begin
        inherited create(secretKey);
        fRandom := randomInst;
        fStrength := strength;
    end;

    destructor TUrandomCsrf.destroy();
    begin
        fRandom := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * generate token name and value
     *-------------------------------------------------
     * @param tokenName token name
     * @param tokenValue token value
     * @return current instance
     *-------------------------------------------------*)
    function TUrandomCsrf.generateToken(out tokenName : string; out tokenValue : string) : ICsrf;
    var id : TGUID;
        strId : string;
        rndBytes : TBytes;
    begin
        rndBytes := fRandom.randomBytes(fStrength);
        setString(strId, PAnsiChar(@rndBytes[0]), length(rndBytes));
        tokenValue := HMACSHA1(fSecretKey, strId);

        createGUID(id);
        //convert GUID to string and remove { and } part
        tokenName := copy(GUIDToString(id), 2, 36);
        result := self;
    end;

end.
