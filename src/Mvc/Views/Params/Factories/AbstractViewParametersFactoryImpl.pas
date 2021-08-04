{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractViewParametersFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    ViewParametersFactoryIntf,
    ViewParametersIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * base abstract class having capability to create view parameters
     * instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAbstractViewParametersFactory = class abstract (TFactory, IDependencyFactory, IViewParametersFactory)
    public

        (*!---------------------------------------------------
         * create view parameters instance
         * ----------------------------------------------------
         * @param container dependency container
         * @return view parameters
         *-----------------------------------------------------*)
        function buildViewParam(
            const container : IDependencyContainer
        ) : IViewParameters; virtual;

    end;

implementation

    (*!---------------------------------------------------
     * create view parameteres instance
     * ----------------------------------------------------
     * @param container dependency container
     * @return view parameters
     *-----------------------------------------------------*)
    function TAbstractViewParametersFactory.buildViewParam(
        const container : IDependencyContainer
    ) : IViewParameters;
    begin
        result := build(container) as IViewParameters;
    end;
end.

