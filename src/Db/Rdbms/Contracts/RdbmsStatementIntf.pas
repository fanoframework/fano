{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RdbmsStatementIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsResultSetIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * handle relational database prepared statement operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRdbmsStatement = interface
        ['{6CCC4179-DFB7-4DBD-A524-FFD36FBDE9FA}']

        (*!------------------------------------------------
         * execute statement
         *-------------------------------------------------
         * @return result set
         *-------------------------------------------------*)
        function execute() : IRdbmsResultSet;

        (*!------------------------------------------------
         * set parameter string value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramStr(const strName : string; const strValue : string) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter integer value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramInt(const strName : string; const strValue : integer) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter float value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramFloat(const strName : string; const strValue : double) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter datetime value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramDateTime(const strName : string; const strValue : TDateTime) : IRdbmsStatement;
    end;

implementation

end.
