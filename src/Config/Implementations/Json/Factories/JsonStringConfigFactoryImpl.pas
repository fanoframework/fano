unit JsonStringConfigFactoryImpl;

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
    TJsonStringConfigFactory = class (TFactory, IDependencyFactory, IConfigFactory)
    private
        fConfigStr : string;
    public
        constructor create(const configStr :string);

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

    JsonStringConfigImpl;

    constructor TJsonStringConfigFactory.create(const configStr : string);
    begin
        fConfigStr := configStr;
    end;

    (*!------------------------------------------------
     * build application configuration instance
     *-------------------------------------------------
     * @return newly created configuration instance
     *-------------------------------------------------*)
    function TJsonStringConfigFactory.createConfig(const container : IDependencyContainer) : IAppConfiguration;
    begin
        result := TJsonStringConfig.create(fConfigStr);
    end;

    function TJsonStringConfigFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TJsonStringConfig.create(fConfigStr);
    end;

end.
