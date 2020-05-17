{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RdbmsIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsResultSetIntf,
    RdbmsStatementIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * handle relational database operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRdbms = interface
        ['{996106E4-C199-4605-A372-12B721D44E27}']

        (*!------------------------------------------------
         * create connection to RDBMS server
         *-------------------------------------------------
         * @param host hostname/ip where RDBMS server run
         * @param dbname database name to use
         * @param username user name credential to login
         * @param password password credential to login
         * @param port TCP port where RDBMS listen
         * @return current instance
         *-------------------------------------------------*)
        function connect(
            const host : string;
            const dbname : string;
            const username : string;
            const password : string;
            const port : word
        ) : IRdbms;

        (*!------------------------------------------------
         * initiate a transaction
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        function beginTransaction() : IRdbms;

        (*!------------------------------------------------
         * rollback a transaction
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        function rollback() : IRdbms;

        (*!------------------------------------------------
         * commit a transaction
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        function commit() : IRdbms;

        (*!------------------------------------------------
         * created prepared sql statement
         *-------------------------------------------------
         * @return result set
         *-------------------------------------------------*)
        function prepare(const sql : string) : IRdbmsStatement;

        (*!------------------------------------------------
         * get current database name
         *-------------------------------------------------
         * @return database name
         *-------------------------------------------------*)
        function getDbName() : string;
    end;

implementation

end.
