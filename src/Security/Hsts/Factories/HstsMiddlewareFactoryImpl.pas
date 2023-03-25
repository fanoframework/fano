{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HstsMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    RequestHandlerIntf,
    HstsConfig;

type

    (*!------------------------------------------------
     * factory class for THstsMiddleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    THstsMiddlewareFactory = class(TFactory, IDependencyFactory)
    protected
        fHstsConfig: THtstConfig;
    public
        constructor create();

        function maxAge(const ageInSecs: integer): THstsMiddlewareFactory;
        function includeSubDomains(const value: boolean): THstsMiddlewareFactory;

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

    HstsMiddlewareImpl;


    constructor THstsMiddlewareFactory.create();
    begin
        fHstsConfig := default(THtstConfig);
    end;

    function THstsMiddlewareFactory.maxAge(const ageInSecs: integer): THstsMiddlewareFactory;
    begin
        fHstsConfig.maxAge := ageInSecs;
        result := self;
    end;

    function THstsMiddlewareFactory.includeSubDomains(const value: boolean): THstsMiddlewareFactory;
    begin
        fHstsConfig.includeSubDomains := value;
        result := self;
    end;

    function THstsMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := THstsMiddleware.create(fHstsConfig);
    end;

end.
