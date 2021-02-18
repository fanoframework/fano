{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SQLiteDbFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsIntf,
    RdbmsFactoryIntf,
    AbstractDbFactoryImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * handle SQLite relational database operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TSQLiteDbFactory = class(TAbstractDbFactory)
    private
        databaseName : string;
    public

        (*!------------------------------------------------
         * create connection to RDBMS server
         *-------------------------------------------------
         * @param dbname database name to use
         *-------------------------------------------------*)
        constructor create(const dbname : string);

        (*!------------------------------------------------
         * create rdbms instance
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        function build() : IRdbms; override;
    end;

implementation

uses

    SQLiteDbImpl;

    (*!------------------------------------------------
     * create connection to RDBMS server
     *-------------------------------------------------
     * @param dbname database name to use
     *-------------------------------------------------*)
    constructor TSQLiteDbFactory.create(const dbname : string);
    begin
        databaseName := dbname;
    end;

    (*!------------------------------------------------
     * create rdbms instance
     *-------------------------------------------------
     * @return database connection instance
     *-------------------------------------------------*)
    function TSQLiteDbFactory.build() : IRdbms;
    begin
        result := TSQLiteDb.create();
        result.connect('', databaseName, '', '', 0);
    end;

end.
