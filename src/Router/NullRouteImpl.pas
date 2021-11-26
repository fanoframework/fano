{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullRouteImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RouteIntf,
    MiddlewareIntf;

type

    (*!------------------------------------------------
     * null class having capability to manage route data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNullRoute = class (TInterfacedObject, IRoute)
    public
        (*!-------------------------------------------
         * Set route name
         *--------------------------------------------
         * @param routeName name of route
         * @return current instance
         *--------------------------------------------*)
        function setName(const routeName : shortstring) : IRoute;

        (*!-------------------------------------------
         * get route name
         *--------------------------------------------
         * @return current route name
         *--------------------------------------------*)
        function getName() : shortstring;

        (*!-------------------------------------------
         * attach middleware before route
         *--------------------------------------------
         * @return current route instance
         *--------------------------------------------*)
        function add(const amiddleware : IMiddleware) : IRoute;

    end;

implementation

    (*!-------------------------------------------
     * Set route name
     *--------------------------------------------
     * @param routeName name of route
     * @return current instance
     *--------------------------------------------*)
    function TNullRoute.setName(const routeName : shortstring) : IRoute;
    begin
        //intentionally does nothing
        result := self;
    end;

    (*!-------------------------------------------
     * get route name
     *--------------------------------------------
     * @return current route name
     *--------------------------------------------*)
    function TNullRoute.getName() : shortstring;
    begin
        //intentionally des nothing
        result := '';
    end;

    (*!-------------------------------------------
     * attach middleware before route
     *--------------------------------------------
     * @return current route instance
     *--------------------------------------------*)
    function TNullRoute.add(const amiddleware : IMiddleware) : IRoute;
    begin
        //intentionally does nothing
        result := self;
    end;
end.
