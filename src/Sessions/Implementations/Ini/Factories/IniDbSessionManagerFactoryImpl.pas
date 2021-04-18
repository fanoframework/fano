{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IniDbSessionManagerFactoryImpl;

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
     * TIniDbSessionManager factory class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TIniDbSessionManagerFactory = class(TDbSessionManagerFactory)
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
    IniSessionFactoryImpl;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TIniDbSessionManagerFactory.build(const container : IDependencyContainer) : IDependency;
    var sessTableInfo : TSessionTableInfo;
    begin
        sessTableInfo := default(TSessionTableInfo);
        sessTableInfo.tableName := fTableName;
        sessTableInfo.sessionIdColumn := fSessionIdColumn;
        sessTableInfo.dataColumn := fDataColumn;
        sessTableInfo.expiredAtColumn := fExpiredAtColumn;
        result := TDbSessionManager.create(
            fSessionIdGenerator,
            TIniSessionFactory.create(),
            fCookieName,
            fRdbms,
            sessTableInfo
        );
    end;
end.
