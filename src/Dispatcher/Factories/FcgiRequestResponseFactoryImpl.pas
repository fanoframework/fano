{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiRequestResponseFactoryImpl;

interface

{$MODE OBJFPC}

uses

    RequestFactoryIntf,
    ResponseFactoryIntf,
    RequestResponseFactoryIntf,
    FcgiRequestIdAwareIntf,
    InjectableObjectImpl;

type

    (*!---------------------------------------------------
     * interface for any class having capability return
     * request and response factory
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TFcgiRequestResponseFactory = class(TInjectableObject, IRequestResponseFactory)
    private
        fRequestIdAware : IFcgiRequestIdAware;
    public
        constructor create(const requestIdAware : IFcgiRequestIdAware);
        destructor destroy(); override;
        function getRequestFactory() : IRequestFactory;
        function getResponseFactory() : IResponseFactory;
    end;

implementation

uses

    FcgiRequestFactoryImpl,
    ResponseFactoryImpl;

    constructor TFcgiRequestResponseFactory.create(const requestIdAware : IFcgiRequestIdAware);
    begin
        inherited create();
        fRequestIdAware := requestIdAware;
    end;

    destructor TFcgiRequestResponseFactory.destroy();
    begin
        fRequestIdAware := nil;
        inherited destroy();
    end;

    function TFcgiRequestResponseFactory.getRequestFactory() : IRequestFactory;
    begin
        result := TFcgiRequestFactory.create(fRequestIdAware);
    end;

    function TFcgiRequestResponseFactory.getResponseFactory() : IResponseFactory;
    begin
        result := TResponseFactory.create();
    end;
end.
