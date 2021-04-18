{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StaticPasswHashAuthImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf,
    AuthIntf,
    PasswordHashIntf,
    CredentialTypes,
    StaticCredentialsAuthImpl;

type

    (*!------------------------------------------------
     * basic class having capability to authenticate user
     * using simple array of allowed credentials with password hash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStaticPasswHashAuth = class (TStaticCredentialsAuth)
    private
        fPasswHash : IPasswordHash;
    protected
        (*!------------------------------------------------
         * verify credential against stored credential
         *-------------------------------------------------
         * @param authCred credential to check
         * @param allowedCred stored credential
         * @return boolean true if verified
         *-------------------------------------------------*)
        function verifyCredential(
            const authCred : TCredential;
            const allowedCred : TCredential
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param allowedCred array of allowed credentials
         *-------------------------------------------------*)
        constructor create(
            const allowedCred : TCredentials;
            const passwHash : IPasswordHash
        );

        (*!------------------------------------------------
         * destructor
         *-------------------------------------------------*)
        destructor destroy(); override;

    end;

implementation

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param allowedCred array of allowed credentials
     *-------------------------------------------------*)
    constructor TStaticPasswHashAuth.create(
        const allowedCred : TCredentials;
        const passwHash : IPasswordHash
    );
    begin
        inherited create(allowedCred);
        fPasswHash := passwHash;
    end;

    (*!------------------------------------------------
     * destructor
     *-------------------------------------------------*)
    destructor TStaticPasswHashAuth.destroy();
    begin
        fPasswHash := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * verify credential against stored credential
     *-------------------------------------------------
     * @param authCred credential to check
     * @param allowedCred stored credential
     * @return boolean true if verified
     *-------------------------------------------------*)
    function TStaticPasswHashAuth.verifyCredential(
        const authCred : TCredential;
        const allowedCred : TCredential
    ) : boolean;
    begin
        fPasswHash.salt(allowedCred.salt);
        result := (authCred.username = allowedCred.username) and
            fPasswHash.verify(authCred.password, allowedCred.password);
    end;

end.
