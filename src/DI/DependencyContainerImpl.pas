{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DependencyContainerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    contnrs,
    DependencyIntf,
    DependencyContainerIntf,
    DependencyListIntf;

type

    (*!------------------------------------------------
     * basic IDependencyContainer implementation class
     * having capability to manage dependency
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDependencyContainer = class(TInterfacedObject, IDependencyContainer)
    private
        dependencyList : IDependencyList;

        (*!--------------------------------------------------------
         * Add factory instance to service registration as
         * single instance or multiple instance
         *---------------------------------------------------------
         * @param serviceName name of service
         * @param serviceFactory factory instance
         * @param singleInstance true if single instance otherwise false
         * @param aliased true if service name is alias to other service
         * @param actualServiceName actual service if aliased
         * @return current dependency container instance
         *---------------------------------------------------------*)
        function addDependency(
            const serviceName : shortstring;
            const serviceFactory : IDependencyFactory;
            const singleInstance : boolean;
            const aliased : boolean;
            const actualServiceName : shortstring
        ) : IDependencyContainer;

        procedure cleanUpDependencies();

        (*!--------------------------------------------------------
         * get pointer to dependency record using its name or raise exception.
         *---------------------------------------------------------
         * @param serviceName name of service
         * @return dependency record pointer
         * @throws EDependencyNotFound
         *---------------------------------------------------------*)
        function getDepRecordOrExcept(const serviceName : shortstring) : pointer;

        (*!--------------------------------------------------------
         * get instance from service registration using its name.
         *---------------------------------------------------------
         * @param serviceName name of service
         * @param aDepRec dependency record
         * @return dependency instance
         * @throws EDependencyNotFound
         *---------------------------------------------------------
         * if serviceName is registered with add(), then this method
         * will always return same instance. If serviceName is
         * registered using factory(), this method will return
         * different instance everytime get() is called
         *---------------------------------------------------------*)
        function getDependency(
            const serviceName : shortstring;
            const aDepRec : pointer
        ) : IDependency;
    public
        (*!--------------------------------------------------------
         * constructor
         *---------------------------------------------------------
         * @param dependencies instance of list that will store dependencies
         *---------------------------------------------------------*)
        constructor create(const dependencies :IDependencyList);

        (*!--------------------------------------------------------
         * destructor
         *---------------------------------------------------------*)
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
         *---------------------------------------------------------
         * if serviceName is registered with add(), then this method
         * will always return same instance. If serviceName is
         * registered using factory(), this method will return
         * different instance everytime get() is called
         *---------------------------------------------------------*)
        function get(const serviceName : shortstring) : IDependency;

        (*!--------------------------------------------------------
         * test if service is already registered or not.
         *---------------------------------------------------------
         * @param serviceName name of service
         * @return boolean true if service is registered otherwise false
         *---------------------------------------------------------*)
        function has(const serviceName : shortstring) : boolean;
    end;

implementation

uses
    sysutils,
    EDependencyNotFoundImpl,
    EInvalidFactoryImpl,
    EDependencyAliasImpl,
    CircularDepAvoidFactoryImpl;

resourcestring

    sDependencyNotFound = 'Dependency "%s" not found';
    sInvalidFactory = 'Factory "%s" is invalid';
    sUnsupportedMultiLevelAlias = 'Unsupported multiple level alias "%s" to "%s"';
    sSameAlias = 'Cannot create alias to itself ("%s" to "%s")';

type

    TDependencyRec = record
        factory : IDependencyFactory;
        instance : IDependency;
        singleInstance : boolean;

        //if a service is alias to other service name, then
        //aliased will be true and actualServiceName point to actual service name
        aliased : boolean;
        actualServiceName : shortString;
    end;
    PDependencyRec = ^TDependencyRec;

    constructor TDependencyContainer.create(const dependencies : IDependencyList);
    begin
        dependencyList := dependencies;
    end;

    destructor TDependencyContainer.destroy();
    begin
        cleanUpDependencies();
        dependencyList := nil;
        inherited destroy();
    end;

    procedure TDependencyContainer.cleanUpDependencies();
    var i, len : integer;
        dep : PDependencyRec;
    begin
        len := dependencyList.count();
        for i := len-1 downto 0 do
        begin
            dep := dependencyList.get(i);
            dep^.factory := nil;
            dep^.instance := nil;
            dispose(dep);
            dependencyList.delete(i);
        end;
    end;

    (*!--------------------------------------------------------
     * Add factory instance to service registration as
     * single instance or multiple instance
     *---------------------------------------------------------
     * @param serviceName name of service
     * @param serviceFactory factory instance
     * @param singleInstance true if single instance otherwise false
     * @return current dependency container instance
     *---------------------------------------------------------*)
    function TDependencyContainer.addDependency(
        const serviceName : shortstring;
        const serviceFactory : IDependencyFactory;
        const singleInstance : boolean;
        const aliased : boolean;
        const actualServiceName : shortString
    ) : IDependencyContainer;
    var depRec : PDependencyRec;
        circularDepFactory : IDependencyFactory;
    begin
        depRec := dependencyList.find(serviceName);
        if (depRec = nil) then
        begin
           new(depRec);
           dependencyList.add(serviceName, depRec);
        end;

        //avoid circular dependency by wrapping it internally
        //with TCircularDepAvoidFactory. Instead of stack overflow
        //we will throw ECircularDependency exception.
        circularDepFactory := TCircularDepAvoidFactory.create(
            serviceName,
            serviceFactory
        );

        depRec^.factory := circularDepFactory;
        depRec^.instance := nil;
        depRec^.singleInstance := singleInstance;
        depRec^.aliased := aliased;
        depRec^.actualServiceName := actualServiceName;
        result := self;
    end;

    (*!--------------------------------------------------------
     * Add factory instance to service registration as
     * single instance
     *---------------------------------------------------------
     * @param serviceName name of service
     * @param service factory instance
     * @return current dependency container instance
     *---------------------------------------------------------*)
    function TDependencyContainer.add(
        const serviceName : shortstring;
        const serviceFactory : IDependencyFactory
    ) : IDependencyContainer;
    begin
        result := addDependency(serviceName, serviceFactory, true, false, '');
    end;

    (*!--------------------------------------------------------
     * Add factory instance to service registration as
     * multiple instance
     *---------------------------------------------------------
     * @param serviceName name of service
     * @param serviceFactory factory instance
     * @return current dependency container instance
     *---------------------------------------------------------*)
    function TDependencyContainer.factory(
        const serviceName : shortstring;
        const serviceFactory : IDependencyFactory
    ) : IDependencyContainer;
    begin
        result := addDependency(serviceName, serviceFactory, false, false, '');
    end;

    (*!--------------------------------------------------------
     * get pointer to dependency record using its name or raise exception.
     *---------------------------------------------------------
     * @param serviceName name of service
     * @return dependency record pointer
     * @throws EDependencyNotFound
     *---------------------------------------------------------*)
    function TDependencyContainer.getDepRecordOrExcept(const serviceName : shortstring) : pointer;
    begin
        result := dependencyList.find(serviceName);
        if (result = nil) then
        begin
            raise EDependencyNotFound.createFmt(sDependencyNotFound, [serviceName]);
        end;
    end;

    (*!--------------------------------------------------------
     * Add alias name to existing service
     *---------------------------------------------------------
     * @param aliasName alias name of service
     * @param serviceName actual name of service
     * @return current dependency container instance
     *---------------------------------------------------------*)
    function TDependencyContainer.alias(const aliasName: shortstring; const serviceName : shortstring) : IDependencyContainer;
    var actualDepRec : PDependencyRec;
    begin
        if (aliasName = serviceName) then
        begin
            //Cannot alias to itself as it will cause infinite recursion
            raise EDependencyAlias.CreateFmt(sSameAlias, [aliasName, serviceName]);
        end;

        actualDepRec := getDepRecordOrExcept(serviceName);

        if actualDepRec^.aliased then
        begin
            //TODO: Should we allow alias to other alias?
            //Allowing this may cause deep recursion when we need to get actual
            //instance. Current implementation does not support it
            raise EDependencyAlias.createFmt(sUnsupportedMultiLevelAlias, [aliasName, serviceName]);
        end;

        result := addDependency(aliasName, nil, false, true, serviceName);
    end;

    (*!--------------------------------------------------------
     * get instance from service registration using its name.
     *---------------------------------------------------------
     * @param serviceName name of service
     * @param aDepRec dependency record
     * @return dependency instance
     * @throws EDependencyNotFound
     * @throws EInvalidFactory
     *---------------------------------------------------------
     * if serviceName is registered with add(), then this method
     * will always return same instance. If serviceName is
     * registered using factory(), this method will return
     * different instance everytime it is called.
     *---------------------------------------------------------*)
    function TDependencyContainer.getDependency(
        const serviceName : shortstring;
        const aDepRec : pointer
    ) : IDependency;
    var depRec : PDependencyRec;
    begin
        depRec := aDepRec;

        if (depRec^.factory = nil) then
        begin
            raise EInvalidFactory.createFmt(sInvalidFactory, [serviceName]);
        end;

        if (depRec^.singleInstance) then
        begin
            if (depRec^.instance = nil) then
            begin
                depRec^.instance := depRec^.factory.build(self);
            end;
            result := depRec^.instance;
        end else
        begin
            result := depRec^.factory.build(self);
        end;
    end;

    (*!--------------------------------------------------------
     * get instance from service registration using its name or alias.
     *---------------------------------------------------------
     * @param serviceName name of service
     * @return dependency instance
     * @throws EDependencyNotFound
     * @throws EInvalidFactory
     *---------------------------------------------------------
     * if serviceName is registered with add(), then this method
     * will always return same instance. If serviceName is
     * registered using factory(), this method will return
     * different instance everytime it is called.
     *---------------------------------------------------------*)
    function TDependencyContainer.get(const serviceName : shortstring) : IDependency;
    var depRec : PDependencyRec;
    begin
        depRec := getDepRecordOrExcept(serviceName);

        if (not depRec^.aliased) then
        begin
            result := getDependency(serviceName, depRec);
        end else
        begin
            result := get(depRec^.actualServiceName);
        end;

    end;

    (*!--------------------------------------------------------
     * test if service is already registered or not.
     *---------------------------------------------------------
     * @param serviceName name of service
     * @return boolean true if service is registered otherwise false
     *---------------------------------------------------------
     * if serviceName is registered with add(), then this method
     * will always return same instance. If serviceName is
     * registered using factory(), this method will return
     * different instance everytim get() is called.s
     *---------------------------------------------------------*)
    function TDependencyContainer.has(const serviceName : shortstring) : boolean;
    begin
        result := (dependencyList.find(serviceName) <> nil);
    end;

end.
