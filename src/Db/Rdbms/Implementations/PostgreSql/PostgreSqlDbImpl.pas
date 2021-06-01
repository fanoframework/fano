{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit PostgreSqlDbImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * handle PostgreSql relational database operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TPostgreSqlDb = class(TRdbms)
    public
        constructor create();
    end;

implementation

uses

    PqConnection;

    constructor TPostgreSqlDb.create();
    begin
        inherited create('PostgreSQL');
    end;

end.
