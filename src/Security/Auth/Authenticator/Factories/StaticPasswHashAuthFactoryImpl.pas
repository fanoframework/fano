{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StaticPasswHashAuthFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    PasswordHashIntf,
    CredentialTypes,
    FactoryImpl;

type

    (*!------------------------------------------------
     * basic class having capability to create
     * basic auth middleware instance using static array of
     * credentials
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStaticPasswHashAuthFactory = class(TFactory)
    private
        fPasswordHash : IPasswordHash;
        fActualCredentialLen : integer;
        fAllowedCredentials : TCredentials;
    public
        constructor create();

        function passwHash(const passw : IPasswordHash) : TStaticPasswHashAuthFactory;

        function addCredential(
            const usrname : string;
            const passw : string;
            const asalt : string
        ) : TStaticPasswHashAuthFactory;

        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    StaticPasswHashAuthImpl;

    constructor TStaticPasswHashAuthFactory.create();
    begin
        inherited create();
        fPasswordHash := nil;
        fActualCredentialLen := 0;
        //preallocated 10 elements
        setlength(fAllowedCredentials, 10);
    end;

    function TStaticPasswHashAuthFactory.passwHash(const passw : IPasswordHash) : TStaticPasswHashAuthFactory;
    begin
        fPasswordHash := passw;
        result := self;
    end;

    function TStaticPasswHashAuthFactory.addCredential(
        const usrname : string;
        const passw : string;
        const asalt : string
    ) : TStaticPasswHashAuthFactory;
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
            salt := asalt;
        end;

        inc(fActualCredentialLen);

        result := self;
    end;

    function TStaticPasswHashAuthFactory.build(
        const container : IDependencyContainer
    ) : IDependency;
    begin
        setlength(fAllowedCredentials, fActualCredentialLen);
        result := TStaticPasswHashAuth.create(
            fAllowedCredentials,
            fPasswordHash
        );
    end;
end.
