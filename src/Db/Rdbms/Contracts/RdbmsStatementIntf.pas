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
         * set parameter UTF8 string value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramUtf8(const strName : string; const strValue : utf8string) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter unicode string value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramUnicode(const strName : string; const strValue : unicodestring) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter integer value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramInt(const strName : string; const strValue : integer) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter small integer value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramSmallInt(const strName : string; const strValue : smallint) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter large integer (64-bit)value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramLargeInt(const strName : string; const strValue : largeint) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter word value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramWord(const strName : string; const strValue : word) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter boolean value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramBool(const strName : string; const strValue : boolean) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter float value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramFloat(const strName : string; const strValue : double) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter currency value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramCurrency(const strName : string; const strValue : currency) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter datetime value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramDateTime(const strName : string; const strValue : TDateTime) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter date value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramDate(const strName : string; const strValue : TDateTime) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter time value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramTime(const strName : string; const strValue : TDateTime) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter time value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramBytes(const strName : string; const strValue : TBytes) : IRdbmsStatement;
    end;

implementation

end.
