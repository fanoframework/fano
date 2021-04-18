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

TSocket2Svr = Socket2SvrImpl.TSocket2Svr;

{$IFDEF unix}
TUnixSocket = UnixSocketImpl.TUnixSocket;
{$ENDIF}
TInetSocket = InetSocketImpl.TInetSocket;
TInet6Socket = Inet6SocketImpl.TInet6Socket;
TBoundSocket = BoundSocketImpl.TBoundSocket;

TAbstractIoHandler = AbstractIoHandlerImpl.TAbstractIoHandler;
{$IFDEF LINUX}
TEpollIoHandler = EpollIoHandlerImpl.TEpollIoHandler;
{$ENDIF}
TSelectIoHandler = SelectIoHandlerImpl.TSelectIoHandler;

{$IFDEF FREEBSD}
    {$IFDEF USE_KQUEUE}
    TKqueueIoHandler = KqueueIoHandlerImpl.TKqueueIoHandler;
    {$ENDIF}
{$ENDIF}

TSocketOpts = SocketOptsImpl.TSocketOpts;

TInetSvrFactory = InetSvrFactoryImpl.TInetSvrFactory;
TInet6SvrFactory = Inet6SvrFactoryImpl.TInet6SvrFactory;
{$IFDEF unix}
TUnixSvrFactory = UnixSvrFactoryImpl.TUnixSvrFactory;
{$ENDIF}
TBoundSvrFactory = BoundSvrFactoryImpl.TBoundSvrFactory;

{$IFDEF LINUX}
TEpollInetSvrFactory = EpollInetSvrFactoryImpl.TEpollInetSvrFactory;
TEpollInet6SvrFactory = EpollInet6SvrFactoryImpl.TEpollInet6SvrFactory;
TEpollUnixSvrFactory = EpollUnixSvrFactoryImpl.TEpollUnixSvrFactory;
TEpollBoundSvrFactory = EpollBoundSvrFactoryImpl.TEpollBoundSvrFactory;
{$ENDIF}

{$IFDEF FREEBSD}
    {$IFDEF USE_KQUEUE}
    TKQueueInetSvrFactory = KQueueInetSvrFactoryImpl.TKQueueInetSvrFactory;
    TKQueueInet6SvrFactory = KQueueInet6SvrFactoryImpl.TKQueueInet6SvrFactory;
    TKQueueUnixSvrFactory = KQueueUnixSvrFactoryImpl.TKQueueUnixSvrFactory;
    TKQueueBoundSvrFactory = KQueueBoundSvrFactoryImpl.TKQueueBoundSvrFactory;
    {$ENDIF}
{$ENDIF}
