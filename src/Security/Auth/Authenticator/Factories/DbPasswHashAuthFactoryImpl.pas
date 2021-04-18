{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DbPasswHashAuthFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    PasswordHashIntf,
    RdbmsIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * basic class having capability to create
     * basic auth middleware instance using credentials
     * stored in database
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TDbPasswHashAuthFactory = class(TFactory)
    private
        fPasswordHash : IPasswordHash;
        fRdbms : IRdbms;
        fTableName : shortstring;
        fCredentialColumn : shortstring;
        fPasswHashColumn : shortstring;
        fPasswSaltColumn : shortstring;
    public
        constructor create();

        function passwHash(const passw : IPasswordHash) : TDbPasswHashAuthFactory;
        function rdbms(const rdbmsInst : IRdbms) : TDbPasswHashAuthFactory;
        function table(const tableName : shortstring) : TDbPasswHashAuthFactory;
        function credentialColumn(const credCol : shortstring) : TDbPasswHashAuthFactory;
        function passwHashColumn(const pwHashCol : shortstring) : TDbPasswHashAuthFactory;
        function passwSaltColumn(const pwSaltCol : shortstring) : TDbPasswHashAuthFactory;

        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    DbPasswHashAuthImpl,
    EAuthImpl;

    constructor TDbPasswHashAuthFactory.create();
    begin
        inherited create();
        fPasswordHash := nil;
        fRdbms := nil;
        fTableName := 'users';
        fCredentialColumn := 'username';
        fPasswHashColumn := 'password';
        fPasswSaltColumn := 'salt';
    end;

    function TDbPasswHashAuthFactory.passwHash(const passw : IPasswordHash) : TDbPasswHashAuthFactory;
    begin
        fPasswordHash := passw;
        result := self;
    end;

    function TDbPasswHashAuthFactory.rdbms(const rdbmsInst : IRdbms) : TDbPasswHashAuthFactory;
    begin
        fRdbms := rdbmsInst;
        result := self;
    end;

    function TDbPasswHashAuthFactory.table(const tableName : shortstring) : TDbPasswHashAuthFactory;
    begin
        fTableName := tableName;
        result := self;
    end;

    function TDbPasswHashAuthFactory.credentialColumn(const credCol : shortstring) : TDbPasswHashAuthFactory;
    begin
        fCredentialColumn := credCol;
        result := self;
    end;

    function TDbPasswHashAuthFactory.passwHashColumn(const pwHashCol : shortstring) : TDbPasswHashAuthFactory;
    begin
        fPasswHashColumn := pwHashCol;
        result := self;
    end;

    function TDbPasswHashAuthFactory.passwSaltColumn(const pwSaltCol : shortstring) : TDbPasswHashAuthFactory;
    begin
        fPasswSaltColumn := pwSaltCol;
        result := self;
    end;

    function TDbPasswHashAuthFactory.build(
        const container : IDependencyContainer
    ) : IDependency;
    begin
        result := TDbPasswHashAuth.create(
            fPasswordHash,
            fRdbms,
            fTableName,
            fCredentialColumn,
            fPasswHashColumn,
            fPasswSaltColumn
        );
    end;
end.
