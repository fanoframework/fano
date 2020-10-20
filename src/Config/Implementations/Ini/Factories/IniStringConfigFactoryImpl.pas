unit IniStringConfigFactoryImpl;

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
     * Factory class for TJsonStringConfig
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TIniStringConfigFactory = class (TFactory, IDependencyFactory, IConfigFactory)
    private
        fConfigStr : string;
        fDefaultSection : string;
    public
        constructor create(const configStr :string);
        function setDefaultSection(const defaultSection : string) : TIniStringConfigFactory;

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

    IniStringConfigImpl;

    constructor TIniStringConfigFactory.create(const configStr : string);
    begin
        fConfigStr := configStr;
        fDefaultSection := 'fano';
    end;

    function TIniStringConfigFactory.setDefaultSection(const defaultSection : string) : TIniStringConfigFactory;
    begin
        fDefaultSection := defaultSection;
        result := self;
    end;

    (*!------------------------------------------------
     * build application configuration instance
     *-------------------------------------------------
     * @return newly created configuration instance
     *-------------------------------------------------*)
    function TIniStringConfigFactory.createConfig(const container : IDependencyContainer) : IAppConfiguration;
    begin
        result := TIniStringConfig.create(fConfigStr, fDefaultSection);
    end;

    function TIniStringConfigFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TIniStringConfig.create(fConfigStr, fDefaultSection);
    end;

end.
