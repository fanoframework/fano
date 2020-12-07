unit CompositeConfigFactoryImpl;

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
     * Factory class for TCompositeConfig
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TCompositeConfigFactory = class (TFactory, IDependencyFactory, IConfigFactory)
    private
        fFirstFactory : IConfigFactory;
        fSecondFactory : IConfigFactory;
    public
        constructor create(
            const firstFactory : IConfigFactory;
            const secondFactory : IConfigFactory
        );

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

    CompositeConfigImpl;

    constructor TCompositeConfigFactory.create(
        const firstFactory : IConfigFactory;
        const secondFactory : IConfigFactory
    );
    begin
        fFirstFactory := firstFactory;
        fSecondFactory := secondFactory;
    end;

    (*!------------------------------------------------
     * build application configuration instance
     *-------------------------------------------------
     * @return newly created configuration instance
     *-------------------------------------------------*)
    function TCompositeConfigFactory.createConfig(const container : IDependencyContainer) : IAppConfiguration;
    begin
        result := TCompositeConfig.create(
            fFirstFactory.createConfig(container),
            fSecondFactory.createConfig(container)
        );
    end;

    (*!------------------------------------------------
     * build application configuration instance
     *-------------------------------------------------
     * @return newly created configuration instance
     *-------------------------------------------------*)
    function TCompositeConfigFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TCompositeConfig.create(
            fFirstFactory.createConfig(container),
            fSecondFactory.createConfig(container)
        );
    end;

end.
