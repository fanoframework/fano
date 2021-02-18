{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonContentTypeMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TCsrfMiddleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TJsonContentTypeMiddlewareFactory = class(TFactory, IDependencyFactory)
    public
        (*!---------------------------------------
         * build middleware instance
         *----------------------------------------
         * @param container dependency container
         * @return instance of middleware
         *----------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    JsonContentTypeMiddlewareImpl;

    function TJsonContentTypeMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TJsonContentTypeMiddleware.create();
    end;

end.
