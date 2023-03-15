{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MiddlewareExecutorIntf;

interface

{$MODE OBJFPC}

uses

    RequestIntf,
    ResponseIntf,
    RouteHandlerIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * execute middlewares stack
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IMiddlewareExecutor = interface
        ['{47B9A178-4A0A-4599-AD67-C73B8E42B82A}']
        function execute(
            const request : IRequest;
            const response : IResponse;
            const routeHandler : IRouteHandler
        ) : IResponse;
    end;

implementation
end.
