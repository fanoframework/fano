{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit OdbcDbImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsIntf,
    RdbmsImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * handle relational database operation via ODBC
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TOdbcDb = class(TRdbms)
    private
        fDriver : string;
    public
        constructor create(const aDriver : string);

        (*!------------------------------------------------
         * create connection to database server
         *-------------------------------------------------
         * @param host hostname/ip where MySQl server run
         * @param dbname database name to use
         * @param username user name credential to login
         * @param password password credential to login
         * @param port TCP port where MySQL listen
         * @return current instance
         *-------------------------------------------------*)
        function connect(
            const host : string;
            const dbname : string;
            const username : string;
            const password : string;
            const port : word
        ) : IRdbms; override;
    end;

implementation

uses

    OdbcConn;

    constructor TOdbcDb.create(const aDriver : string);
    begin
        inherited create('ODBC');
        fDriver := aDriver;
    end;

    (*!------------------------------------------------
     * create connection to database server
     *-------------------------------------------------
     * @param host hostname/ip where MySQl server run
     * @param dbname database name to use
     * @param username user name credential to login
     * @param password password credential to login
     * @param port TCP port where MySQL listen
     * @return current instance
     *-------------------------------------------------*)
    function TOdbcDb.connect(
        const host : string;
        const dbname : string;
        const username : string;
        const password : string;
        const port : word
    ) : IRdbms;
    begin
        inherited connect(host, dbname, username, password, port);
        //we can assume safely proxy object will be TODBCConnection
        TODBCConnection(fDbInstance.Proxy).Driver := fDriver;
        result := self;
    end;


end.
