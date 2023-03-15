{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DecoratorFactoryImpl;

interface

{$MODE OBJFPC}

uses
    DependencyIntf,
    DependencyContainerIntf;

type

    (*!------------------------------------------------
     * class having capability to decorate other factory
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TDecoratorFactory = class (TInterfacedObject, IDependencyFactory)
    protected
        fActualFactory : IDependencyFactory;
    public
        constructor create(const factory : IDependencyFactory);

        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *---------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; virtual;
    end;

implementation

    constructor TDecoratorFactory.create(const factory : IDependencyFactory);
    begin
        fActualFactory := factory;
    end;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TDecoratorFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := fActualFactory.build(container);
    end;

end.
