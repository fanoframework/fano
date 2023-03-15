{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SocketIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability setup
     * socket
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ISocket = interface
        ['{C5F5A3EF-820D-4D73-B49B-72E24F0929D2}']

        (*!-----------------------------------------------
         * return listen socket
         *-----------------------------------------------*)
        function getSocket() : longint;

        property fd : longint read getSocket;

    end;

implementation

end.
