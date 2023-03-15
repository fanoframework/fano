{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RouteBuilderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyContainerIntf,
    RouterIntf,
    RouteBuilderIntf;

type

    (*!------------------------------------------------
     * base abstract class that can build routes
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TRouteBuilder = class abstract (TInterfacedObject, IRouteBuilder)
    public
        (*!----------------------------------------------
         * build application routes
         * ----------------------------------------------
         * @param cntr instance of dependency container
         * @param rtr instance of router
         *-----------------------------------------------*)
        procedure buildRoutes(const cntr : IDependencyContainer; const rtr : IRouter); virtual; abstract;
    end;

implementation
end.
