{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ScryptPasswordHashImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    HlpIHash,
    PasswordHashIntf;

type

    (*!------------------------------------------------
     * Scrypt password hash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TScryptPasswordHash = class (TInjectableObject, IPasswordHash)
    private
        fSalt : string;
        fCost : integer;
        fHashLen : integer;
        fBlockSize : integer;
        fParallelism : integer;
    public
        constructor create(
            const defSalt : string = '';
            const defCost : integer = 1024;
            const defLen : integer = 64;
            const defBlockSize : integer = 8;
            const defParallel : integer = 1
        );

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
    HlpIHashInfo;

    constructor TScryptPasswordHash.create(
        const defSalt : string = '';
        const defCost : integer = 1024;
        const defLen : integer = 64;
        const defBlockSize : integer = 8;
        const defParallel : integer = 1
    );
    begin
        fSalt := defSalt;
        fCost := defCost;
        fHashLen := defLen;
        fBlockSize := defBlockSize;
        fParallelism := defParallel;
    end;

    (*!------------------------------------------------
     * set hash generator cost
     *-----------------------------------------------
     * @param algorithmCost cost of hash generator
     * @return current instance
     *-----------------------------------------------*)
    function TScryptPasswordHash.cost(const algorithmCost : integer) : IPasswordHash;
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
    function TScryptPasswordHash.memory(const memCost : integer) : IPasswordHash;
    begin
        fBlockSize := memCost;
        result := self;
    end;

    (*!------------------------------------------------
     * set hash paralleism cost (if applicable)
     *-----------------------------------------------
     * @param paralleismCost cost of paralleisme
     * @return current instance
     *-----------------------------------------------*)
    function TScryptPasswordHash.paralleism(const paralleismCost : integer) : IPasswordHash;
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
    function TScryptPasswordHash.len(const hashLen : integer) : IPasswordHash;
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
    function TScryptPasswordHash.salt(const saltValue : string) : IPasswordHash;
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
    function TScryptPasswordHash.secret(const secretValue : string) : IPasswordHash;
    begin
        //not relevant for Scrypt
        result := self;
    end;

    (*!------------------------------------------------
     * generate password hash
     *-----------------------------------------------
     * @param plainPassw input password
     * @return password hash
     *-----------------------------------------------*)
    function TScryptPasswordHash.hash(const plainPassw : string) : string;
    var
        PBKDF_Scrypt: IPBKDF_Scrypt;
        APasswordBytes, ASaltBytes, OutputBytes: TBytes;
    begin
        APasswordBytes := TConverters.ConvertStringToBytes(
            plainPassw,
            TEncoding.ASCII
        );
        ASaltBytes := TConverters.ConvertStringToBytes(
            fSalt,
            TEncoding.ASCII
        );
        PBKDF_Scrypt := TKDF.TPBKDF_Scrypt.CreatePBKDF_Scrypt(
            APasswordBytes,
            ASaltBytes,
            fCost,
            fBlockSize,
            fParallelism
        );
        OutputBytes := PBKDF_Scrypt.GetBytes(fHashLen);
        PBKDF_Scrypt.Clear();
        result := TConverters.ConvertBytesToHexString(OutputBytes, false);
    end;

    (*!------------------------------------------------
     * verify plain password against password hash
     *-----------------------------------------------
     * @param plainPassw input password
     * @param hashedPassw password hash
     * @return true if password match password hash
     *-----------------------------------------------*)
    function TScryptPasswordHash.verify(
        const plainPassw : string;
        const hashedPasswd : string
    ) : boolean;
    begin
        result := (hash(plainPassw) = hashedPasswd);
    end;
end.
