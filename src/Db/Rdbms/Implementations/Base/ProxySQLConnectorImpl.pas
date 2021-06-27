{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ProxySQLConnectorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    sqldb;

type

    (*!------------------------------------------------
     * internal class which expose proxy TSqlconnection
     * as public
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TProxySQLConnector = class(TSQLConnector)
    public
        property proxy;
    end;

implementation

end.
