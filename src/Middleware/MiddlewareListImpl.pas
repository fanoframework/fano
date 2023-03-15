{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MiddlewareListImpl;

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
     * Basic class having capability to manage one or
     * more middlewares
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMiddlewareList = class(TInjectableObject, IMiddlewareList, IMiddlewareLinkList, IMiddlewareListItem)
    private
        middlewareList : TInterfaceList;
    public
        constructor create();
        destructor destroy(); override;
        function add(const middleware : IMiddleware) : IMiddlewareList;
        function get(const indx : integer) : IMiddlewareLink;
        function count() : integer;
        function asLinkList() : IMiddlewareLinkList;
        function asList() : IMiddlewareList;
    end;

implementation

uses

    MiddlewareLinkImpl;

    constructor TMiddlewareList.create();
    begin
        middlewareList := TInterfaceList.create();
    end;

    destructor TMiddlewareList.destroy();
    var i : integer;
        alink : IMiddlewareLink;
    begin
        for i := middlewareList.count - 1 downto 0 do
        begin
            //make sure we release reference other middleware
            //link so they can properly freed to avoid memory leak
            alink := middlewareList[i] as IMiddlewareLink;
            alink.next := nil;

            middlewareList.delete(i);
        end;
        middlewareList.free();
        inherited destroy();
    end;

    function TMiddlewareList.add(const middleware : IMiddleware) : IMiddlewareList;
    var prevLink, newLink : IMiddlewareLink;
    begin
        try
            newLink := TMiddlewareLink.create(middleware);
            if (middlewareList.count > 0) then
            begin
                prevLink := middlewareList[middlewareList.count - 1] as IMiddlewareLink;
                prevLink.next := newLink;
            end;
            middlewareList.add(newLink);
            result := self;
        except
            prevLink.next := nil;
            prevLink := nil;
            newLink := nil;
            raise;
        end;
    end;

    function TMiddlewareList.get(const indx : integer) : IMiddlewareLink;
    begin
        result := middlewareList[indx] as IMiddlewareLink;
    end;

    function TMiddlewareList.count() : integer;
    begin
        result := middlewareList.count;
    end;

    function TMiddlewareList.asLinkList() : IMiddlewareLinkList;
    begin
        result := self;
    end;

    function TMiddlewareList.asList() : IMiddlewareList;
    begin
        result := self;
    end;
end.
