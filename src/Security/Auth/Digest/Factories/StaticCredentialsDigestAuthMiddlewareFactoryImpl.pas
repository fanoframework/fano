{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StaticCredentialsDigestAuthMiddlewareFactoryImpl;

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
    TStaticCredentialsDigestAuthMiddlewareFactory = class(TFactory)
    private
        fRealm : string;
        fActualCredentialLen : integer;
        fAllowedCredentials : TCredentials;
    public
        constructor create(const realm : string);

        function addCredential(
            const usrname : string;
            const passw : string
        ) : TStaticCredentialsDigestAuthMiddlewareFactory;

        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    DevUrandomImpl,
    DigestAuthMiddlewareImpl,
    DigestStaticCredentialsAuthImpl;

    constructor TStaticCredentialsDigestAuthMiddlewareFactory.create(const realm : string);
    begin
        inherited create();
        fRealm := realm;
        fActualCredentialLen := 0;
        //preallocated 10 elements
        setlength(fAllowedCredentials, 10);
    end;

    function TStaticCredentialsDigestAuthMiddlewareFactory.addCredential(
        const usrname : string;
        const passw : string
    ) : TStaticCredentialsDigestAuthMiddlewareFactory;
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

    function TStaticCredentialsDigestAuthMiddlewareFactory.build(
        const container : IDependencyContainer
    ) : IDependency;
    begin
        setlength(fAllowedCredentials, fActualCredentialLen);
        result := TDigestAuthMiddleware.create(
            TDevUrandom.create(),
            TDigestStaticCredentialsAuth.create(fAllowedCredentials),
            fRealm
        );
    end;
end.
