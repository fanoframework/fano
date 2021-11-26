{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MwExecDispatcherImpl;

interface

{$MODE OBJFPC}

uses

    DispatcherIntf,
    EnvironmentIntf,
    ResponseIntf,
    ResponseFactoryIntf,
    RequestIntf,
    RequestFactoryIntf,
    RouteMatcherIntf,
    RouteHandlerIntf,
    MiddlewareExecutorIntf,
    StdInIntf,
    InjectableObjectImpl,
    XDispatcherImpl;

type

    (*!---------------------------------------------------
     * Request dispatcher class having capability dispatch
     * request and return response and with middleware support
     * and ensure application global middlewares always executed even when
     * route is not exist or method is not allowed
     *----------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TMwExecDispatcher = class(TXDispatcher)
    protected
        function getRouteHandler(const env: ICGIEnvironment) : IRouteHandler; override;
    public
    end;

implementation

uses

    ERouteHandlerNotFoundImpl,
    EMethodNotAllowedImpl,
    DeferNotFoundRouteHandlerImpl,
    DeferMethodNotAllowedRouteHandlerImpl;

    function TMwExecDispatcher.getRouteHandler(const env: ICGIEnvironment) : IRouteHandler;
    begin
        try
            result := inherited getRouteHandler(env);
        except
            on e: ERouteHandlerNotFound do
            begin
                //route is not exists, defer exception later
                result := TDeferNotFoundRouteHandler.create(e.message);
                exit;
            end;

            on e: EMethodNotAllowed do
            begin
                //defer exception later
                result := TDeferMethodNotAllowedRouteHandler.create(e.message);
                exit;
            end;
        end;
    end;
end.
