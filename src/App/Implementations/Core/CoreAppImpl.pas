{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit CoreAppImpl;

interface

{$MODE OBJFPC}

uses

    RunnableIntf,
    DependencyContainerIntf,
    AppIntf,
    AppServiceProviderIntf,
    DispatcherIntf,
    EnvironmentIntf,
    EnvironmentEnumeratorIntf,
    ErrorHandlerIntf,
    StdInIntf,
    RouterIntf,
    RouteBuilderIntf,
    CoreAppConsts;

type

    (*!-----------------------------------------------
     * Base abstract class that implements IWebApplication
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCoreWebApplication = class abstract (TInterfacedObject, IWebApplication, IRunnable)
    protected
        fAppSvc : IAppServiceProvider;
        fRouteBuilder : IRouteBuilder;

        (*!-----------------------------------------------
         * execute application and write response
         *------------------------------------------------
         * @param env CGI environment
         * @param stdin stdin instance
         * @param dispatcher dispatcher instance
         * @return current application instance
         *-----------------------------------------------*)
        function execute(
            const env : ICGIEnvironment;
            const stdin : IStdIn;
            const dispatcher : IDispatcher
        ) : IRunnable;

        (*!-----------------------------------------------
         * execute application and handle exception
         *------------------------------------------------
         * @param container dependency container
         * @param env CGI environment
         * @param stdin stdin instance
         * @param errorHandler error handler instance
         * @param dispatcher dispatcher instance
         * @return current application instance
         *-----------------------------------------------*)
        function execAndHandleExcept(
            const container : IDependencyContainer;
            const env : ICGIEnvironment;
            const stdin : IStdIn;
            const errorHandler : IErrorHandler;
            const dispatcher : IDispatcher
        ) : IRunnable;

        (*!-----------------------------------------------
         * execute application
         *------------------------------------------------
         * @param container dependency container
         * @param env CGI environment
         * @param stdin stdin instance
         * @param dispatcher dispatcher instance
         * @return current application instance
         *-----------------------------------------------*)
        function doExecute(
            const container : IDependencyContainer;
            const env : ICGIEnvironment;
            const stdin : IStdIn;
            const dispatcher : IDispatcher
        ) : IRunnable; virtual; abstract;

        procedure reset();

        (*!-----------------------------------------------
         * initialize application dependencies
         *------------------------------------------------
         * @param container dependency container
         * @return true if application dependency succesfully
         * constructed
         *-----------------------------------------------*)
        function initialize(const container : IDependencyContainer) : boolean; virtual;
    public

        (*!-----------------------------------------------
         * constructor
         *------------------------------------------------
         * @param appSvc class provide essentials service
         * @param routeBuilder class responsible to build application routes
         *-----------------------------------------------*)
        constructor create(
            const appSvc : IAppServiceProvider;
            const routeBuilder : IRouteBuilder
        );
        destructor destroy(); override;
        function run() : IRunnable; virtual; abstract;
    end;

implementation

uses

    SysUtils,
    ResponseIntf,

    //exception-related units
    EHttpExceptionImpl,
    ERouteHandlerNotFoundImpl,
    EMethodNotAllowedImpl,
    EInvalidMethodImpl,
    EInvalidRequestImpl,
    ENotFoundImpl,
    EDependencyNotFoundImpl,
    EUnauthorizedImpl,
    EForbiddenImpl,
    ETooManyRequestsImpl;

    procedure TCoreWebApplication.reset();
    begin
        fAppSvc := nil;
        fRouteBuilder := nil;
    end;

    (*!-----------------------------------------------
     * constructor
     *------------------------------------------------
     * @param appSvc class that provide essentials services
     * @param routeBuilder class responsible to build application routes
     *-----------------------------------------------*)
    constructor TCoreWebApplication.create(
        const appSvc : IAppServiceProvider;
        const routeBuilder : IRouteBuilder
    );
    begin
        inherited create();
        randomize();
        reset();
        fAppSvc := appSvc;
        fRouteBuilder := routeBuilder;
    end;

    (*!-----------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TCoreWebApplication.destroy();
    begin
        reset();
        inherited destroy();
    end;

    (*!-----------------------------------------------
     * initialize application dependencies
     *------------------------------------------------
     * @param container dependency container
     * @return true if application dependency succesfully
     * constructed
     *-----------------------------------------------*)
    function TCoreWebApplication.initialize(const container : IDependencyContainer) : boolean;
    begin
        try
            fAppSvc.register(container);
            fRouteBuilder.buildRoutes(container, fAppSvc.router);
            result := true;
        except
            on e : Exception do
            begin
                result := false;
                //TODO : improve exception handling
                writeln('Fail to initialize application.');
                writeln('Exception: ', e.ClassName);
                writeln('Message: ', e.Message);
            end;
        end;
    end;

    (*!-----------------------------------------------
     * execute application and write response
     *------------------------------------------------
     * @param env CGI environment
     * @param stdin stdin instance
     * @param dispatcher dispatcher instance
     * @return current application instance
     *-----------------------------------------------*)
    function TCoreWebApplication.execute(
        const env : ICGIEnvironment;
        const stdin : IStdIn;
        const dispatcher : IDispatcher
    ) : IRunnable;
    var response : IResponse;
    begin
        response := dispatcher.dispatchRequest(env, stdIn);
        try
            response.write();
            result := self;
        finally
            response := nil;
        end;
    end;

    (*!-----------------------------------------------
     * execute application and handle exception
     *------------------------------------------------
     * @param container dependency container
     * @param env CGI environment
     * @param stdin stdin instance
     * @param errorHandler error handler instance
     * @param dispatcher dispatcher instance
     * @return current application instance
     *-----------------------------------------------*)
    function TCoreWebApplication.execAndHandleExcept(
        const container : IDependencyContainer;
        const env : ICGIEnvironment;
        const stdin : IStdIn;
        const errorHandler : IErrorHandler;
        const dispatcher : IDispatcher
    ) : IRunnable;
    begin
        try
            result := doExecute(container, env, stdin, dispatcher);
        except
            on e : EHttpException do
            begin
                errorHandler.handleError(
                    env.enumerator,
                    e,
                    e.httpCode,
                    e.httpMessage
                );
                reset();
            end;

            on e : Exception do
            begin
                errorHandler.handleError(env.enumerator, e);
                reset();
            end;
        end;
    end;

end.
