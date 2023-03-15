{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CombineRouterFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    AbstractRouterFactoryImpl;

type

    (*!------------------------------------------------
     * Factory class for route collection using
     * TCombineRegexRouteList
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCombineRouterFactory = class(TAbstractRouterFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses
    RouterImpl,
    CombineRegexRouteListImpl,
    RegexImpl,
    HashListImpl,
    RouteHandlerFactoryImpl;

    function TCombineRouterFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TRouter.create(
            TCombineRegexRouteList.create(
                TRegex.create(),
                THashList.create()
            ),
            TRouteHandlerFactory.create(getMiddlewareFactory())
        );
    end;

end.
