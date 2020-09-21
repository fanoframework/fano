{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RdbmsResultSetIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsFieldsIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * handle relational database operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRdbmsResultSet = interface
        ['{25A61EEB-5DC8-4D81-AB88-1EF5F549EC85}']

        (*!------------------------------------------------
         * total data in result set
         *-------------------------------------------------
         * @return total data in current result set
         *-------------------------------------------------*)
        function resultCount() : int64;

        (*!------------------------------------------------
         * test if we in end of result set
         *-------------------------------------------------
         * @return true if at end of file and no more record
         *-------------------------------------------------*)
        function eof() : boolean;

        (*!------------------------------------------------
         * advanced cursor position to next record
         *-------------------------------------------------
         * @return true if at end of file and no more record
         *-------------------------------------------------*)
        function next() : IRdbmsResultSet;

        (*!------------------------------------------------
         * get list of fields
         *-------------------------------------------------
         * @return current fields
         *-------------------------------------------------*)
        function fields() : IRdbmsFields;
    end;

implementation

end.
