{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
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
BoundSocketImpl,

AbstractIoHandlerImpl,

{$IFDEF LINUX}
EpollIoHandlerImpl,
{$ENDIF}

SelectIoHandlerImpl,

SocketOptsImpl,

InetSvrFactoryImpl,
UnixSvrFactoryImpl,
BoundSvrFactoryImpl,
EpollInetSvrFactoryImpl,
EpollUnixSvrFactoryImpl,
EpollBoundSvrFactoryImpl,
