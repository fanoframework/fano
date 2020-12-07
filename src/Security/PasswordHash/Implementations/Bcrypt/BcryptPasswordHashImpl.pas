{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BcryptPasswordHashImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    PasswordHashIntf,
    BCryptConsts,
    BCryptTypes;

type

    (*!------------------------------------------------
     * Bcrypt password hash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TBcryptPasswordHash = class (TInjectableObject, IPasswordHash)
    private
        fHashType : THashType;
        fCost : byte;
    public
        constructor create(
            const hashType : THashType = BSD;
            const defCost : byte = BCRYPT_DEFAULT_COST
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
    BCrypt;

    constructor TBcryptPasswordHash.create(
        const hashType : THashType = BSD;
        const defCost : byte = BCRYPT_DEFAULT_COST
    );
    begin
        fHashType := hashType;
        fCost := defCost;
    end;

    (*!------------------------------------------------
     * set hash generator cost
     *-----------------------------------------------
     * @param algorithmCost cost of hash generator
     * @return current instance
     *-----------------------------------------------*)
    function TBcryptPasswordHash.cost(const algorithmCost : integer) : IPasswordHash;
    begin
        //BCrypt use byte for cost, so need explicit typecast.
        fCost := byte(algorithmCost);
        result := self;
    end;

    (*!------------------------------------------------
     * set hash memory cost (if applicable)
     *-----------------------------------------------
     * @param memCost cost of memory
     * @return current instance
     *-----------------------------------------------*)
    function TBcryptPasswordHash.memory(const memCost : integer) : IPasswordHash;
    begin
        //not relevant for Bcrypt
        result := self;
    end;

    (*!------------------------------------------------
     * set hash paralleism cost (if applicable)
     *-----------------------------------------------
     * @param paralleismCost cost of paralleisme
     * @return current instance
     *-----------------------------------------------*)
    function TBcryptPasswordHash.paralleism(const paralleismCost : integer) : IPasswordHash;
    begin
        //not relevant for Bcrypt
        result := self;
    end;

    (*!------------------------------------------------
     * set hash length
     *-----------------------------------------------
     * @param hashLen length of hash
     * @return current instance
     *-----------------------------------------------*)
    function TBcryptPasswordHash.len(const hashLen : integer) : IPasswordHash;
    begin
        //not relevant for Bcrypt
        result := self;
    end;

    (*!------------------------------------------------
     * set password salt
     *-----------------------------------------------
     * @param salt
     * @return current instance
     *-----------------------------------------------*)
    function TBcryptPasswordHash.salt(const saltValue : string) : IPasswordHash;
    begin
        //not relevant for Bcrypt as salt is generated automatically
        result := self;
    end;

    (*!------------------------------------------------
     * set secret key
     *-----------------------------------------------
     * @param secretValue a secret value
     * @return current instance
     *-----------------------------------------------*)
    function TBcryptPasswordHash.secret(const secretValue : string) : IPasswordHash;
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
    function TBcryptPasswordHash.hash(const plainPassw : string) : string;
    begin
        result := TBCrypt.GenerateHash(plainPassw, fCost, fHashType);
    end;

    (*!------------------------------------------------
     * verify plain password against password hash
     *-----------------------------------------------
     * @param plainPassw input password
     * @param hashedPassw password hash
     * @return true if password match password hash
     *-----------------------------------------------*)
    function TBcryptPasswordHash.verify(
        const plainPassw : string;
        const hashedPasswd : string
    ) : boolean;
    begin
        result := TBCrypt.CompareHash(plainPassw, hashedPasswd);
    end;
end.
