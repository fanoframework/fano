{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RouteUrlIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyKeyValuePairIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * build route relative/absolute url from its name and parameters
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRouteUrl = interface
        ['{D9686A51-7069-463B-A273-BB5D30A551B8}']

        (*!-------------------------------------------
         * build relative URL from route name and its parameter
         *--------------------------------------------
         * @param routeName name of route
         * @param params parameters
         * @return relative url
         *--------------------------------------------*)

        function url(const routeName : string; const params : IReadOnlyKeyValuePair) : string;

        (*!-------------------------------------------
         * build absolute URL from route name and its parameter
         *--------------------------------------------
         * @param routeName name of route
         * @param para name of route
         * @return current instance
         *--------------------------------------------*)
        function absoluteUrl(const routeName : string; const params : IReadOnlyKeyValuePair) : string;

    end;

implementation
end.
