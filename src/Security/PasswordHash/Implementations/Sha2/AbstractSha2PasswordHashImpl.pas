{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractSha2PasswordHashImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    PasswordHashIntf;

type

    (*!------------------------------------------------
     * base abstract SHA2 password hash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractSHA2PasswordHash = class abstract (TInjectableObject, IPasswordHash)
    private
        fSalt : string;
    public
        constructor create(const defSalt : string = '');

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
        function hash(const plainPassw : string) : string; virtual; abstract;

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

    constructor TAbstractSHA2PasswordHash.create(const defSalt : string = '');
    begin
        fSalt := defSalt;
    end;

    (*!------------------------------------------------
     * set hash generator cost
     *-----------------------------------------------
     * @param algorithmCost cost of hash generator
     * @return current instance
     *-----------------------------------------------*)
    function TAbstractSHA2PasswordHash.cost(const algorithmCost : integer) : IPasswordHash;
    begin
        //do nothing as it is not relevant here
        result := self;
    end;

    (*!------------------------------------------------
     * set hash memory cost (if applicable)
     *-----------------------------------------------
     * @param memCost cost of memory
     * @return current instance
     *-----------------------------------------------*)
    function TAbstractSHA2PasswordHash.memory(const memCost : integer) : IPasswordHash;
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
    function TAbstractSHA2PasswordHash.paralleism(const paralleismCost : integer) : IPasswordHash;
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
    function TAbstractSHA2PasswordHash.len(const hashLen : integer) : IPasswordHash;
    begin
        //do nothing as it is not relevant here
        result := self;
    end;

    (*!------------------------------------------------
     * set password salt
     *-----------------------------------------------
     * @param salt
     * @return current instance
     *-----------------------------------------------*)
    function TAbstractSHA2PasswordHash.salt(const saltValue : string) : IPasswordHash;
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
    function TAbstractSHA2PasswordHash.secret(const secretValue : string) : IPasswordHash;
    begin
        //not relevant
        result := self;
    end;

    (*!------------------------------------------------
     * verify plain password against password hash
     *-----------------------------------------------
     * @param plainPassw input password
     * @param hashedPassw password hash
     * @return true if password match password hash
     *-----------------------------------------------*)
    function TAbstractSHA2PasswordHash.verify(
        const plainPassw : string;
        const hashedPasswd : string
    ) : boolean;
    begin
        result := (hash(plainPassw) = hashedPasswd);
    end;
end.
