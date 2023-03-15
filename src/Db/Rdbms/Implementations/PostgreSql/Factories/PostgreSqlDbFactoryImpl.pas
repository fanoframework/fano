{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit PostgreSqlDbFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsIntf,
    RdbmsFactoryIntf,
    AbstractDbFactoryImpl;

const

    POSTGRESQL_DEFAULT_PORT = 5432;

type

    (*!------------------------------------------------
     * basic class having capability to
     * handle PostgreSQL relational database operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TPostgreSqlDbFactory = class(TAbstractDbFactory)
    private
        databaseHostname : string;
        databaseName : string;
        databaseUsername : string;
        databasePassword : string;
        databasePort : word;
    public

        (*!------------------------------------------------
         * create connection to RDBMS server
         *-------------------------------------------------
         * @param host hostname/ip where RDBMS server run
         * @param dbname database name to use
         * @param username user name credential to login
         * @param password password credential to login
         * @param port TCP port where RDBMS listen
         *-------------------------------------------------*)
        constructor create(
            const host : string;
            const dbname : string;
            const username : string;
            const password : string;
            const port : word = POSTGRESQL_DEFAULT_PORT
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

    PostgreSqlDbImpl;

    (*!------------------------------------------------
     * create connection to RDBMS server
     *-------------------------------------------------
     * @param host hostname/ip where RDBMS server run
     * @param dbname database name to use
     * @param username user name credential to login
     * @param password password credential to login
     * @param port TCP port where RDBMS listen
     *-------------------------------------------------*)
    constructor TPostgreSqlDbFactory.create(
        const host : string;
        const dbname : string;
        const username : string;
        const password : string;
        const port : word = POSTGRESQL_DEFAULT_PORT
    );
    begin
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
    function TPostgreSqlDbFactory.build() : IRdbms;
    begin
        result := TPostgreSqlDb.create();
        result.connect(
            databaseHostname,
            databaseName,
            databaseUsername,
            databasePassword,
            databasePort
        );
    end;

end.
