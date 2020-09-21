{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MiddlewareListFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    MiddlewareListFactoryIntf,
    MiddlewareListItemIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * basic class having capability to create
     * middleware collection aware instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMiddlewareListFactory = class(TFactory, IMiddlewareListFactory)
    public
        function build() : IMiddlewareListItem; overload;
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    MiddlewareListImpl;

    function TMiddlewareListFactory.build() : IMiddlewareListItem;
    begin
        result := TMiddlewareList.create();
    end;

    function TMiddlewareListFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := build() as IDependency;
    end;
end.
