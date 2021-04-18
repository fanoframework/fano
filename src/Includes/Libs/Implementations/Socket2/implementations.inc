{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * redeclare all class types in unit inside Libs/Socket
 * directory
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

Socket2SvrImpl,

{$IFDEF unix}
UnixSocketImpl,
{$ENDIF}
InetSocketImpl,
Inet6SocketImpl,
BoundSocketImpl,

AbstractIoHandlerImpl,

{$IFDEF LINUX}
EpollIoHandlerImpl,
{$ENDIF}

SelectIoHandlerImpl,

{$IFDEF FREEBSD}
    {$IFDEF USE_KQUEUE}
    KqueueIoHandlerImpl,
    {$ENDIF}
{$ENDIF}

SocketOptsImpl,

InetSvrFactoryImpl,
Inet6SvrFactoryImpl,
{$IFDEF UNIX}
UnixSvrFactoryImpl,
{$ENDIF}
BoundSvrFactoryImpl,

{$IFDEF LINUX}
EpollInetSvrFactoryImpl,
EpollInet6SvrFactoryImpl,
EpollUnixSvrFactoryImpl,
EpollBoundSvrFactoryImpl,
{$ENDIF}

{$IFDEF FREEBSD}
    {$IFDEF USE_KQUEUE}
    KqueueInetSvrFactoryImpl,
    KQueueInet6SvrFactoryImpl,
    KqueueUnixSvrFactoryImpl,
    KqueueBoundSvrFactoryImpl,
    {$ENDIF}
{$ENDIF}
