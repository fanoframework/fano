{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompositeServiceProviderImpl;

interface

{$MODE OBJFPC}

uses

    ServiceProviderIntf,
    DependencyContainerIntf;

type

    TServiceProviderArray = array of IServiceProvider;

    (*!-----------------------------------------------
     * Base class that can register service using array
     * of external service providers
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *------------------------------------------------*)
    TCompositeServiceProvider = class(TInterfacedObject, IServiceProvider)
    private
        fProviders : TServiceProviderArray;
    public
        constructor create(const providers : array of IServiceProvider);
        destructor destroy(); override;

        (*!--------------------------------------------------------
         * register all services
         *---------------------------------------------------------
         * @param container service container
         *---------------------------------------------------------*)
        procedure register(const container : IDependencyContainer);

    end;

implementation

    constructor TCompositeServiceProvider.create(const providers : array of IServiceProvider);
    var i, tot : integer;
    begin
        tot := high(providers) - low(providers) + 1;
        setLength(fProviders, tot);
        for i:= 0 to tot-1 do
        begin
            fProviders[i] := providers[i];
        end;
    end;

    destructor TCompositeServiceProvider.destroy();
    begin
        setLength(fProviders, 0);
        fProviders := nil;
        inherited destroy();
    end;

    (*!--------------------------------------------------------
     * register all services
     *---------------------------------------------------------
     * @param container service container
     *---------------------------------------------------------*)
    procedure TCompositeServiceProvider.register(const container : IDependencyContainer);
    var i : integer;
    begin
        for i:= low(fProviders) to high(fProviders) do
        begin
            fProviders[i].register(container);
        end;
    end;
end.
