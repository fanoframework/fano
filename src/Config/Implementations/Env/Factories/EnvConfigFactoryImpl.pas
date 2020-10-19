unit EnvConfigFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    ConfigIntf,
    ConfigFactoryIntf,
    FactoryImpl;

type

    (*!------------------------------------------------------------
     * Factory class for TEnvConfig
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TEnvConfigFactory = class (TFactory, IDependencyFactory, IConfigFactory)
    public
        (*!------------------------------------------------
         * build application configuration instance
         *-------------------------------------------------
         * @return newly created configuration instance
         *-------------------------------------------------*)
        function createConfig(const container : IDependencyContainer) : IAppConfiguration;

        (*!------------------------------------------------
         * build application configuration instance
         *-------------------------------------------------
         * @return newly created configuration instance
         *-------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    EnvConfigImpl;

    (*!------------------------------------------------
     * build application configuration instance
     *-------------------------------------------------
     * @return newly created configuration instance
     *-------------------------------------------------*)
    function TEnvConfigFactory.createConfig(const container : IDependencyContainer) : IAppConfiguration;
    begin
        result := TEnvConfig.create();
    end;

    (*!------------------------------------------------
     * build application configuration instance
     *-------------------------------------------------
     * @return newly created configuration instance
     *-------------------------------------------------*)
    function TEnvConfigFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TEnvConfig.create();
    end;

end.
