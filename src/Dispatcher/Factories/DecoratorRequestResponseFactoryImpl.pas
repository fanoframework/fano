{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorRequestResponseFactoryImpl;

interface

{$MODE OBJFPC}

uses

    RequestFactoryIntf,
    ResponseFactoryIntf,
    RequestResponseFactoryIntf,
    InjectableObjectImpl;

type

    (*!---------------------------------------------------
     * class having capability return request and response
     * factory which decorates other factory
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TDecoratorRequestResponseFactory = class(TInjectableObject, IRequestResponseFactory)
    protected
        fActualFactory : IRequestResponseFactory;
    public
        constructor create(const factory : IRequestResponseFactory);
        function getRequestFactory() : IRequestFactory; virtual;
        function getResponseFactory() : IResponseFactory; virtual;
    end;

implementation

    constructor TDecoratorRequestResponseFactory.create(const factory : IRequestResponseFactory);
    begin
        fActualFactory := factory;
    end;

    function TDecoratorRequestResponseFactory.getRequestFactory() : IRequestFactory;
    begin
        result := fActualFactory.getRequestFactory();
    end;

    function TDecoratorRequestResponseFactory.getResponseFactory() : IResponseFactory;
    begin
        result := fActualFactory.getResponseFactory();
    end;
end.
