{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ReferrerPolicyMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    RequestHandlerIntf,
    ReferrerPolicyConfig;

type

    (*!------------------------------------------------
     * factory class for TReferrerPolicyMiddleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TReferrerPolicyMiddlewareFactory = class(TFactory, IDependencyFactory)
    protected
        fReferrerPolicyConfig: TReferrerPolicyConfig;
    public
        constructor create(const policy: TReferrerPolicyConfig);

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

    ReferrerPolicyMiddlewareImpl;


    constructor TReferrerPolicyMiddlewareFactory.create(const policy: TReferrerPolicyConfig);
    begin
        fReferrerPolicyConfig := policy;
    end;

    function TReferrerPolicyMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TReferrerPolicyMiddleware.create(fReferrerPolicyConfig);
    end;

end.
