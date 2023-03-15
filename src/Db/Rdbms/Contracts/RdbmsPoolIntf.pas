{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RdbmsPoolIntf;

interface

{$MODE OBJFPC}

uses

    RdbmsIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * handle database connection pool
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRdbmsPool = interface
        ['{39D76D1E-0365-462D-81C0-FA43EF95F506}']

        (*!------------------------------------------------
         * get rdbms connection from pool
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        function acquire() : IRdbms;

        (*!------------------------------------------------
         * release rdbms connection back into pool
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        procedure release(const conn : IRdbms);

        (*!------------------------------------------------
         * get total rdbms connection in pool
         *-------------------------------------------------
         * @return number of connection in pool
         *-------------------------------------------------*)
        function count() : integer;

        (*!------------------------------------------------
         * get total available rdbms connection in pool
         *-------------------------------------------------
         * @return number of available connection in pool
         *-------------------------------------------------*)
        function availableCount() : integer;

        (*!------------------------------------------------
         * test if there is available connection in pool
         *-------------------------------------------------
         * @return true if one or more item available
         *-------------------------------------------------*)
        function isAvailable() : boolean;
        property available : boolean read isAvailable;

        (*!------------------------------------------------
         * get total used rdbms connection in pool
         *-------------------------------------------------
         * @return number of used connection in pool
         *-------------------------------------------------*)
        function usedCount() : integer;
    end;

implementation

end.
