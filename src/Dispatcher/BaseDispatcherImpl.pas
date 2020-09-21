{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit BaseDispatcherImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DispatcherIntf,
    EnvironmentIntf,
    ResponseIntf,
    ResponseFactoryIntf,
    RequestFactoryIntf,
    RouteMatcherIntf,
    RouteHandlerIntf,
    StdInIntf,
    InjectableObjectImpl;

type
    (*!------------------------------------------------
     * base abstract dispatcher implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TBaseDispatcher = class(TInjectableObject, IDispatcher)
    private
        routeMatcher : IRouteMatcher;
    protected
        responseFactory : IResponseFactory;
        requestFactory : IRequestFactory;

        function getRouteHandler(const env: ICGIEnvironment) : IRouteHandler;
    public
        constructor create(
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
        ) : IResponse; virtual; abstract;
    end;

implementation

uses

    SysUtils,
    UrlHelpersImpl;

    constructor TBaseDispatcher.create(
        const routes : IRouteMatcher;
        const respFactory : IResponseFactory;
        const reqFactory : IRequestFactory
    );
    begin
        routeMatcher := routes;
        responseFactory := respFactory;
        requestFactory := reqFactory;
    end;

    destructor TBaseDispatcher.destroy();
    begin
        routeMatcher := nil;
        responseFactory := nil;
        requestFactory := nil;
        inherited destroy();
    end;

    function TBaseDispatcher.getRouteHandler(const env: ICGIEnvironment) : IRouteHandler;
    begin
        result := routeMatcher.match(
            env.requestMethod(),
            //remove any query string parts to avoid messing up pattern matching
            env.requestUri().stripQueryString()
        );
    end;
end.
