{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FrameGuardMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    RequestHandlerIntf;

type

    (*!------------------------------------------------
     * factory class for TFrameGuardMiddleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TFrameGuardMiddlewareFactory = class(TFactory, IDependencyFactory)
    private
        fAction : string;
    public
        function deny() : TFrameGuardMiddlewareFactory;
        function sameOrigin() : TFrameGuardMiddlewareFactory;
        function allowFrom(const domain : string) : TFrameGuardMiddlewareFactory;

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

    FrameGuardConsts,
    FrameGuardMiddlewareImpl;

    function TFrameGuardMiddlewareFactory.deny() : TFrameGuardMiddlewareFactory;
    begin
        fAction := XFRAMEOPT_DENY;
        result := self;
    end;

    function TFrameGuardMiddlewareFactory.sameOrigin() : TFrameGuardMiddlewareFactory;
    begin
        fAction := XFRAMEOPT_SAMEORIGIN;
        result := self;
    end;

    function TFrameGuardMiddlewareFactory.allowFrom(const domain : string) : TFrameGuardMiddlewareFactory;
    begin
        if (domain <> '') then
        begin
            fAction := XFRAMEOPT_ALLOWFROM + ' ' + domain;
        end;
        result := self;
    end;

    function TFrameGuardMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TFrameGuardMiddleware.create(fAction);
    end;

end.
