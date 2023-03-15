{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit TemplateErrorHandlerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TTemplateErrorHandler
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TTemplateErrorHandlerFactory = class(TFactory, IDependencyFactory)
    private
        templateFilename : string;
    public
        (*!---------------------------------------------------
         * constructor
         *----------------------------------------------------
         * @param tplFilename html template file to load
         *---------------------------------------------------*)
        constructor create(const tplFilename : string);

        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *---------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    TemplateErrorHandlerImpl;

    (*!---------------------------------------------------
     * constructor
     *----------------------------------------------------
     * @param tplFilename html template file to load
     *---------------------------------------------------*)
    constructor TTemplateErrorHandlerFactory.create(const tplFilename : string);
    begin
        templateFilename := tplFilename;
    end;

    (*!---------------------------------------------------
     * build TTemplateErrorHandler class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TTemplateErrorHandlerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TTemplateErrorHandler.create(templateFilename);
    end;

end.
