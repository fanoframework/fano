{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StaticCredentialsAuthImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf,
    AuthIntf,
    CredentialTypes,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * basic class having capability to authenticate user
     * using simple array of allowed credentials
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------
     * Note: Not very suitable for very large arrays
     * as it searches credentials sequentially
     *-------------------------------------------------*)
    TStaticCredentialsAuth = class (TInjectableObject, IAuth)
    private
        fAllowedCredentials : TCredentials;

        (*!------------------------------------------------
         * test if a credential is in allowed credentials list
         *-------------------------------------------------
         * @param authCred credential to check
         * @param allowedCred array of allowed credentials
         * @return boolean true if credential is in allowed credentials
         *-------------------------------------------------*)
        function isAllowedCredential(
            const authCred : TCredential;
            const allowedCred : TCredentials
        ) : boolean;
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
        ) : boolean; virtual;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param allowedCred array of allowed credentials
         *-------------------------------------------------*)
        constructor create(const allowedCred : TCredentials);

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

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param allowedCred array of allowed credentials
     *-------------------------------------------------*)
    constructor TStaticCredentialsAuth.create(const allowedCred : TCredentials);
    begin
        fAllowedCredentials := allowedCred;
    end;

    (*!------------------------------------------------
     * destructor
     *-------------------------------------------------*)
    destructor TStaticCredentialsAuth.destroy();
    begin
        fAllowedCredentials := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * verify credential against stored credential
     *-------------------------------------------------
     * @param authCred credential to check
     * @param allowedCred stored credential
     * @return boolean true if verified
     *-------------------------------------------------*)
    function TStaticCredentialsAuth.verifyCredential(
        const authCred : TCredential;
        const allowedCred : TCredential
    ) : boolean;
    begin
        result := (authCred.username = allowedCred.username) and
            (authCred.password = allowedCred.password);
    end;

    (*!------------------------------------------------
     * test if a credential is in allowed credentials list
     *-------------------------------------------------
     * @param authCred credential to check
     * @param allowedCred array of allowed credentials
     * @return boolean true if credential is in allowed credentials
     *-------------------------------------------------*)
    function TStaticCredentialsAuth.isAllowedCredential(
        const authCred : TCredential;
        const allowedCred : TCredentials
    ) : boolean;
    var indx, totCred : integer;
    begin
        result := false;
        totCred := length(allowedCred);
        //sequentially find match credential. Performance is bad when array is big
        for indx := 0 to totCred - 1 do
        begin
            if verifyCredential(authCred, allowedCred[indx]) then
            begin
                result := true;
                exit;
            end;
        end;
    end;

    (*!------------------------------------------------
     * authenticate credential
     *-------------------------------------------------
     * @param credential credential to authenticate
     * @return boolean true if credential is authenticated
     *-------------------------------------------------*)
    function TStaticCredentialsAuth.auth(const credential : TCredential) : boolean;
    begin
        result := isAllowedCredential(credential, fAllowedCredentials);
    end;

end.
