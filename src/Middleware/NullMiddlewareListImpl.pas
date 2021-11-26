{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullMiddlewareListImpl;

interface

{$MODE OBJFPC}

uses

    classes,
    MiddlewareIntf,
    MiddlewareLinkIntf,
    MiddlewareListIntf,
    MiddlewareLinkListIntf,
    MiddlewareListItemIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * Null class that implement middleware list interfaces
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNullMiddlewareList = class(TInjectableObject, IMiddlewareList, IMiddlewareLinkList, IMiddlewareListItem)
    public
        function add(const middleware : IMiddleware) : IMiddlewareList;
        function get(const indx : integer) : IMiddlewareLink;
        function count() : integer;
        function asLinkList() : IMiddlewareLinkList;
        function asList() : IMiddlewareList;
    end;

implementation

    function TNullMiddlewareList.add(const middleware : IMiddleware) : IMiddlewareList;
    begin
        result := self;
    end;

    function TNullMiddlewareList.get(const indx : integer) : IMiddlewareLink;
    begin
        result := nil;
    end;

    function TNullMiddlewareList.count() : integer;
    begin
        result := 0;
    end;

    function TNullMiddlewareList.asLinkList() : IMiddlewareLinkList;
    begin
        result := self;
    end;

    function TNullMiddlewareList.asList() : IMiddlewareList;
    begin
        result := self;
    end;
end.
