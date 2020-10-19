{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractPasswHashAuthImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    AuthIntf,
    PasswordHashIntf,
    CredentialTypes,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * abstract class having capability to authenticate user
     * using password hash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAbstractPasswHashAuth = class abstract (TInjectableObject, IAuth)
    private

        (*!------------------------------------------------
         * password hash verifier
         *-------------------------------------------------*)
        fPasswHash: IPasswordHash;

    protected

        (*!------------------------------------------------
         * retrieve password hash and salt from storage using
         * credential
         *-------------------------------------------------
         * @param credential username/user id to get password hash/salt
         * @return credentialFound credential found in storage or not
         * @return passwHash hash password
         * @return passwSalt salt password
         *-------------------------------------------------*)
        procedure retrieveHashSaltFromStorage(
            const credential : string;
            out credentialFound : boolean;
            out passwHash : string;
            out passwSalt : string
        ); virtual; abstract;

    public

        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param passwHash password hash verifier
         *-------------------------------------------------*)
        constructor create(const passwHash : IPasswordHash);

        (*!------------------------------------------------
         * destructor
         *-------------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * authenticate credential
         *-------------------------------------------------
         * @param credential credential to authenticate
         * @return boolean true if credential is authenticated
         *-------------------------------------------------*)
        function auth(const credential : TCredential) : boolean;

    end;

implementation

uses

    EAuthImpl;

resourcestring

    rsAuthPasswHashNil = 'Password hash can not be nil';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param passwHash password hash verifier
     *-------------------------------------------------*)
    constructor TAbstractPasswHashAuth.create(const passwHash : IPasswordHash);
    begin
        fPasswHash := passwHash;

        if fPasswHash = nil then
        begin
            raise EAuth.create(rsAuthPasswHashNil);
        end;
    end;

    (*!------------------------------------------------
     * destructor
     *-------------------------------------------------*)
    destructor TAbstractPasswHashAuth.destroy();
    begin
        fPasswHash := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * authenticate credential
     *-------------------------------------------------
     * @param credential credential to authenticate
     * @return boolean true if credential is authenticated
     *-------------------------------------------------*)
    function TAbstractPasswHashAuth.auth(const credential : TCredential) : boolean;
    var credentialFound : boolean;
        passwHash : string;
        passwSalt : string;
    begin
        retrieveHashSaltFromStorage(
            credential.username,
            credentialFound,
            passwHash,
            passwSalt
        );
        result := credentialFound;
        if credentialFound then
        begin
            fPasswHash.salt(passwSalt);
            result := fPasswHash.verify(credential.password, passwHash);
        end;
    end;


end.
