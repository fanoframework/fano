{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FirebirdDbImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * handle Firebird relational database operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TFirebirdDb = class(TRdbms)
    public
        constructor create();
    end;

implementation

uses

    IBConnection;

    constructor TFirebirdDb.create();
    begin
        inherited create('Firebird');
    end;
end.
