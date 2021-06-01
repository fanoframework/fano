{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ResponseFactoryImpl;

interface

{$MODE OBJFPC}

uses

    EnvironmentIntf,
    DependencyIntf,
    DependencyContainerIntf,
    ResponseIntf,
    ResponseFactoryIntf,
    FactoryImpl;

type
    (*!------------------------------------------------
     * TResponse factory class
     *------------------------------------------------
     * This class can serve as factory class for TResponse
     * and also can be injected into dependency container
     * directly to build TResponse class
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TResponseFactory = class(TFactory, IResponseFactory, IDependency)
    public
        (*!---------------------------------------------------
         * build response
         *----------------------------------------------------
         * @param container dependency container instance
         *----------------------------------------------------
         * This is implementation of IResponseFactory
         *---------------------------------------------------*)
        function build(const env : ICGIEnvironment) : IResponse;

        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *----------------------------------------------------
         * This is implementation of IDependencyFactory
         *---------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    Classes,
    ResponseImpl,
    HeadersImpl,
    HashListImpl,
    ResponseStreamImpl;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TResponseFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TResponse.create(
            THeaders.create(THashList.create()),
            TResponseStream.create(TStringStream.create(''))
        );
    end;

    (*!---------------------------------------------------
     * build response
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TResponseFactory.build(const env : ICGIEnvironment) : IResponse;
    begin
        result := TResponse.create(
            THeaders.create(THashList.create()),
            TResponseStream.create(TStringStream.create(''))
        );
    end;
end.
