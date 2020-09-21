{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HtmlAjaxErrorHandlerFactoryImpl;

interface

{$MODE OBJFPC}

uses

    RequestIntf,
    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for THtmlAjaxErrorHandler
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    THtmlAjaxErrorHandlerFactory = class(TFactory, IDependencyFactory)
    private
        request : IRequest;
    public
        (*!---------------------------------------------------
         * constructor
         *----------------------------------------------------
         * @param requestInst request instance
         *---------------------------------------------------*)
        constructor create(const requestInst : IRequest);

        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *---------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    ErrorHandlerImpl,
    AjaxErrorHandlerImpl,
    HtmlAjaxErrorHandlerImpl;

    (*!---------------------------------------------------
     * constructor
     *----------------------------------------------------
     * @param requestInst request instance
     *---------------------------------------------------*)
    constructor THtmlAjaxErrorHandlerFactory.create(const requestInst : IRequest);
    begin
        request := requestInst;
    end;

    (*!---------------------------------------------------
     * build THtmlAjaxErrorHandler class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function THtmlAjaxErrorHandlerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := THtmlAjaxErrorHandler.create(
            request,
            TAjaxErrorHandler.create(),
            TErrorHandler.create()
        );
    end;

end.
