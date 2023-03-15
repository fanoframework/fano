{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit MaintenanceModeDispatcherImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EnvironmentIntf,
    ResponseIntf,
    StdInIntf,
    RouteHandlerIntf,
    DispatcherIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * dispatcher implementation that support for maintenance
     * mode. It checks existence of special file. If it does
     * it raise 503 HTTP error otherwise it call orginal
     * dispatcher
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMaintenanceModeDispatcher = class(TInjectableObject, IDispatcher)
    private
        {*--------------------------------------
         * external actual dispatcher
         *--------------------------------------}
        fActualDispatcher : IDispatcher;

        {*--------------------------------------
         * file that will be checked
         * for maintenance mode
         *--------------------------------------}
        fMaintenanceFilePath : string;

        function isUnderMaintenance() : boolean;
    public

        constructor create(
            const actualDispatcher : IDispatcher;
            const maintenanceFilePath : string = '__maintenance__'
        );

        function dispatchRequest(
            const env: ICGIEnvironment;
            const stdIn : IStdIn
        ) : IResponse;
    end;

implementation

uses

    SysUtils,
    EServiceUnavailableImpl;

    constructor TMaintenanceModeDispatcher.create(
        const actualDispatcher : IDispatcher;
        const maintenanceFilePath : string = '__maintenance__'
    );
    begin
        fActualDispatcher := actualDispatcher;
        fMaintenanceFilePath := maintenanceFilePath;
    end;

    function TMaintenanceModeDispatcher.isUnderMaintenance() : boolean;
    begin
        result := fileExists(fMaintenanceFilePath);
    end;

    function TMaintenanceModeDispatcher.dispatchRequest(
        const env: ICGIEnvironment;
        const stdIn : IStdIn
    ) : IResponse;
    begin
        if isUnderMaintenance() then
        begin
            raise EServiceUnavailable.create('Service currently unavailable');
        end;

        result := fActualDispatcher.dispatchRequest(env, stdIn);
    end;
end.
