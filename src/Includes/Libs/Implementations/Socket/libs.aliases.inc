{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * redeclare all class types in unit inside Libs/Socket
 * directory
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

TInetSocketSvr = InetSocketSvrImpl.TInetSocketSvr;

{$IFDEF unix}
TUnixSocketSvr = UnixSocketSvrImpl.TUnixSocketSvr;
{$ENDIF}

TBoundSocketSvr = BoundSocketSvrImpl.TBoundSocketSvr;

{$IFDEF LINUX}
TEpollInetSocketSvr = EpollInetSocketSvrImpl.TEpollInetSocketSvr;
TEpollUnixSocketSvr = EpollUnixSocketSvrImpl.TEpollUnixSocketSvr;
TEpollBoundSocketSvr = EpollBoundSocketSvrImpl.TEpollBoundSocketSvr;
{$ENDIF}

TWithErrLogSvr = WithErrLogSvrImpl.TWithErrLogSvr;
