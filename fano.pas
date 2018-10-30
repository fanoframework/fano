{*!
 * Fano Web Framework (https://fano.juhara.id)
 *
 * @link      https://github.com/zamronypj/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/zamronypj/fano/blob/master/LICENSE (GPL 3.0)
 *}


unit fano;

interface

{$MODE OBJFPC}

uses

    {*! -------------------------------
        unit interfaces
    ----------------------------------- *}
    DependencyContainerIntf,
    RunnableIntf,
    DispatcherIntf,
    EnvironmentIntf,
    ErrorHandlerIntf,
    AppIntf,

    RouteMatcherIntf,
    RouteCollectionIntf,
    RouteHandlerIntf,
    MiddlewareCollectionAwareIntf,
    ConfigIntf,
    OutputBufferIntf,
    TemplateParserIntf,

    {*! -------------------------------
        unit implementations
    ----------------------------------- *}
    DependencyContainerImpl,
    DependencyListImpl,
    EnvironmentImpl,
    EnvironmentFactoryImpl,
    ErrorHandlerImpl,

    AppImpl,
    DispatcherFactoryImpl,
    SimpleDispatcherFactoryImpl,

    RouteCollectionFactoryImpl,
    SimpleRouteCollectionFactoryImpl,
    CombineRouteCollectionFactoryImpl,

    HeadersFactoryImpl,
    OutputBufferFactoryImpl,
    ErrorHandlerFactoryImpl,
    JsonFileConfigImpl,
    JsonFileConfigFactoryImpl,
    MiddlewareCollectionAwareFactoryImpl,
    NullMiddlewareCollectionAwareFactoryImpl,
    TemplateParserFactoryImpl,
    SimpleTemplateParserFactoryImpl,
    TemplateFileViewImpl,
    ViewParametersFactoryImpl;

type
    (*!-----------------------------------------------
     * Redeclare all classes in one unit to simplify
     * including classes
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *------------------------------------------------*)

    //interface aliases
    IDependencyContainer = DependencyContainerIntf.IDependencyContainer;
    IRunnable = RunnableIntf.IRunnable;
    IDispatcher = DispatcherIntf.IDispatcher;
    ICGIEnvironment = EnvironmentIntf.ICGIEnvironment;
    IErrorHandler = ErrorHandlerIntf.IErrorHandler;
    IRouteMatcher = RouteMatcherIntf.IRouteMatcher;
    IWebApplication = AppIntf.IWebApplication;
    IRouteCollection = RouteCollectionIntf.IRouteCollection;
    IRouteHandler = RouteHandlerIntf.IRouteHandler;
    IMiddlewareCollectionAware = MiddlewareCollectionAwareIntf.IMiddlewareCollectionAware;
    IAppConfiguration = ConfigIntf.IAppConfiguration;
    IOutputBuffer = OutputBufferIntf.IOutputBuffer;

    //implementation aliases
    TDependencyContainer = DependencyContainerImpl.TDependencyContainer;
    TDependencyList = DependencyListImpl.TDependencyList;
    TCGIEnvironment = EnvironmentImpl.TCGIEnvironment;
    TErrorHandler = ErrorHandlerImpl.TErrorHandler;
    TFanoWebApplication = AppImpl.TFanoWebApplication;
    TJsonFileConfigFactory = JsonFileConfigFactoryImpl.TJsonFileConfigFactory;
    TNullMiddlewareCollectionAwareFactory = NullMiddlewareCollectionAwareFactoryImpl.TNullMiddlewareCollectionAwareFactory;
    TSimpleRouteCollectionFactory = SimpleRouteCollectionFactoryImpl.TSimpleRouteCollectionFactory;
    TSimpleDispatcherFactory = SimpleDispatcherFactoryImpl.TSimpleDispatcherFactory;
    THeadersFactory = HeadersFactoryImpl.THeadersFactory;
    TOutputBufferFactory = OutputBufferFactoryImpl.TOutputBufferFactory;

implementation

end.
