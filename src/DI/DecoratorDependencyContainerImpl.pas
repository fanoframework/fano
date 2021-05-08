{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DecoratorDependencyContainerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf;

type

    (*!------------------------------------------------
     * base IDependencyContainer implementation class
     * that decorate other IDependencyContainer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDecoratorDependencyContainer = class (TInterfacedObject, IDependencyContainer)
    protected
        fActualContainer : IDependencyContainer;
    public
        constructor create(const actualContainer : IDependencyContainer);

        (*!--------------------------------------------------------
         * Add factory instance to service registration as
         * single instance
         *---------------------------------------------------------
         * @param serviceName name of service
         * @param serviceFactory factory instance
         * @return current dependency container instance
         *---------------------------------------------------------*)
        function add(
            const serviceName : shortstring;
            const serviceFactory : IDependencyFactory
        ) : IDependencyContainer; virtual;

        (*!--------------------------------------------------------
         * Add factory instance to service registration as
         * multiple instance
         *---------------------------------------------------------
         * @param serviceName name of service
         * @param serviceFactory factory instance
         * @return current dependency container instance
         *---------------------------------------------------------*)
        function factory(
            const serviceName : shortstring;
            const serviceFactory : IDependencyFactory
        ) : IDependencyContainer; virtual;

        (*!--------------------------------------------------------
         * Add alias name to existing service
         *---------------------------------------------------------
         * @param aliasName alias name of service
         * @param serviceName actual name of service
         * @return current dependency container instance
         *---------------------------------------------------------*)
        function alias(
            const aliasName: shortstring;
            const serviceName : shortstring
        ) : IDependencyContainer; virtual;

        (*!--------------------------------------------------------
         * get instance from service registration using its name.
         *---------------------------------------------------------
         * @param serviceName name of service
         * @return dependency instance
         * @throws EDependencyNotFoundImpl exception when name is not registered
         *---------------------------------------------------------
         * if serviceName is registered with add(), then this method
         * will always return same instance. If serviceName is
         * registered using factory(), this method will return
         * different instance everytime get() is called.
         *---------------------------------------------------------*)
        function get(const serviceName : shortstring) : IDependency; virtual;

        (*!--------------------------------------------------------
         * test if service is already registered or not.
         *---------------------------------------------------------
         * @param serviceName name of service
         * @return boolean true if service is registered otherwise false
         *---------------------------------------------------------*)
        function has(const serviceName : shortstring) : boolean; virtual;
    end;


implementation

    constructor TDecoratorDependencyContainer.create(
        const actualContainer : IDependencyContainer
    );
    begin
        fActualContainer := actualContainer;
    end;

    (*!--------------------------------------------------------
     * Add factory instance to service registration as
     * single instance
     *---------------------------------------------------------
     * @param serviceName name of service
     * @param serviceFactory factory instance
     * @return current dependency container instance
     *---------------------------------------------------------*)
    function TDecoratorDependencyContainer.add(
        const serviceName : shortstring;
        const serviceFactory : IDependencyFactory
    ) : IDependencyContainer;
    begin
        fActualContainer.add(serviceName, serviceFactory);
        result := self;
    end;

    (*!--------------------------------------------------------
     * Add factory instance to service registration as
     * multiple instance
     *---------------------------------------------------------
     * @param serviceName name of service
     * @param serviceFactory factory instance
     * @return current dependency container instance
     *---------------------------------------------------------*)
    function TDecoratorDependencyContainer.factory(
        const serviceName : shortstring;
        const serviceFactory : IDependencyFactory
    ) : IDependencyContainer;
    begin
        fActualContainer.factory(serviceName, serviceFactory);
        result := self;
    end;

    (*!--------------------------------------------------------
     * Add alias name to existing service
     *---------------------------------------------------------
     * @param aliasName alias name of service
     * @param serviceName actual name of service
     * @return current dependency container instance
     *---------------------------------------------------------*)
    function TDecoratorDependencyContainer.alias(
        const aliasName: shortstring;
        const serviceName : shortstring
    ) : IDependencyContainer;
    begin
        fActualContainer.alias(aliasName, serviceName);
        result := self;
    end;

    (*!--------------------------------------------------------
     * get instance from service registration using its name.
     *---------------------------------------------------------
     * @param serviceName name of service
     * @return dependency instance
     * @throws EDependencyNotFoundImpl exception when name is not registered
     *---------------------------------------------------------
     * if serviceName is registered with add(), then this method
     * will always return same instance. If serviceName is
     * registered using factory(), this method will return
     * different instance everytime get() is called.
     *---------------------------------------------------------*)
    function TDecoratorDependencyContainer.get(const serviceName : shortstring) : IDependency;
    begin
        result := fActualContainer.get(serviceName);
    end;

    (*!--------------------------------------------------------
     * test if service is already registered or not.
     *---------------------------------------------------------
     * @param serviceName name of service
     * @return boolean true if service is registered otherwise false
     *---------------------------------------------------------*)
    function TDecoratorDependencyContainer.has(const serviceName : shortstring) : boolean;
    begin
        result := fActualContainer.has(serviceName);
    end;

end.
