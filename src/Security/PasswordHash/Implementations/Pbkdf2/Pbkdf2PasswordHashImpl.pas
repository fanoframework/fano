{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Pbkdf2PasswordHashImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    HlpIHash,
    PasswordHashIntf;

type

    (*!------------------------------------------------
     * PBKDF2 password hash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TPBKDF2PasswordHash = class (TInjectableObject, IPasswordHash)
    private
        fHash : IHash;
        fSalt : string;
        fCost : integer;
        fHashLen : integer;
    public
        constructor create(
            const hashInst : IHash;
            const defSalt : string = '';
            const defCost : integer = 1000;
            const defLen : integer = 64
        );
        destructor destroy(); override;

        (*!------------------------------------------------
         * set hash generator cost
         *-----------------------------------------------
         * @param algorithmCost cost of hash generator
         * @return current instance
         *-----------------------------------------------*)
        function cost(const algorithmCost : integer) : IPasswordHash;

        (*!------------------------------------------------
         * set hash memory cost (if applicable)
         *-----------------------------------------------
         * @param memCost cost of memory
         * @return current instance
         *-----------------------------------------------*)
        function memory(const memCost : integer) : IPasswordHash;

        (*!------------------------------------------------
         * set hash paralleism cost (if applicable)
         *-----------------------------------------------
         * @param paralleismCost cost of paralleisme
         * @return current instance
         *-----------------------------------------------*)
        function paralleism(const paralleismCost : integer) : IPasswordHash;

        (*!------------------------------------------------
         * set hash length
         *-----------------------------------------------
         * @param hashLen length of hash
         * @return current instance
         *-----------------------------------------------*)
        function len(const hashLen : integer) : IPasswordHash;

        (*!------------------------------------------------
         * set password salt
         *-----------------------------------------------
         * @param saltValue salt
         * @return current instance
         *-----------------------------------------------*)
        function salt(const saltValue : string) : IPasswordHash;

        (*!------------------------------------------------
         * set secret key
         *-----------------------------------------------
         * @param secretValue a secret value
         * @return current instance
         *-----------------------------------------------*)
        function secret(const secretValue : string) : IPasswordHash;

        (*!------------------------------------------------
         * generate password hash
         *-----------------------------------------------
         * @param plainPassw input password
         * @return password hash
         *-----------------------------------------------*)
        function hash(const plainPassw : string) : string;

        (*!------------------------------------------------
         * verify plain password against password hash
         *-----------------------------------------------
         * @param plainPassw input password
         * @param hashedPassw password hash
         * @return true if password match password hash
         *-----------------------------------------------*)
        function verify(
            const plainPassw : string;
            const hashedPasswd : string
        ) : boolean;
    end;

implementation

uses
    Classes,
    SysUtils,
    HlpHashFactory,
    HlpConverters,
    HlpSHA2_512,
    HlpIHashInfo;

    constructor TPBKDF2PasswordHash.create(
        const hashInst : IHash;
        const defSalt : string = '';
        const defCost : integer = 1000;
        const defLen : integer = 64
    );
    begin
        fHash := hashInst;
        fSalt := defSalt;
        fCost := defCost;
        fHashLen := defLen;
    end;

    destructor TPBKDF2PasswordHash.destroy();
    begin
        fHash := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * set hash generator cost
     *-----------------------------------------------
     * @param algorithmCost cost of hash generator
     * @return current instance
     *-----------------------------------------------*)
    function TPBKDF2PasswordHash.cost(const algorithmCost : integer) : IPasswordHash;
    begin
        fCost := algorithmCost;
        result := self;
    end;

    (*!------------------------------------------------
     * set hash memory cost (if applicable)
     *-----------------------------------------------
     * @param memCost cost of memory
     * @return current instance
     *-----------------------------------------------*)
    function TPBKDF2PasswordHash.memory(const memCost : integer) : IPasswordHash;
    begin
        //do nothing as it is not relevant here
        result := self;
    end;

    (*!------------------------------------------------
     * set hash paralleism cost (if applicable)
     *-----------------------------------------------
     * @param paralleismCost cost of paralleisme
     * @return current instance
     *-----------------------------------------------*)
    function TPBKDF2PasswordHash.paralleism(const paralleismCost : integer) : IPasswordHash;
    begin
        //do nothing as it is not relevant here
        result := self;
    end;

    (*!------------------------------------------------
     * set hash length
     *-----------------------------------------------
     * @param hashLen length of hash
     * @return current instance
     *-----------------------------------------------*)
    function TPBKDF2PasswordHash.len(const hashLen : integer) : IPasswordHash;
    begin
        fHashLen := hashLen;
        result := self;
    end;

    (*!------------------------------------------------
     * set password salt
     *-----------------------------------------------
     * @param salt
     * @return current instance
     *-----------------------------------------------*)
    function TPBKDF2PasswordHash.salt(const saltValue : string) : IPasswordHash;
    begin
        fSalt := saltValue;
        result := self;
    end;

    (*!------------------------------------------------
     * set secret key
     *-----------------------------------------------
     * @param secretValue a secret value
     * @return current instance
     *-----------------------------------------------*)
    function TPBKDF2PasswordHash.secret(const secretValue : string) : IPasswordHash;
    begin
        //not relevant for PBKDF2_HMAC
        result := self;
    end;

    (*!------------------------------------------------
     * generate password hash
     *-----------------------------------------------
     * @param plainPassw input password
     * @return password hash
     *-----------------------------------------------*)
    function TPBKDF2PasswordHash.hash(const plainPassw : string) : string;
    var
        BytePassword, ByteSalt: TBytes;
        PBKDF2_HMACInstance: IPBKDF2_HMAC;
    begin
        BytePassword := TConverters.ConvertStringToBytes(plainPassw, TEncoding.UTF8);
        ByteSalt := TConverters.ConvertStringToBytes(fSalt, TEncoding.UTF8);

        PBKDF2_HMACInstance := TKDF.TPBKDF2_HMAC.CreatePBKDF2_HMAC(
            fHash,
            BytePassword,
            ByteSalt,
            fCost
        );

        result := TConverters.ConvertBytesToHexString(
            PBKDF2_HMACInstance.GetBytes(fHashLen),
            false
        );
    end;

    (*!------------------------------------------------
     * verify plain password against password hash
     *-----------------------------------------------
     * @param plainPassw input password
     * @param hashedPassw password hash
     * @return true if password match password hash
     *-----------------------------------------------*)
    function TPBKDF2PasswordHash.verify(
        const plainPassw : string;
        const hashedPasswd : string
    ) : boolean;
    begin
        result := (hash(plainPassw) = hashedPasswd);
    end;
end.
