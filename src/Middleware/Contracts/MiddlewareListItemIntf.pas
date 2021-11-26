{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MiddlewareListItemIntf;

interface

{$MODE OBJFPC}

uses

    MiddlewareListIntf,
    MiddlewareLinkListIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * manage one or more middleware links
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IMiddlewareListItem = interface
        ['{711194A7-630F-46E9-AE06-A5D5B384E5A0}']
        function asLinkList() : IMiddlewareLinkList;
        function asList() : IMiddlewareList;
    end;

implementation

end.
