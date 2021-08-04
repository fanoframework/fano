{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullViewParametersFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    AbstractViewParametersFactoryImpl;

type

    (*!------------------------------------------------
     * class having capability to create view parameters
     * instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNullViewParametersFactory = class(TAbstractViewParametersFactory, IDependencyFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    NullViewParametersImpl;

    function TNullViewParametersFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TNullViewParameters.create();
    end;
end.
