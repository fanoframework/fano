{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit VerbTunnellingDispatcherFactoryImpl;

interface

{$MODE OBJFPC}

uses
    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!--------------------------------------------------
     * factory class for TVerbTunnellingDispatcher,
     * dispatcher implementation which support
     * http verb tunneling
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TVerbTunnellingDispatcherFactory = class(TFactory, IDependencyFactory)
    private
        fActualFactory : IDependencyFactory;
    public
        constructor create (const actualFactory : IDependencyFactory);
        destructor destroy(); override;
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    DispatcherIntf,
    VerbTunnellingDispatcherImpl;

    constructor TVerbTunnellingDispatcherFactory.create(
        const actualFactory : IDependencyFactory
    );
    begin
        inherited create();
        fActualFactory := actualFactory;
    end;

    destructor TVerbTunnellingDispatcherFactory.destroy();
    begin
        fActualFactory := nil;
        inherited destroy();
    end;

    function TVerbTunnellingDispatcherFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TVerbTunnellingDispatcher.create(
            fActualFactory.build(container) as IDispatcher
        );
    end;

end.
