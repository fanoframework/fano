{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MaintenanceModeDispatcherFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    DependencyIntf,
    DependencyContainerIntf,
    DecoratorFactoryImpl;

type

    (*!--------------------------------------------------
     * factory class for TMaintenanceModeDispatcher,
     * dispatcher implementation which support
     * maintenance mode
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TMaintenanceModeDispatcherFactory = class(TDecoratorFactory)
    private
        fMaintenanceFilePath : string;
    public
        constructor create(const factory : IDependencyFactory);
        function path(const maintenanceFilePath : string) : TMaintenanceModeDispatcherFactory;
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    DispatcherIntf,
    MaintenanceModeDispatcherImpl;

    constructor TMaintenanceModeDispatcherFactory.create(const factory : IDependencyFactory);
    begin
        inherited create(factory);
        fMaintenanceFilePath := '__maintenance__';
    end;

    function TMaintenanceModeDispatcherFactory.path(
        const maintenanceFilePath : string
    ) : TMaintenanceModeDispatcherFactory;
    begin
        fMaintenanceFilePath := maintenanceFilePath;
        result := self;
    end;

    function TMaintenanceModeDispatcherFactory.build(
        const container : IDependencyContainer
    ) : IDependency;
    begin
        result := TMaintenanceModeDispatcher.create(
            fActualFactory.build(container) as IDispatcher,
            fMaintenanceFilePath
        );
    end;

end.
