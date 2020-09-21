{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadPoolIntf;

interface

{$MODE OBJFPC}

type

    (*!------------------------------------------------
     * interface for any class having capability as worker threads
     * in pool
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IThread = interface
        ['{61DDDA7F-E857-4BE2-A14F-C1F3D9BBCF2C}']

        (*!------------------------------------------------
         * get current thread status
         *-------------------------------------------------
         * @return true is thread is idle, false if thread is
         * busy working
         *-------------------------------------------------*)
        function idle() : boolean;

        (*!------------------------------------------------
         * tell thread to start running
         *------------------------------------------------
         * If thread already running, multiple call does nothing
         *-------------------------------------------------*)
        procedure start();
    end;

implementation

end.
