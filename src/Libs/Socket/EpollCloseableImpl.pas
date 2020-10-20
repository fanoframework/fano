{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EpollCloseableImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    CloseableIntf,
    StreamIdIntf;

type

    (*!-----------------------------------------------
     * implementation that can be close socket and
     * remove from epoll monitoring
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TEpollCloseable = class(TInterfacedObject, ICloseable, IStreamId)
    private
        fEpollHandle : longint;
        fHandle : THandle;
    public
        constructor create(const epollHandle : longint; const ahandle: THandle);
        function close() : boolean;
        function getId() : shortstring;
    end;

implementation

uses

    SysUtils,
    sockets,
    baseunix,
    unix,
    linux;

    constructor TEpollCloseable.create(
        const epollHandle : longint;
        const ahandle: THandle
    );
    begin
        fEpollHandle := epollHandle;
        fHandle := aHandle;
    end;

    function TEpollCloseable.close() : boolean;
    var ev : TEpoll_Event;
    begin
        //for EPOLL_CTRL_DEL, epoll_event is ignored but
        //due to bug, Linux kernel < 2.6.9 requires non-NULL,
        //here we just give them although not used.
        ev.events := EPOLLIN;
        ev.data.fd := fHandle;
        epoll_ctl(fEpollHandle, EPOLL_CTL_DEL, fHandle, @ev);

        //we need to close socket after remove from epoll,
        //@link https://idea.popcount.org/2017-03-20-epoll-is-fundamentally-broken-22/
        closeSocket(fHandle);
        result := true;
    end;

    function TEpollCloseable.getId() : shortstring;
    begin
        result := intToHex(fHandle, 16);
    end;
end.
