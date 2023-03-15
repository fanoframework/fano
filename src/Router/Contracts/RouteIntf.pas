{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RouteIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    MiddlewareIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * manage route data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRoute = interface
        ['{1AE2D1F8-8B20-4B68-9094-07A2B6706F2C}']

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
end.
