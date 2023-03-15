{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RdbmsFactoryIntf;

interface

{$MODE OBJFPC}

uses

    RdbmsIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * create database connection
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRdbmsFactory = interface
        ['{26F2F597-6C87-46B6-9B51-1460C0E08970}']

        (*!------------------------------------------------
         * create rdbms instance
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        function build() : IRdbms;

    end;

implementation

end.
