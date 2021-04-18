{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DbSessionManagerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    SessionConsts,
    RdbmsIntf,
    SessionIdGeneratorIntf;

type
    (*!------------------------------------------------
     * TDbSessionManager factory class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDbSessionManagerFactory = class abstract (TFactory)
    protected
        fCookieName : string;
        fSessionIdGenerator : ISessionIdGenerator;
        fRdbms : IRdbms;
        fTableName : string;
        fSessionIdColumn : string;
        fDataColumn : string;
        fExpiredAtColumn : string;
    public
        constructor create(const rdbms : IRdbms; const cookieName : string = FANO_COOKIE_NAME);
        destructor destroy(); override;

        function sessionIdGenerator(const sessIdGen : ISessionIdGenerator) : TDbSessionManagerFactory;

        function table(const tableName : string) : TDbSessionManagerFactory;
        function sessionIdColumn(const sessionIdName : string) : TDbSessionManagerFactory;
        function dataColumn(const dataName : string) : TDbSessionManagerFactory;
        function expiredAtColumn(const expiredAtName : string) : TDbSessionManagerFactory;
    end;

implementation

uses

    GuidSessionIdGeneratorImpl;

    constructor TDbSessionManagerFactory.create(
        const rdbms : IRdbms;
        const cookieName : string = FANO_COOKIE_NAME
    );
    begin
        fRdbms := rdbms;
        fSessionIdGenerator := TGuidSessionIdGenerator.create();
        fCookieName := cookieName;
        fTableName := DEFAULT_SESS_TABLE_NAME;
        fSessionIdColumn := DEFAULT_SESS_ID_COLUMN;
        fDataColumn := DEFAULT_DATA_COLUMN;
        fExpiredAtColumn := DEFAULT_EXPIRED_AT_COLUMN;
    end;

    destructor TDbSessionManagerFactory.destroy();
    begin
        fRdbms := nil;
        fSessionIdGenerator := nil;
        inherited destroy();
    end;

    function TDbSessionManagerFactory.sessionIdGenerator(const sessIdGen : ISessionIdGenerator) : TDbSessionManagerFactory;
    begin
        fSessionIdGenerator := sessIdGen;
        result := self;
    end;

    function TDbSessionManagerFactory.table(const tableName : string) : TDbSessionManagerFactory;
    begin
        fTableName := tableName;
        result := self;
    end;

    function TDbSessionManagerFactory.sessionIdColumn(const sessionIdName : string) : TDbSessionManagerFactory;
    begin
        fSessionIdColumn := sessionIdName;
        result := self;
    end;

    function TDbSessionManagerFactory.dataColumn(const dataName : string) : TDbSessionManagerFactory;
    begin
        fDataColumn := dataName;
        result := self;
    end;

    function TDbSessionManagerFactory.expiredAtColumn(const expiredAtName : string) : TDbSessionManagerFactory;
    begin
        fExpiredAtColumn := expiredAtName;
        result := self;
    end;
end.
