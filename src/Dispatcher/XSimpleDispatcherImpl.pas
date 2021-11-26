{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit XSimpleDispatcherImpl;

interface

{$MODE OBJFPC}

uses

    EnvironmentIntf,
    ResponseIntf,
    RequestIntf,
    StdInIntf,
    RouteHandlerIntf,
    BaseDispatcherImpl;

type

    (*!------------------------------------------------
     * simple dispatcher implementation without
     * middleware support similar to TSimpleDispatcher.
     * except that request is created first before run route
     * matching
     *------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TXSimpleDispatcher = class(TBaseDispatcher)
    public
        function dispatchRequest(
            const env: ICGIEnvironment;
            const stdIn : IStdIn
        ) : IResponse; override;
    end;

implementation

    function TXSimpleDispatcher.dispatchRequest(
        const env: ICGIEnvironment;
        const stdIn : IStdIn
    ) : IResponse;
    var routeHandler : IRouteHandler;
        request : IRequest;
        response : IResponse;
    begin
        //build request instance first to allow request be modified
        //or decorated before we run route matching. This to allow
        //verb tunnelling using special POST parameter such as _method
        request := requestFactory.build(env, stdIn);
        try
            //use CGI environment from request to allow
            //request decorate CGI environment
            response := responseFactory.build(request.env);
            try
                routeHandler := getRouteHandler(request.env);
                try
                    result := routeHandler.handler().handleRequest(
                        request,
                        response,
                        routeHandler.argsReader()
                    );
                finally
                    routeHandler := nil;
                end;
            finally
                response := nil;
            end;
        finally
            request := nil;
        end;
    end;
end.
