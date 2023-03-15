{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DependencyContainerIntf;

interface

{$MODE OBJFPC}
{$H+}

uses
    DependencyIntf;

type
    {-----------------------------------
      make it forward declaration.
      We are forced to combine factory interface
      and container interface in one unit
      because of circular reference
    ------------------------------------}
    IDependencyFactory = interface;

    {------------------------------------------------
     interface for any class having capability to manage
     dependency

     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    IDependencyContainer = interface
        ['{7B76FB8C-47E0-4EE2-9020-341867711D9A}']

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
        ) : IDependencyContainer;

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
        ) : IDependencyContainer;

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
        ) : IDependencyContainer;

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
        function get(const serviceName : shortstring) : IDependency;
        property services[const serviceName : shortstring] : IDependency read get; default;

        (*!--------------------------------------------------------
         * test if service is already registered or not.
         *---------------------------------------------------------
         * @param serviceName name of service
         * @return boolean true if service is registered otherwise false
         *---------------------------------------------------------*)
        function has(const serviceName : shortstring) : boolean;
    end;

    {------------------------------------------------
     interface for any class having capability to
     create other instance

     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    IDependencyFactory = interface
        ['{BB858A2C-65DD-47C6-9A04-7C4CCA2816DD}']

        {*!----------------------------------------
         * build instance
         *-----------------------------------------
         * @param container dependency container instance
         * @return instance of IDependency interface
         *------------------------------------------*}
        function build(const container : IDependencyContainer) : IDependency;
    end;

implementation

end.
