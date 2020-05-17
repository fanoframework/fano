{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SimpleRegexRouteListImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    ListIntf,
    RouteListIntf,
    HashListImpl,
    RegexIntf,
    PlaceholderTypes,
    RouteDataTypes;

type

    (*!------------------------------------------------
     * class that store list of routes patterns and its
     * associated data and match uri to retrieve matched
     * patterns and its data
     *
     * This class match all routes by iterating all registered
     * route and match them against regex pattern
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     * -----------------------------------------------*)
    TSimpleRegexRouteList = class(TInterfacedObject, IList, IRouteList)
    private
        regex : IRegex;
        hashesList : IList;

        function getPlaceholderFromOriginalRoute(
            const originalRouteWithRegex : string
        ) : TArrayOfPlaceholders;

        function getPlaceholderValuesFromUri(
             const matches : TRegexMatchResult;
             const placeHolders : TArrayOfPlaceholders
        ) : TArrayOfPlaceholders;

        procedure clearRoutes();
        function translateRouteName(const originalRouteWithRegex : string) : string;
    public
        constructor create(const regexInst : IRegex; const hashes : IList);
        destructor destroy(); override;

        (*!------------------------------------------------
         * add route pattern to list
         *-------------------------------------------------
         * @param routeName original route as defined by app
         *   /name/{name}/{unitId}/edback
         * @param routeData, pointer to route data (such handler, etc)
         * @return integer index of added item in list
         *---------------------------------------------------*)
        function add(const routeName : shortstring; const routeData : pointer) : integer;

        (*------------------------------------------------
         * match request uri with route list and return
         * its associated data
         *---------------------------------------------------*)
        function match(const requestUri : shortstring) : pointer;

        (*------------------------------------------------
         * match request uri with route list and return
         * its associated data
         *---------------------------------------------------*)
        function find(const key : shortstring) : pointer;

        function count() : integer;
        function get(const indx : integer) : pointer;
        procedure delete(const indx : integer);
        function keyOfIndex(const indx : integer) : shortstring;

        (*!------------------------------------------------
         * delete item by key
         *-----------------------------------------------
         * @param key name to use to associate item
         * @return item being removed
         *-----------------------------------------------
         * implementor is free to decide whether delete
         * item in list only or also free item memory
         *-----------------------------------------------*)
        function remove(const key : shortstring) : pointer;

        (*!------------------------------------------------
         * get index by key name
         *-----------------------------------------------
         * @param key name
         * @return index of key
         *-----------------------------------------------*)
        function indexOf(const key : shortstring) : integer;
    end;

implementation

uses

    sysutils,
    ERouteMatcherImpl;

resourcestring

    sTotalPlaceHolderAndValueNotEqual = 'Number of variable placeholders (%d) and values (%d) not equal.';

const
    (*-------------------------------------------------
      regex pattern that will match following string format
      and extract placeholder variable name inside {}

      /store/{ storeId }/feedback
      /name/{name-id}/{unitId}/edback
      /name/{name}/{unitId}/edback
      /name/{ tr }/{unitId}/edback

      This class DOES NOT support syntax such as
      /store/{storeId:[a-zA-Z0-9]+}/feedback
    -------------------------------------------------*)
    ROUTE_PLACEHOLDER_REGEX = '\{\s*([a-zA-Z_][a-zA-Z0-9_\-]*)\s*\}';

    (*-------------------------------------------------
      regex pattern that will be used to replace original
      route pattern. The replaced route pattern md5-hashed
      will be stored inside list
    -------------------------------------------------*)
    ROUTE_DISPATCH_REGEX = '([^/]+)';

    constructor TSimpleRegexRouteList.create(const regexInst : IRegex; const hashes : IList);
    begin
        hashesList := hashes;
        regex := regexInst;
    end;

    destructor TSimpleRegexRouteList.destroy();
    begin
        inherited destroy();
        clearRoutes();
        regex := nil;
        hashesList := nil;
    end;

    procedure TSimpleRegexRouteList.clearRoutes();
    var i, len : integer;
    begin
        len := count();
        for i := len -1 downto 0 do
        begin
            hashesList.delete(i);
        end;
    end;

    (*------------------------------------------------
     * get placeholder variable original
     *------------------------------------------------
     * for example for route pattern :
     *  /name/{name}/{unitId}/edback
     *
     *  It will returns array of placeholder like below
     *
     * [
     *  {
     *    name : 'name',
     *    value : '',
     *  }
     *  {
     *    name : 'unitId',
     *    value : '',
     *  }
     * ]
     *
     * This method will be called when a route pattern is
     * added to route collection. At this time,
     * placeholder value is not yet known ,so value field
     * will always be empty
     *
     *---------------------------------------------------*)
    function TSimpleRegexRouteList.getPlaceholderFromOriginalRoute(
        const originalRouteWithRegex : string
    ) : TArrayOfPlaceholders;
    var matches : TRegexMatchResult;
        i, totalPlaceholder : integer;
    begin
        matches := regex.greedyMatch(
            ROUTE_PLACEHOLDER_REGEX,
            originalRouteWithRegex
        );

        if (not matches.matched) then
        begin
            result := nil;
            exit;
        end;

        totalPlaceholder := length(matches.matches);

        (*----------------------------
          if route is registered as:
          /name/{name}/{unitId}/edback

          matches will contain following data:

          length(matches.matches) == 2
          matches.matched = true
          matches.matches[0][0] = '{name}'
          matches.matches[0][1] = 'name'
          matches.matches[1][0] = '{unidId}'
          matches.matches[1][1] = 'unitId'

          So to extract variable names, we
          only need to extract from

          matches.matches[n][1]
          where n=0..length(matches.matches)-1
         ----------------------------*)
        setLength(result, totalPlaceholder);
        for i:=0 to totalPlaceholder-1 do
        begin
            result[i].name := matches.matches[i][1];
            result[i].value := '';
        end;
    end;

    (*------------------------------------------------
     * get placeholder value from uri
     *------------------------------------------------
     * after a route is matched, then this method will be
     * called with matched route, original uri and placeholder
     * for example for route pattern :
     *  /name/{name}/{unitId}/edback
     * and actual Request Uri
     * /name/juhara/nice/edback
     *
     *  It will returns array of placeholder like below
     *
     * [
     *  {
     *    name : 'name'
     *    value : 'juhara'
     *  }
     *  {
     *    name : 'unitId'
     *    value : 'nice'
     *  }
     * ]
     *
     *---------------------------------------------------*)
    function TSimpleRegexRouteList.getPlaceholderValuesFromUri(
         const matches : TRegexMatchResult;
         const placeHolders : TArrayOfPlaceholders
    ) : TArrayOfPlaceholders;
    var i, totalValue, totalPlaceHolders : longint;
    begin
        totalPlaceHolders := length(placeholders);

        //matches.matches will always contain 1 element
        //totalValue will contain number of placeholder+1 (full match)
        totalValue := length(matches.matches[0])-1;

        if (totalPlaceHolders <> totalValue) then
        begin
            //Something is wrong as both must be equal!
            raise ERouteMatcher.createFmt(
                sTotalPlaceHolderAndValueNotEqual,
                [totalPlaceHolders, totalValue]
            )
        end;

        (*----------------------------
          if we get here then placeholders will contain
          data that is same as output getPlaceholderFromOriginalRoute
          So we do not need to call setLength() anymore

          if request uri is
          /name/juhara/nice/edback

          matches will contain following data:

          length(matches.matches) == 3
          matches.matched = true
          matches.matches[0][0] = '/name/juhara/nice/edback'

          matches.matches[0][1] = 'juhara'

          matches.matches[0][2] = 'nice'

          So to extract value names, we
          only need to extract from

          matches.matches[0][n]
          where n=1..length(matches.matches)-1
         ----------------------------*)
        for i:=0 to totalPlaceholders-1 do
        begin
            //placeholders[i].name already contain variable name
            //so our concern only to fill its value
            placeholders[i].value := matches.matches[0][i+1];
        end;
        result := placeHolders;
    end;

    (*------------------------------------------------
     * replace original route pattern with regex pattern
     * ready for dispatch
     * ----------------------------------------------
     * @param originalRouteWithRegex original route pattern
     * @return transformedRouteName
     * -----------------------------------------------
     * replace original route pattern :
     *   /name/{name}/{unitId}/edback
     *
     * into route pattern ready for dispatch
     * /name/([^/]+)/([^/]+)/edback
     *
     * See ROUTE_DISPATCH_REGEX constant
     *---------------------------------------------------*)
    function TSimpleRegexRouteList.translateRouteName(const originalRouteWithRegex : string) : string;
    begin
        result := regex.replace(
            ROUTE_PLACEHOLDER_REGEX,
            originalRouteWithRegex,
            ROUTE_DISPATCH_REGEX
        );
    end;

    (*!------------------------------------------------
     * add route pattern to list
     *-------------------------------------------------
     * @param routeName original route as defined by app
     *   /name/{name}/{unitId}/edback
     * @param routeData, pointer to route data (such handler, etc)
     * @return integer index of added item in list
     *-------------------------------------------------
     *
     * If we have following input route name
     *   /name/{name}/{unitId}/edback
     * (1) we will extract placeholder data
     *     into array of placeholder
     *     [
     *         {
     *             name : 'name',
     *             value : ''
     *         },
     *         {
     *             name : 'unitId'
     *             value : ''
     *         }
     *     ]
     * (2) replace route name into new regex string (transformed route name) as
     *   /name/([^/]+)/([^/]+)/edback
     * (3) store transformed route name into list
     *---------------------------------------------------*)
    function TSimpleRegexRouteList.add(const routeName : shortstring; const routeData : pointer) : integer;
    var routeRec : PRouteRec;
    begin
        routeRec := routeData;
        routeRec^.placeholders := getPlaceholderFromOriginalRoute(routeName);
        result := hashesList.add(translateRouteName(routeName), routeRec);
    end;

    (*!-----------------------------------------
     * match request uri with route list and return
     * its associated data
     *------------------------------------------*)
    function TSimpleRegexRouteList.match(const requestUri : shortstring) : pointer;
    var i, len : integer;
        regexPattern : string;
        matches : TRegexMatchResult;
        routeRec : PRouteRec;
    begin
        result := nil;
        len := count();
        for i:=0 to len-1 do
        begin
            regexPattern := '^' + keyOfIndex(i) + '$';
            matches := regex.match(regexPattern, requestUri);
            if (matches.matched) then
            begin
                routeRec := get(i);
                routeRec^.placeholders := getPlaceholderValuesFromUri(
                    matches,
                    routeRec^.placeholders
                );
                result := routeRec;
                exit;
            end;
        end;
    end;

    (*------------------------------------------------
     * find data using its key
     *---------------------------------------------------*)
    function TSimpleRegexRouteList.find(const key : shortstring) : pointer;
    begin
        result := hashesList.find(translateRouteName(key));
    end;

    function TSimpleRegexRouteList.count() : integer;
    begin
        result := hashesList.count();
    end;

    function TSimpleRegexRouteList.get(const indx : integer) : pointer;
    begin
        result := hashesList.get(indx);
    end;

    procedure TSimpleRegexRouteList.delete(const indx : integer);
    begin
        hashesList.delete(indx);
    end;

    function TSimpleRegexRouteList.remove(const key : shortstring) : pointer;
    begin
        result := hashesList.remove(translateRouteName(key));
    end;

    function TSimpleRegexRouteList.keyOfIndex(const indx : integer) : shortstring;
    begin
        result := hashesList.keyOfIndex(indx);
    end;

    (*!------------------------------------------------
     * get index by key name
     *-----------------------------------------------
     * @param key name
     * @return index of key
     *-----------------------------------------------*)
    function TSimpleRegexRouteList.indexOf(const key : shortstring) : integer;
    begin
        result := hashesList.indexOf(key);
    end;
end.
