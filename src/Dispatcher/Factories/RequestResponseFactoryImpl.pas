{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RequestResponseFactoryImpl;

interface

{$MODE OBJFPC}

uses

    RequestFactoryIntf,
    ResponseFactoryIntf,
    RequestResponseFactoryIntf,
    InjectableObjectImpl;

type

    (*!---------------------------------------------------
     * interface for any class having capability return
     * request and response factory
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TRequestResponseFactory = class(TInjectableObject, IRequestResponseFactory)
    public
        function getRequestFactory() : IRequestFactory;
        function getResponseFactory() : IResponseFactory;
    end;

implementation

uses

    RequestFactoryImpl,
    ResponseFactoryImpl;

    function TRequestResponseFactory.getRequestFactory() : IRequestFactory;
    begin
        result := TRequestFactory.create();
    end;

    function TRequestResponseFactory.getResponseFactory() : IResponseFactory;
    begin
        result := TResponseFactory.create();
    end;
end.
