{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompositeRouteBuilderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyContainerIntf,
    RouterIntf,
    RouteBuilderIntf,
    RouteBuilderImpl;

type

    TRouteBuilderArray = array of IRouteBuilder;

    (*!------------------------------------------------
     * class that can build routes from one or more
     * external route builders
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCompositeRouteBuilder = class (TRouteBuilder)
    private
        fRouteBuilders : TRouteBuilderArray;
    public
        constructor create(const builders : array of IRouteBuilder);
        destructor destroy(); override;

        (*!----------------------------------------------
         * build application routes
         * ----------------------------------------------
         * @param cntr instance of dependency container
         * @param rtr instance of router
         *-----------------------------------------------*)
        procedure buildRoutes(const cntr : IDependencyContainer; const rtr : IRouter); override;
    end;

implementation

    function initBuilders(const aBuilders : array of IRouteBuilder) : TRouteBuilderArray;
    var i, len : integer;
    begin
        result := default(TRouteBuilderArray);
        len := high(aBuilders) - low(aBuilders) + 1;
        setLength(result, len);
        for i := 0 to len -1 do
        begin
            result[i] := aBuilders[i];
        end;
    end;

    function freeBuilders(var aBuilders : TRouteBuilderArray) : TRouteBuilderArray;
    var i, len : integer;
    begin
        len := length(aBuilders);
        for i := 0 to len -1 do
        begin
            aBuilders[i] := nil;
        end;
        setLength(aBuilders, 0);
        aBuilders := nil;
        result := aBuilders;
    end;

    constructor TCompositeRouteBuilder.create(const builders : array of IRouteBuilder);
    begin
        fRouteBuilders := initBuilders(builders);
    end;

    destructor TCompositeRouteBuilder.destroy();
    begin
        fRouteBuilders := freeBuilders(fRouteBuilders);
        inherited destroy();
    end;

    (*!----------------------------------------------
     * build application routes
     * ----------------------------------------------
     * @param cntr instance of dependency container
     * @param rtr instance of router
     *-----------------------------------------------*)
    procedure TCompositeRouteBuilder.buildRoutes(const cntr : IDependencyContainer; const rtr : IRouter);
    var i, len : integer;
    begin
        len := length(fRouteBuilders);
        for i := 0 to len - 1 do
        begin
            fRouteBuilders[i].buildRoutes(cntr, rtr);
        end;
    end;
end.
