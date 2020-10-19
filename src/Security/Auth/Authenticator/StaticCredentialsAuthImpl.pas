{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
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
    CredentialTypes;

type

    (*!------------------------------------------------
     * basic class having capability to authenticate user
     * using simple array of allowed credentials
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStaticCredentialsAuth = class (TInterfacedObject, IAuth)
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
        for indx := 0 to totCred - 1 do
        begin
            with allowedCred[indx] do
            begin
                if (username = authCred.username) and (password = authCred.password) then
                begin
                    result := true;
                    exit;
                end;
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
