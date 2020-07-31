{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpPutFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    HttpAbstractFactoryImpl;

type
    (*!------------------------------------------------
     * THttpPut factory class
     *------------------------------------------------
     * This class can serve as factory class for THttpPut
     * and also can be injected into dependency container
     * directly to build THttpPut class
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpPutFactory = class(THttpAbstractFactory)
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
    HttpPutImpl,
    HttpClientHeadersImpl,
    ResponseStreamImpl,
    QueryStrBuilderImpl;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function THttpPutFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := THttpPut.create(
            handle,
            THttpClientHeaders.create(handle),
            TResponseStream.create(TStringStream.create('')),
            TQueryStrBuilder.create()
        );
    end;
end.
