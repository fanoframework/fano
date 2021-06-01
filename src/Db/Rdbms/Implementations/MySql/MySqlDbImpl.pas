{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MySqlDbImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * handle mysql relational database operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMySqlDb = class(TRdbms);

implementation

uses

    Mysql55Conn,
    Mysql56Conn,
    Mysql57Conn;

end.
