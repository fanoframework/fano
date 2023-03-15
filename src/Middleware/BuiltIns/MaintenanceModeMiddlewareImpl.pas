{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MaintenanceModeMiddlewareImpl;

interface

{$MODE OBJFPC}

uses

    MiddlewareIntf,
    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf;

type

    (*!------------------------------------------------
     * middleware implementation which puts application in
     * maintenance mode if it detects existence of special file
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMaintenanceModeMiddleware = class(TInterfacedObject, IMiddleware)
    private
        {*--------------------------------------
         * file that will be checked
         * for maintenance mode
         *--------------------------------------}
        fMaintenanceFilePath : string;
    protected
        function isUnderMaintenance() : boolean; virtual;
    public
        constructor create(const maintenanceFilePath : string = '__maintenance__');

        (*!-------------------------------------------
         * handle request
         *--------------------------------------------
         * @param request object represent current request
         * @param response object represent current response
         * @param args object represent current route arguments
         * @param next next middleware
         * @return new response
         *--------------------------------------------*)
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;
    end;

implementation

uses

    SysUtils,
    EServiceUnavailableImpl;

    constructor TMaintenanceModeMiddleware.create(
        const maintenanceFilePath : string = '__maintenance__'
    );
    begin
        fMaintenanceFilePath := maintenanceFilePath;
    end;

    function TMaintenanceModeMiddleware.isUnderMaintenance() : boolean;
    begin
        result := fileExists(fMaintenanceFilePath);
    end;

    (*!-------------------------------------------
     * handle request
     *--------------------------------------------
     * @param request object represent current request
     * @param response object represent current response
     * @param args object represent current route arguments
     * @param next next middleware
     * @return new response
     *--------------------------------------------*)
    function TMaintenanceModeMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    begin
        if isUnderMaintenance() then
        begin
            raise EServiceUnavailable.create('Service currently unavailable');
        end;

        result := next.handleRequest(request, response, args);
    end;
end.
