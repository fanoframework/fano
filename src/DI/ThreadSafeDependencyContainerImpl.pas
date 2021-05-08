{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit ThreadSafeDependencyContainerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    DependencyIntf,
    DependencyContainerIntf,
    DecoratorDependencyContainerImpl;

type

    (*!------------------------------------------------
     * thread-safe IDependencyContainer implementation class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeDependencyContainer = class (TDecoratorDependencyContainer)
    private
        fCriticalSection : TCriticalSection;
    public
        constructor create(const actualContainer : IDependencyContainer);
        destructor destroy(); override;

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
        ) : IDependencyContainer; override;

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
        ) : IDependencyContainer; override;

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
        ) : IDependencyContainer; override;

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
        function get(const serviceName : shortstring) : IDependency; override;

        (*!--------------------------------------------------------
         * test if service is already registered or not.
         *---------------------------------------------------------
         * @param serviceName name of service
         * @return boolean true if service is registered otherwise false
         *---------------------------------------------------------*)
        function has(const serviceName : shortstring) : boolean; override;
    end;


implementation

    constructor TThreadSafeDependencyContainer.create(
        const actualContainer : IDependencyContainer
    );
    begin
        inherited create(actualContainer);
        fCriticalSection := TCriticalSection.create();
    end;

    destructor TThreadSafeDependencyContainer.destroy();
    begin
        fCriticalSection.free();
        inherited destroy();
    end;

    (*!--------------------------------------------------------
     * Add factory instance to service registration as
     * single instance
     *---------------------------------------------------------
     * @param serviceName name of service
     * @param serviceFactory factory instance
     * @return current dependency container instance
     *---------------------------------------------------------*)
    function TThreadSafeDependencyContainer.add(
        const serviceName : shortstring;
        const serviceFactory : IDependencyFactory
    ) : IDependencyContainer;
    begin
        fCriticalSection.acquire();
        try
            inherited add(serviceName, serviceFactory);
            result := self;
        finally
            fCriticalSection.release();
        end;
    end;

    (*!--------------------------------------------------------
     * Add factory instance to service registration as
     * multiple instance
     *---------------------------------------------------------
     * @param serviceName name of service
     * @param serviceFactory factory instance
     * @return current dependency container instance
     *---------------------------------------------------------*)
    function TThreadSafeDependencyContainer.factory(
        const serviceName : shortstring;
        const serviceFactory : IDependencyFactory
    ) : IDependencyContainer;
    begin
        fCriticalSection.acquire();
        try
            inherited factory(serviceName, serviceFactory);
            result := self;
        finally
            fCriticalSection.release();
        end;
    end;

    (*!--------------------------------------------------------
     * Add alias name to existing service
     *---------------------------------------------------------
     * @param aliasName alias name of service
     * @param serviceName actual name of service
     * @return current dependency container instance
     *---------------------------------------------------------*)
    function TThreadSafeDependencyContainer.alias(
        const aliasName: shortstring;
        const serviceName : shortstring
    ) : IDependencyContainer;
    begin
        fCriticalSection.acquire();
        try
            inherited alias(aliasName, serviceName);
            result := self;
        finally
            fCriticalSection.release();
        end;
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
    function TThreadSafeDependencyContainer.get(const serviceName : shortstring) : IDependency;
    begin
        fCriticalSection.acquire();
        try
            result := inherited get(serviceName);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!--------------------------------------------------------
     * test if service is already registered or not.
     *---------------------------------------------------------
     * @param serviceName name of service
     * @return boolean true if service is registered otherwise false
     *---------------------------------------------------------*)
    function TThreadSafeDependencyContainer.has(const serviceName : shortstring) : boolean;
    begin
        fCriticalSection.acquire();
        try
            result := inherited has(serviceName);
        finally
            fCriticalSection.release();
        end;
    end;

end.
