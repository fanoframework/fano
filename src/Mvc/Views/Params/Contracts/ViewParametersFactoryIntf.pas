{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewParametersFactoryIntf;

interface

{$MODE OBJFPC}

uses

    DependencyContainerIntf,
    ViewParametersIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability
     * create to create IViewParameters instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IViewParametersFactory = interface
        ['{7E64E657-AE48-4E1C-9A0D-EEB37CA64CAB}']

        (*!---------------------------------------------------
         * create view parameters instance
         * ----------------------------------------------------
         * @param container dependency container
         * @return view parameter instance
         *-----------------------------------------------------*)
        function buildViewParam(const container : IDependencyContainer) : IViewParameters;
    end;

implementation

end.
