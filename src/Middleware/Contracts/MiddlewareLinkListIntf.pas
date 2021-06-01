{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MiddlewareLinkListIntf;

interface

{$MODE OBJFPC}

uses

    MiddlewareLinkIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * get one or more middleware links
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IMiddlewareLinkList = interface
        ['{B2F20BDE-CDE9-4EBC-8439-0817B31F3E5D}']
        function get(const indx : integer) : IMiddlewareLink;
        function count() : integer;
    end;

implementation

end.
