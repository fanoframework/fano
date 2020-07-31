{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonFileSessionManagerFactoryImpl;

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
     * TJsonFileSessionManager factory class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TJsonFileSessionManagerFactory = class(TAbstractSessionManagerFactory)
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
    JsonSessionFactoryImpl;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TJsonFileSessionManagerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TFileSessionManager.create(
            fSessionIdGeneratorFactory.build(),
            TJsonSessionFactory.create(),
            fCookieName,
            TStringFileReader.create(),
            fBaseDir,
            fPrefix
        );
    end;
end.
