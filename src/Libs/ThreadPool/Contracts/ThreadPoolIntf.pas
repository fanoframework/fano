{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadPoolIntf;

interface

{$MODE OBJFPC}

uses

    ThreadIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to manage
     * one or more worker threads and distribute the work
     * between worker threads
     *
     * The main goal of this interface is to allow several
     * threads to be managed by thread pool.
     *
     * When application needs a thread instance to handle a work,
     * instead of creating a thread on their own, application
     * asks from the thread pool.
     * The thread pool returns worker thread that is idle
     * from its pool of thread. If it can't find idle worker
     * thread, it tries to spawn new thread and add it to its pool
     * and hands it to application.
     * If somehow thread pool is not allowed to spawn new thread
     * (for example number of max thread has been reach), thread pool
     * waits until an idle thread is available. If waiting time
     * exceeds timeout value then thread pool raise exception
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IThreadPool = interface
        ['{CF3FCA8D-46B2-4292-AF57-253EB6EBAA93}']

        (*!------------------------------------------------
         * get idle thread from pool
         *-----------------------------------------------
         * @return idle thread
         * @throws EThreadPoolTimeout if thread pool cannot spawn
         * idle thread in given time interval
         *-----------------------------------------------*)
        function requestIdleThread() : IThread;
    end;

implementation

end.
