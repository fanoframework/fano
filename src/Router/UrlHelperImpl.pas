{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RouteUrlBuilderIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyContainerIntf,
    RouteUrlBuilderIntf,
    ReadOnlyKeyValuePairIntf,
    RouteListIntf;

type

    (*!------------------------------------------------
     * helper class that that can build url from route
     * name
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TUrlHelper = class(TInjectableObject, IRouteUrlBuilder)
    private
        fBaseUrl : string;
        fRouteList : IRouteList;
        fRegex : IRegex;
    public
        constructor create(
            const baseUrl : string;
            const routeList : IRouteList;
            const regexInst : IRegex
        );
        destructor destroy(); override;

        (*!----------------------------------------------
         * build absolute URL from route name
         * ----------------------------------------------
         * @param routeName name of route
         * @param data key value pair
         * @return absolute URL
         *-----------------------------------------------*)
        function absoluteUrl(
            const routeName : string;
            const data : IReadOnlyKeyValuePair
        ) : string;

        (*!----------------------------------------------
         * build relative URL from route name
         * ----------------------------------------------
         * @param routeName name of route
         * @param data key value pair
         * @return relative URL
         *-----------------------------------------------*)
        function relativeUrl(
            const routeName : string;
            const data : IReadOnlyKeyValuePair
        ) : string;
    end;

implementation

    constructor TUrlHelper.create(
        const baseUrl : string;
        const routeList : IRouteList;
        const regexInst : IRegex
    );
    begin
        fBaseUrl := baseUrl;
        fRouteList := routeList;
        fRegex := regexInst;
    end;

    destructor TUrlHelper.destroy();
    begin
        fRouteList := nil;
        fRegex := nil;
        inherited destroy();
    end;

    (*!----------------------------------------------
     * build absolute URL from route name
     * ----------------------------------------------
     * @param routeName name of route
     * @param data key value pair
     * @return absolute URL
     *-----------------------------------------------*)
    function TUrlHelper.absoluteUrl(
        const routeName : string;
        const data : IReadOnlyKeyValuePair
    ) : string;
    begin
        result := relativeUrl(routeName, data);
        result := fBaseUrl + result;
    end;

    (*!----------------------------------------------
     * build relative URL from route name
     * ----------------------------------------------
     * @param routeName name of route
     * @param data key value pair
     * @return relative URL
     *-----------------------------------------------*)
    function TUrlHelper.relativeUrl(
        const routeName : string;
        const data : IReadOnlyKeyValuePair
    ) : string;
    var key : string;
        value : string;
    begin
        result := fRouteList.findByName(routeName).urlPattern;
        for i := 0 to data.count - 1 do
        begin
            key := data.getKey(i);
            value := data.getValue(key);
            result := fRegex.replace('\{\s*'+ key +'\s*.*\}', result, value);
        end;
    end;
end.
