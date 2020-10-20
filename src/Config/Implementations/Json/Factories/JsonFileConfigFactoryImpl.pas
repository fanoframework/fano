unit JsonFileConfigFactoryImpl;

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
     * Factory class for TJsonFileConfig
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TJsonFileConfigFactory = class (TFactory, IDependencyFactory, IConfigFactory)
    private
        configFilename : string;
    public
        constructor create(const configFile :string);

        (*!------------------------------------------------
         * build application configuration instance
         *-------------------------------------------------
         * @return newly created configuration instance
         *-------------------------------------------------*)
        function createConfig(const container : IDependencyContainer) : IAppConfiguration;

        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    JsonFileConfigImpl;

    constructor TJsonFileConfigFactory.create(const configFile : string);
    begin
        configFilename := configFile;
    end;

    (*!------------------------------------------------
     * build application configuration instance
     *-------------------------------------------------
     * @return newly created configuration instance
     *-------------------------------------------------*)
    function TJsonFileConfigFactory.createConfig(const container : IDependencyContainer) : IAppConfiguration;
    begin
        result := TJsonFileConfig.create(configFilename);
    end;

    function TJsonFileConfigFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TJsonFileConfig.create(configFilename);
    end;

end.
