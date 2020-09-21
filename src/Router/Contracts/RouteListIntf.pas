{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RouteListIntf;

interface

{$MODE OBJFPC}

uses
    ListIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * manage and retrieve routes
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRouteList = interface(IList)
        ['{0BE04022-B3E7-4AE9-83F8-829D07F7EB83}']

        (*!-----------------------------------------
         * match item using its transformed key
         *------------------------------------------*)
        function match(const transformedKey : string) : pointer;
    end;

implementation
end.
