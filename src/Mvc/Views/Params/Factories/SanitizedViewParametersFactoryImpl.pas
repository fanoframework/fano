{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SanitizedViewParametersFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    ViewParametersFactoryIntf,
    ViewParametersIntf,
    SanitizerIntf,
    AbstractViewParametersFactoryImpl;

type

    (*!------------------------------------------------
     * basic class that can create sanitized view parameters
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TSanitizedViewParametersFactory = class(TAbstractViewParametersFactory, IDependencyFactory)
    private
        fActualFactory : IViewParametersFactory;
        fSanitizer : ISanitizer;
    public
        constructor create(const actualFactory : IViewParametersFactory);
        function sanitizer(const aSanitizer : ISanitizer) : TSanitizedViewParametersFactory;
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    HtmlEntitiesSanitizerImpl,
    SanitizedViewParametersImpl;

    constructor TSanitizedViewParametersFactory.create(
        const actualFactory : IViewParametersFactory
    );
    begin
        fActualFactory := actualFactory;
        fSanitizer := THtmlEntitiesSanitizer.create();
    end;

    function TSanitizedViewParametersFactory.sanitizer(const aSanitizer : ISanitizer) : TSanitizedViewParametersFactory;
    begin
        fSanitizer := aSanitizer;
        result := self;
    end;

    function TSanitizedViewParametersFactory.build(const container : IDependencyContainer) : IDependency;
    var actualParam : IViewParameters;
    begin
        actualParam := fActualFactory.buildViewParam(container);
        result := TSanitizedViewParameters.create(actualParam, fSanitizer);
    end;
end.
