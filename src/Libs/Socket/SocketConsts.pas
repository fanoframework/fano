{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SocketConsts;

interface

{$MODE OBJFPC}
{$H+}

uses

    sockets;

//Set equal to SOMAXCONN
const DEFAULT_LISTEN_BACKLOG = SOMAXCONN;

resourcestring

    rsSocketListenFailed = 'Listening failed, error: %s (%d)';
    rsAcceptWouldBlock = 'Accept socket would block on socket, error: %s (%d)';
    rsBindFailed = 'Bind failed on %s, error: %s (%d)';
    rsCreateFailed = 'Create socket on %s failed, error: %s (%d)';

    rsEpollInitFailed = 'Fail to initialize epoll';
    rsEpollAddFileDescriptorFailed = 'Fail to add file descriptor';

    rsKqueueInitFailed = 'Fail to initialize kqueue';
    rsKqueueAddFileDescriptorFailed = 'Fail to add file descriptor';
    rsKqueueDeleteFileDescriptorFailed = 'Fail to add file descriptor';

    rsSocketError = 'Socket error: %s (%d)';
    rsSocketReadFailed = 'Read socket failed, error: %s (%d)';
    rsSocketWriteFailed = 'Write socket failed, error: %s (%d)';

implementation

end.
