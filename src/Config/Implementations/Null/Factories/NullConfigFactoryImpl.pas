unit NullConfigFactoryImpl;

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
     * Factory class for TNullConfig
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TNullConfigFactory = class (TFactory, IDependencyFactory, IConfigFactory)
    public
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

    NullConfigImpl;

    function TNullConfigFactory.createConfig(const container : IDependencyContainer) : IAppConfiguration;
    begin
        result := TNullConfig.create();
    end;

    function TNullConfigFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TNullConfig.create();
    end;

end.
