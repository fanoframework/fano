{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpGetFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    HttpAbstractFactoryImpl;

type
    (*!------------------------------------------------
     * THttpGet factory class
     *------------------------------------------------
     * This class can serve as factory class for THttpGet
     * and also can be injected into dependency container
     * directly to build THttpGet class
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpGetFactory = class(THttpAbstractFactory)
    public
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

    classes,
    HttpGetImpl,
    HttpClientHeadersImpl,
    ResponseStreamImpl,
    QueryStrBuilderImpl;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function THttpGetFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := THttpGet.create(
            handle,
            THttpClientHeaders.create(handle),
            TResponseStream.create(TStringStream.create('')),
            TQueryStrBuilder.create()
        );
    end;
end.
