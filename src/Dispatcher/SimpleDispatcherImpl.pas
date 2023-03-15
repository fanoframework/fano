{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit SimpleDispatcherImpl;

interface

{$MODE OBJFPC}

uses

    EnvironmentIntf,
    ResponseIntf,
    StdInIntf,
    RouteHandlerIntf,
    BaseDispatcherImpl;

type
    (*!------------------------------------------------
     * simple dispatcher implementation without
     * middleware support. It is faster than
     * TDispatcher because it does not process middlewares
     * stack during dispatching request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSimpleDispatcher = class(TBaseDispatcher)
    public
        function dispatchRequest(
            const env: ICGIEnvironment;
            const stdIn : IStdIn
        ) : IResponse; override;
    end;

implementation

    function TSimpleDispatcher.dispatchRequest(
        const env: ICGIEnvironment;
        const stdIn : IStdIn
    ) : IResponse;
    var routeHandler : IRouteHandler;
    begin
        routeHandler := getRouteHandler(env);
        result := routeHandler.handler().handleRequest(
            requestFactory.build(env, stdIn),
            responseFactory.build(env),
            routeHandler.argsReader()
        );
    end;
end.
