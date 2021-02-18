{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonDbSessionManagerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    SessionConsts,
    SessionIdGeneratorFactoryIntf,
    DbSessionManagerFactoryImpl;

type
    (*!------------------------------------------------
     * TJsonDbSessionManager factory class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TJsonDbSessionManagerFactory = class(TDbSessionManagerFactory)
    public
        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *----------------------------------------------------
         * This is implementation of IDependencyFactory
         *---------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    StringFileReaderImpl,
    DbSessionManagerImpl,
    JsonSessionFactoryImpl;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TJsonDbSessionManagerFactory.build(const container : IDependencyContainer) : IDependency;
    var sessTableInfo : TSessionTableInfo;
    begin
        sessTableInfo := default(TSessionTableInfo);
        sessTableInfo.tableName := fTableName;
        sessTableInfo.sessionIdColumn := fSessionIdColumn;
        sessTableInfo.dataColumn := fDataColumn;
        sessTableInfo.expiredAtColumn := fExpiredAtColumn;
        result := TDbSessionManager.create(
            fSessionIdGenerator,
            TJsonSessionFactory.create(),
            fCookieName,
            fRdbms,
            sessTableInfo
        );
    end;
end.
