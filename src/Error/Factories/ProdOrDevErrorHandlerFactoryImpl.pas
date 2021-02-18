{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ProdOrDevErrorHandlerFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for error handler for that return
     * different error handler based on production setup
     * or development
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TProdOrDevErrorHandlerFactory = class(TFactory, IDependencyFactory)
    private
        err500TemplateFilename : string;
        err404TemplateFilename : string;
        isProdEnv : boolean;
    public
        constructor create(
            const err404TemplateFile : string;
            const err500TemplateFile : string;
            const isProd : boolean
        );
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    ErrorHandlerImpl,
    TemplateErrorHandlerImpl,
    BoolErrorHandlerImpl,
    NotFoundErrorHandlerImpl;

    constructor TProdOrDevErrorHandlerFactory.create(
        const err404TemplateFile : string;
        const err500TemplateFile : string;
        const isProd : boolean
    );
    begin
        err404TemplateFilename := err404TemplateFile;
        err500TemplateFilename := err500TemplateFile;
        isProdEnv := isProd;
    end;

    function TProdOrDevErrorHandlerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TBoolErrorHandler.create(
            TNotFoundErrorHandler.create(
                TTemplateErrorHandler.create(err404TemplateFilename),
                TTemplateErrorHandler.create(err500TemplateFilename)
            ),
            TErrorHandler.create(),
            isProdEnv
        );
    end;

end.
