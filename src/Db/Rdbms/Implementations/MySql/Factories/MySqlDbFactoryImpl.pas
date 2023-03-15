{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MySqlDbFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsIntf,
    RdbmsFactoryIntf,
    AbstractDbFactoryImpl;

const

    MYSQL_DEFAULT_PORT = 3306;

type

    (*!------------------------------------------------
     * basic class having capability to
     * handle mysql relational database operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMySqlDbFactory = class(TAbstractDbFactory)
    private
        mysqlVersion : string;
        databaseHostname : string;
        databaseName : string;
        databaseUsername : string;
        databasePassword : string;
        databasePort : word;
    public

        (*!------------------------------------------------
         * create connection to RDBMS server
         *-------------------------------------------------
         * @param version MySQL version
         * @param host hostname/ip where RDBMS server run
         * @param dbname database name to use
         * @param username user name credential to login
         * @param password password credential to login
         * @param port TCP port where RDBMS listen
         *-------------------------------------------------*)
        constructor create(
            const version : string;
            const host : string;
            const dbname : string;
            const username : string;
            const password : string;
            const port : word = MYSQL_DEFAULT_PORT
        );

        (*!------------------------------------------------
         * create rdbms instance
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        function build() : IRdbms; override;
    end;

implementation

uses

    MySqlDbImpl;

    (*!------------------------------------------------
     * create connection to RDBMS server
     *-------------------------------------------------
     * @param version MySQL version
     * @param host hostname/ip where RDBMS server run
     * @param dbname database name to use
     * @param username user name credential to login
     * @param password password credential to login
     * @param port TCP port where RDBMS listen
     *-------------------------------------------------*)
    constructor TMySqlDbFactory.create(
        const version : string;
        const host : string;
        const dbname : string;
        const username : string;
        const password : string;
        const port : word = MYSQL_DEFAULT_PORT
    );
    begin
        mysqlVersion := version;
        databaseHostname := host;
        databaseName := dbname;
        databaseUsername := username;
        databasePassword := password;
        databasePort := port;
    end;

    (*!------------------------------------------------
     * create rdbms instance
     *-------------------------------------------------
     * @return database connection instance
     *-------------------------------------------------*)
    function TMySqlDbFactory.build() : IRdbms;
    begin
        result := TMySqlDb.create(mysqlVersion);
        result.connect(
            databaseHostname,
            databaseName,
            databaseUsername,
            databasePassword,
            databasePort
        );
    end;

end.
