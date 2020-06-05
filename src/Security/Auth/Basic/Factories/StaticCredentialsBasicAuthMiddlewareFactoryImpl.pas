{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StaticCredentialsBasicAuthMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    CredentialTypes;

type

    (*!------------------------------------------------
     * basic class having capability to create
     * basic auth middleware instance using static array of
     * credentials
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStaticCredentialsBasicAuthMiddlewareFactory = class(TFactory)
    private
        fRealm : string;
        fActualCredentialLen : integer;
        fAllowedCredentials : TCredentials;
    public
        constructor create(const realm : string);

        function addCredential(
            const usrname : string;
            const passw : string
        ) : TStaticCredentialsBasicAuthMiddlewareFactory;

        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    BasicAuthMiddlewareImpl,
    StaticCredentialsAuthImpl;

    constructor TStaticCredentialsBasicAuthMiddlewareFactory.create(const realm : string);
    begin
        inherited create();
        fRealm := realm;
        fActualCredentialLen := 0;
        //preallocated 10 elements
        setlength(fAllowedCredentials, 10);
    end;

    function TStaticCredentialsBasicAuthMiddlewareFactory.addCredential(
        const usrname : string;
        const passw : string
    ) : TStaticCredentialsBasicAuthMiddlewareFactory;
    begin
        if fActualCredentialLen > length(fAllowedCredentials) then
        begin
            //pre-allocated to reduce to improve speed
            setlength(fAllowedCredentials, length(fAllowedCredentials) + 10);
        end;

        with fAllowedCredentials[fActualCredentialLen] do
        begin
            username := usrname;
            password := passw;
        end;

        inc(fActualCredentialLen);

        result := self;
    end;

    function TStaticCredentialsBasicAuthMiddlewareFactory.build(
        const container : IDependencyContainer
    ) : IDependency;
    begin
        setlength(fAllowedCredentials, fActualCredentialLen);
        result := TBasicAuthMiddleware.create(
            TStaticCredentialsAuth.create(fAllowedCredentials),
            fRealm
        );
    end;
end.
