{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BearerAuthMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    TokenVerifierIntf,
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
    TBearerAuthMiddlewareFactory = class(TFactory)
    private
        fRealm : string;
        fCredentialKey : string;
        fTokenVerifier : ITokenVerifier;
    public
        constructor create();

        function realm(const realmName : string) : TBearerAuthMiddlewareFactory;
        function credentialKey(const keyName : string) : TBearerAuthMiddlewareFactory;
        function verifier(const verifierInst : ITokenVerifier) : TBearerAuthMiddlewareFactory;

        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    BearerAuthMiddlewareImpl,
    JwtTokenVerifierImpl;

    constructor TBearerAuthMiddlewareFactory.create();
    begin
        inherited create();
        fRealm := 'fano';
        fCredentialKey := 'fano_cred';
        fTokenVerifier := nil;
    end;

    function TBearerAuthMiddlewareFactory.realm(const realmName : string) : TBearerAuthMiddlewareFactory;
    begin
        fRealm := realmName;
        result := self;
    end;

    function TBearerAuthMiddlewareFactory.credentialKey(const keyName : string) : TBearerAuthMiddlewareFactory;
    begin
        fCredentialKey := keyName;
        result := self;
    end;

    function TBearerAuthMiddlewareFactory.verifier(const verifierInst : ITokenVerifier) : TBearerAuthMiddlewareFactory;
    begin
        fTokenVerifier := verifierInst;
        result := self;
    end;

    function TBearerAuthMiddlewareFactory.build(
        const container : IDependencyContainer
    ) : IDependency;
    begin
        result := TBearerAuthMiddleware.create(
            fTokenVerifier,
            fRealm,
            fCredentialKey
        );
    end;
end.
