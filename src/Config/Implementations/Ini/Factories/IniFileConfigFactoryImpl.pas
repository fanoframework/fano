unit IniFileConfigFactoryImpl;

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
     * Factory class for TIniFileConfig
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TIniFileConfigFactory = class (TFactory, IDependencyFactory, IConfigFactory)
    private
        configFilename : string;
        fDefaultSection : string;
    public
        constructor create(const configFile :string);
        function setDefaultSection(const defaultSection : string) : TIniFileConfigFactory;

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

    IniFileConfigImpl;

    constructor TIniFileConfigFactory.create(const configFile : string);
    begin
        configFilename := configFile;
        fDefaultSection := 'fano';
    end;

    function TIniFileConfigFactory.setDefaultSection(const defaultSection : string) : TIniFileConfigFactory;
    begin
        fDefaultSection := defaultSection;
        result := self;
    end;

    (*!------------------------------------------------
     * build application configuration instance
     *-------------------------------------------------
     * @return newly created configuration instance
     *-------------------------------------------------*)
    function TIniFileConfigFactory.createConfig(const container : IDependencyContainer) : IAppConfiguration;
    begin
        result := TIniFileConfig.create(configFilename, fDefaultSection);
    end;

    (*!------------------------------------------------
     * build application configuration instance
     *-------------------------------------------------
     * @return newly created configuration instance
     *-------------------------------------------------*)
    function TIniFileConfigFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TIniFileConfig.create(configFilename, fDefaultSection);
    end;
end.
