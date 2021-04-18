{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IniFileSessionManagerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    SessionConsts,
    SessionIdGeneratorFactoryIntf,
    AbstractSessionManagerFactoryImpl;

type
    (*!------------------------------------------------
     * TIniFileSessionManager factory class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TIniFileSessionManagerFactory = class(TAbstractSessionManagerFactory)
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
    FileSessionManagerImpl,
    IniSessionFactoryImpl;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TIniFileSessionManagerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TFileSessionManager.create(
            fSessionIdGeneratorFactory.build(),
            TIniSessionFactory.create(),
            fCookieName,
            TStringFileReader.create(),
            fBaseDir,
            fPrefix
        );
    end;
end.
