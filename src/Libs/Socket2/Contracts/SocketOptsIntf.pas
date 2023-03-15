{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SocketOptsIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability setup
     * socket options
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ISocketOpts = interface
        ['{819107E1-0574-4AC0-BC71-9E2B53AF26C2}']

        (*!-----------------------------------------------
        * make file descriptor, socket non blocking
        *-------------------------------------------------
        * @param listenSocket, listen socket handle
        *-----------------------------------------------*)
        procedure makeNonBlocking(fd : longint);

    end;

implementation

end.
