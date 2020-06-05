{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Argon2iPasswordHashImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    PasswordHashIntf,
    HlpIHashInfo,
    HlpArgon2TypeAndVersion;

type

    (*!------------------------------------------------
     * Argon2i password hash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TArgon2iPasswordHash = class (TInjectableObject, IPasswordHash)
    private
        fSalt : string;
        fCost : integer;
        fHashLen : integer;
        fSecret : string;
        fMemoryAsKB : integer;
        fParallelism : integer;
        fArgon2Version : TArgon2Version;
        fArgon2ParametersBuilder : IArgon2ParametersBuilder;
    public
        constructor create(
            const defSecret : string;
            const defSalt : string = '';
            const defCost : integer = 10;
            const defLen : integer = 64;
            const defMemAsKb : integer = 32;
            const defParallel : integer = 4
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
    HlpIHash,
    HlpHashFactory,
    HlpConverters,
    HlpPBKDF_Argon2NotBuildInAdapter;

    constructor TArgon2iPasswordHash.create(
        const defSecret : string;
        const defSalt : string = '';
        const defCost : integer = 10;
        const defLen : integer = 64;
        const defMemAsKb : integer = 32;
        const defParallel : integer = 4
    );
    begin
        fSecret := defSecret;
        fSalt := defSalt;
        fCost := defCost;
        fHashLen := defLen;
        fMemoryAsKB := defMemAsKb;
        fParallelism := defParallel;
        fArgon2Version := TArgon2Version.a2vARGON2_VERSION_10;
        fArgon2ParametersBuilder := TArgon2iParametersBuilder.Builder();
    end;

    destructor TArgon2iPasswordHash.destroy();
    begin
        fArgon2ParametersBuilder := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * set hash generator cost
     *-----------------------------------------------
     * @param algorithmCost cost of hash generator
     * @return current instance
     *-----------------------------------------------*)
    function TArgon2iPasswordHash.cost(const algorithmCost : integer) : IPasswordHash;
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
    function TArgon2iPasswordHash.memory(const memCost : integer) : IPasswordHash;
    begin
        fMemoryAsKB := memCost;
        result := self;
    end;

    (*!------------------------------------------------
     * set hash paralleism cost (if applicable)
     *-----------------------------------------------
     * @param paralleismCost cost of paralleisme
     * @return current instance
     *-----------------------------------------------*)
    function TArgon2iPasswordHash.paralleism(const paralleismCost : integer) : IPasswordHash;
    begin
        fParallelism := paralleismCost;
        result := self;
    end;

    (*!------------------------------------------------
     * set hash length
     *-----------------------------------------------
     * @param hashLen length of hash
     * @return current instance
     *-----------------------------------------------*)
    function TArgon2iPasswordHash.len(const hashLen : integer) : IPasswordHash;
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
    function TArgon2iPasswordHash.salt(const saltValue : string) : IPasswordHash;
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
    function TArgon2iPasswordHash.secret(const secretValue : string) : IPasswordHash;
    begin
        fSecret := secretValue;
        result := self;
    end;

    (*!------------------------------------------------
     * generate password hash
     *-----------------------------------------------
     * @param plainPassw input password
     * @return password hash
     *-----------------------------------------------*)
    function TArgon2iPasswordHash.hash(const plainPassw : string) : string;
    var
        LGenerator: IPBKDF_Argon2;
        LActual: String;
        LAdditional, LSecret, LSalt, LPassword: TBytes;
        LArgon2Parameter: IArgon2Parameters;
    begin

        LSecret := TConverters.ConvertHexStringToBytes(fSecret);
        LSalt := TConverters.ConvertHexStringToBytes(fSalt);
        LPassword := TConverters.ConvertHexStringToBytes(plainPassw);

        fArgon2ParametersBuilder.WithVersion(fArgon2Version)
            .WithIterations(fCost)
            .WithMemoryAsKB(fMemoryAsKB)
            .WithParallelism(fParallelism)
            .WithSecret(LSecret)
            .WithSalt(LSalt);

        //
        // Set the password.
        //
        LArgon2Parameter := fArgon2ParametersBuilder.Build();
        fArgon2ParametersBuilder.Clear();
        LGenerator := TKDF.TPBKDF_Argon2.CreatePBKDF_Argon2(
            LPassword,
            LArgon2Parameter
        );

        result := TConverters.ConvertBytesToHexString(
            LGenerator.GetBytes(fHashLen),
            false
        );

        LArgon2Parameter.Clear();
        LGenerator.Clear();
    end;

    (*!------------------------------------------------
     * verify plain password against password hash
     *-----------------------------------------------
     * @param plainPassw input password
     * @param hashedPassw password hash
     * @return true if password match password hash
     *-----------------------------------------------*)
    function TArgon2iPasswordHash.verify(
        const plainPassw : string;
        const hashedPasswd : string
    ) : boolean;
    begin
        result := (hash(plainPassw) = hashedPasswd);
    end;
end.
