{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpDeleteFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    HttpAbstractFactoryImpl;

type
    (*!------------------------------------------------
     * THttpDelete factory class
     *------------------------------------------------
     * This class can serve as factory class for THttpDelete
     * and also can be injected into dependency container
     * directly to build THttpDelete class
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpDeleteFactory = class(THttpAbstractFactory)
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
    HttpDeleteImpl,
    HttpClientHeadersImpl,
    ResponseStreamImpl,
    QueryStrBuilderImpl;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function THttpDeleteFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := THttpDelete.create(
            handle,
            THttpClientHeaders.create(handle),
            TResponseStream.create(TStringStream.create('')),
            TQueryStrBuilder.create()
        );
    end;
end.
