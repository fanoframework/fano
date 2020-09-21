{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullMiddlewareListFactoryImpl;

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
     * null middleware list instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNullMiddlewareListFactory = class(TFactory, IMiddlewareListFactory)
    public
        function build() : IMiddlewareListItem; overload;
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    NullMiddlewareListImpl;

    function TNullMiddlewareListFactory.build() : IMiddlewareListItem;
    begin
        result := TNullMiddlewareList.create();
    end;

    function TNullMiddlewareListFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := build() as IDependency;
    end;
end.
