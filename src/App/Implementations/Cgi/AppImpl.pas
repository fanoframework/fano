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
         * @return current application instance
         *-----------------------------------------------*)
        function doExecute(
            const container : IDependencyContainer;
            const env : ICGIEnvironment
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
     * @return current application instance
     *-----------------------------------------------*)
    function TCgiWebApplication.doExecute(
        const container : IDependencyContainer;
        const env : ICGIEnvironment
    ) : IRunnable;
    begin
        if (initialize(container)) then
        begin
            execute(env);
        end;
        result := self;
    end;

    (*!-----------------------------------------------
     * execute application and handle exception
     *------------------------------------------------
     * @return current application instance
     *-----------------------------------------------
     * TODO: need to think about how to execute when
     * application is run as daemon.
     *-----------------------------------------------*)
    function TCgiWebApplication.run() : IRunnable;
    begin
        result := execAndHandleExcept(fAppSvc.container, fAppSvc.env, fAppSvc.errorHandler);
    end;
end.
