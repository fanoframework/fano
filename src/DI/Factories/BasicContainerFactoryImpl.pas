{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit BasicContainerFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyContainerIntf,
    ContainerFactoryIntf;

type

    (*!------------------------------------------------
     * class for any class having capability to create
     * basisc
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TBasicContainerFactory = class(TInterfacedObject, IContainerFactory)
    public

        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *---------------------------------------------------*)
        function build() : IDependencyContainer;
    end;

implementation

uses

    DependencyContainerImpl,
    DependencyListImpl;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TBasicContainerFactory.build() : IDependencyContainer;
    begin
        result := TDependencyContainer.create(TDependencyList.create());
    end;

end.
