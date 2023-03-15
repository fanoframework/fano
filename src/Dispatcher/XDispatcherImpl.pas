{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit XDispatcherImpl;

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
    BaseDispatcherImpl;

type

    (*!---------------------------------------------------
     * Request dispatcher class having capability dispatch
     * request and return response and with middleware support
     *----------------------------------------------------
     * Note : It differs little bit from TDispatcher
     * It creates request and response before route matching so that
     * we can enhance request, response or CGI environment before
     * route matching. This to allow scenario such as HTTP method
     * override using _method param
     *----------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TXDispatcher = class(TBaseDispatcher)
    private
        fMiddlewareExecutor : IMiddlewareExecutor;
    public
        constructor create(
            const middlewareExecutor : IMiddlewareExecutor;
            const routes : IRouteMatcher;
            const respFactory : IResponseFactory;
            const reqFactory : IRequestFactory
        );
        destructor destroy(); override;

        (*!-------------------------------------------
         * dispatch request
         *--------------------------------------------
         * @param env CGI environment
         * @param stdIn STDIN reader
         * @return response
         *--------------------------------------------*)
        function dispatchRequest(
            const env: ICGIEnvironment;
            const stdIn : IStdIn
        ) : IResponse; override;
    end;

implementation

    constructor TXDispatcher.create(
        const middlewareExecutor : IMiddlewareExecutor;
        const routes : IRouteMatcher;
        const respFactory : IResponseFactory;
        const reqFactory : IRequestFactory
    );
    begin
        inherited create(routes, respFactory, reqFactory);
        fMiddlewareExecutor := middlewareExecutor;
    end;

    destructor TXDispatcher.destroy();
    begin
        fMiddlewareExecutor := nil;
        inherited destroy();
    end;

    function TXDispatcher.dispatchRequest(
        const env: ICGIEnvironment;
        const stdIn : IStdIn
    ) : IResponse;
    var routeHandler : IRouteHandler;
        request : IRequest;
        response : IResponse;
        reqEnv : ICGIEnvironment;
    begin
        //build request instance first to allow request be modified
        //or decorated before we run route matching. This to allow
        //verb tunnelling using special POST parameter such as _method
        request := requestFactory.build(env, stdIn);
        try
            //use CGI environment from request to allow
            //request decorate CGI environment. Store it in tmp variable
            //so we can release reference propery in case exception
            reqEnv := request.env;
            response := responseFactory.build(reqEnv);
            try
                routeHandler := getRouteHandler(reqEnv);
                try
                    result := fMiddlewareExecutor.execute(
                        request,
                        response,
                        routeHandler
                    );
                finally
                    routeHandler := nil;
                end;
            finally
                reqEnv := nil;
                response := nil;
            end;
        finally
            request := nil;
        end;
    end;
end.
