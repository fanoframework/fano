{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpGetLogFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    HttpClientHandleAwareIntf,
    HttpAbstractFactoryImpl,
    LoggerIntf;

type
    (*!------------------------------------------------
     * THttpGet factory class
     *------------------------------------------------
     * This class can serve as factory class for THttpGet
     * with stream logging and also can be injected into
     * dependency container directly to build THttpGet class
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpGetLogFactory = class(THttpAbstractFactory)
    private
        logger : ILogger;
    public
        constructor create(
            const handleInst : IHttpClientHandleAware;
            const loggerInst : ILogger);
        destructor destroy(); override;

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
    ResponseStreamImpl,
    ResponseStreamLogImpl,
    HttpClientHeadersImpl,
    QueryStrBuilderImpl;

    constructor THttpGetLogFactory.create(
        const handleInst : IHttpClientHandleAware;
        const loggerInst : ILogger
    );
    begin
        inherited create(handleInst);
        logger := loggerInst;
    end;

    destructor THttpGetLogFactory.destroy();
    begin
        inherited destroy();
        logger := nil;
    end;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function THttpGetLogFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := THttpGet.create(
            handle,
            THttpClientHeaders.create(handle),
            TResponseStreamLog.create(
                TResponseStream.create(TStringStream.create('')),
                logger
            ),
            TQueryStrBuilder.create()
        );
    end;
end.
