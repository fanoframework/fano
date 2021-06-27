{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit OdbcDbFactoryImpl;

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
     * handle relational database operation via ODBC
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TOdbcDbFactory = class(TAbstractDbFactory)
    private
        fDriver : string;
        fDatabaseHostname : string;
        fDatabaseName : string;
        fDatabaseUsername : string;
        fDatabasePassword : string;
        fDatabasePort : word;
    public

        (*!------------------------------------------------
         * create connection to RDBMS server
         *-------------------------------------------------
         * @param driver ODBC driver
         * @param host hostname/ip where RDBMS server run
         * @param dbname database name to use
         * @param username user name credential to login
         * @param password password credential to login
         * @param port TCP port where RDBMS listen
         *-------------------------------------------------*)
        constructor create(const driver : string = '');

        function host(const aHost : string) : TOdbcDbFactory;
        function port(const aPort : word) : TOdbcDbFactory;
        function database(const aDbname : string) : TOdbcDbFactory;
        function username(const aUsrname : string) : TOdbcDbFactory;
        function password(const aPasw : string) : TOdbcDbFactory;

        (*!------------------------------------------------
         * create rdbms instance
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        function build() : IRdbms; override;
    end;

implementation

uses

    OdbcDbImpl;

    (*!------------------------------------------------
     * create connection to RDBMS server
     *-------------------------------------------------
     * @param driver ODBC driver
     * @param host hostname/ip where RDBMS server run
     * @param dbname database name to use
     * @param username user name credential to login
     * @param password password credential to login
     * @param port TCP port where RDBMS listen
     *-------------------------------------------------*)
    constructor TOdbcDbFactory.create(const driver : string = '');
    begin
        fDriver := driver;
        fDatabaseHostname := '';
        fDatabaseName := '';
        fDatabaseUsername := '';
        fDatabasePassword := '';
        fDatabasePort := 0;
    end;

    function TOdbcDbFactory.host(const aHost : string) : TOdbcDbFactory;
    begin
        fDatabaseHostname := aHost;
        result := self;
    end;

    function TOdbcDbFactory.port(const aPort : word) : TOdbcDbFactory;
    begin
        fDatabasePort := aPort;
        result := self;
    end;

    function TOdbcDbFactory.database(const aDbname : string) : TOdbcDbFactory;
    begin
        fDatabaseName := aDbName;
        result := self;
    end;

    function TOdbcDbFactory.username(const aUsrname : string) : TOdbcDbFactory;
    begin
        fDatabaseUserName := aUsrName;
        result := self;
    end;

    function TOdbcDbFactory.password(const aPasw : string) : TOdbcDbFactory;
    begin
        fDatabasePassword := aPasw;
        result := self;
    end;

    (*!------------------------------------------------
     * create rdbms instance
     *-------------------------------------------------
     * @return database connection instance
     *-------------------------------------------------*)
    function TOdbcDbFactory.build() : IRdbms;
    var db : TOdbcDb;
    begin
        db := TOdbcDb.create(fDriver);
        result := db;
        result.connect(
            fDatabaseHostname,
            fDatabaseName,
            fDatabaseUsername,
            fDatabasePassword,
            fDatabasePort
        );
    end;

end.
