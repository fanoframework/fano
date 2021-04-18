{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RdbmsFieldsIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsFieldIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * handle fields of a result set
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRdbmsFields = interface
        ['{7D1D75DB-8F12-4FF8-9235-62E268172693}']

        (*!------------------------------------------------
         * number of fields
         *-------------------------------------------------
         * @return integer number of fields
         *-------------------------------------------------*)
        function fieldCount() : integer;

        (*!------------------------------------------------
         * get field by name
         *-------------------------------------------------
         * @return field
         *-------------------------------------------------*)
        function fieldByName(const name : shortstring) : IRdbmsField;

        (*!------------------------------------------------
         * get field by name
         *-------------------------------------------------
         * @return field
         *-------------------------------------------------*)
        function fieldByIndex(const indx : integer) : IRdbmsField;
    end;

implementation

end.
