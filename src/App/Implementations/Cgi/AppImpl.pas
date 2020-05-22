{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit AppImpl;

interface

{$MODE OBJFPC}

uses

    RunnableIntf,
    DependencyContainerIntf,
    EnvironmentIntf,
    StdInIntf,
    StdOutIntf,
    DispatcherIntf,
    CoreAppConsts,
    CoreAppImpl;

type

    (*!-----------------------------------------------
     * Base CGI application that implements IWebApplication
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCgiWebApplication = class(TCoreWebApplication)
    protected
        (*!-----------------------------------------------
         * execute application
         *------------------------------------------------
         * @param container dependency container
         * @param env CGI environment
         * @param astdin stdin instance
         * @param astdout stdout instance
         * @param dispatcher dispatcher instance
         * @return current application instance
         *-----------------------------------------------*)
        function doExecute(
            const container : IDependencyContainer;
            const env : ICGIEnvironment;
            const astdin : IStdIn;
            const astdout : IStdOut;
            const dispatcher : IDispatcher
        ) : IRunnable; override;
    public
        function run() : IRunnable; override;
    end;

implementation

uses

    SysUtils;

    (*!-----------------------------------------------
     * execute application
     *------------------------------------------------
     * @param container dependency container
     * @param env CGI environment
     * @param astdin stdin instance
     * @param astdout stdout instance
     * @param dispatcher dispatcher instance
     * @return current application instance
     *-----------------------------------------------*)
    function TCgiWebApplication.doExecute(
        const container : IDependencyContainer;
        const env : ICGIEnvironment;
        const astdin : IStdIn;
        const astdout : IStdOut;
        const dispatcher : IDispatcher
    ) : IRunnable;
    begin
        if (initialize(container)) then
        begin
            execute(env, astdin, astdout, dispatcher);
        end;
        result := self;
    end;

    (*!-----------------------------------------------
     * execute application and handle exception
     *------------------------------------------------
     * @return current application instance
     *-----------------------------------------------*)
    function TCgiWebApplication.run() : IRunnable;
    begin
        result := execAndHandleExcept(
            fAppSvc.container,
            fAppSvc.env,
            fAppSvc.stdIn,
            fAppSvc.stdOut,
            fAppSvc.errorHandler,
            fAppSvc.dispatcher
        );
    end;
end.
