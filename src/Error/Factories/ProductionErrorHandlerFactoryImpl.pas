{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ProductionErrorHandlerFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for error handler for production setup
     * which is to log exception to file and output
     * nicely formatted error page
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TProductionErrorHandlerFactory = class(TFactory, IDependencyFactory)
    private
        logFilename : string;
        templateFilename : string;
    public
        constructor create(const logFile : string; const templateFile : string);
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    FileLoggerImpl,
    TemplateErrorHandlerImpl,
    CompositeErrorHandlerImpl,
    LogErrorHandlerImpl;

    constructor TProductionErrorHandlerFactory.create(
        const logFile : string;
        const templateFile : string
    );
    begin
        logFilename := logFile;
        templateFilename := templateFile;
    end;

    function TProductionErrorHandlerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TCompositeErrorHandler.create(
            TLogErrorHandler.create(TFileLogger.create(logFilename)),
            TTemplateErrorHandler.create(templateFilename)
        );
    end;

end.
