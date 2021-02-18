{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SocketOptsImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SocketOptsIntf;

type

    (*!------------------------------------------------
     * class having capability setup
     * socket options
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSocketOpts = class(TInterfacedObject, ISocketOpts)
    public

        (*!-----------------------------------------------
        * make socket non blocking
        *-------------------------------------------------
        * @param listenSocket, listen socket handle
        *-----------------------------------------------*)
        procedure makeNonBlocking(fd : longint);

    end;

implementation

uses

    Sockets,
    BaseUnix;

    (*!-----------------------------------------------
     * make file descriptor/socket non blocking
     *-------------------------------------------------
     * @param fd, file descriptor or listen socket handle
     *-----------------------------------------------*)
    procedure TSocketOpts.makeNonBlocking(fd : longint);
    var flags : longint;
    begin
        //read control flag and set socket to be non blocking
        flags := fpFcntl(fd, F_GETFL, 0);
        fpFcntl(fd, F_SETFl, flags or O_NONBLOCK);
    end;

end.
