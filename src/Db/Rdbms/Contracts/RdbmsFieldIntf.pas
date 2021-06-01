{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RdbmsFieldIntf;

interface

{$MODE OBJFPC}
{$H+}


type

    (*!------------------------------------------------
     * interface for any class having capability
     * as a field of database result set
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRdbmsField = interface
        ['{D10D284B-4900-4A86-A9D2-BFF13D0C1C5C}']

        (*!------------------------------------------------
         * return field data as boolean
         *-------------------------------------------------
         * @return boolean value of field
         *-------------------------------------------------*)
        function asBoolean() : boolean;

        (*!------------------------------------------------
         * return field data as integer value
         *-------------------------------------------------
         * @return value of field
         *-------------------------------------------------*)
        function asInteger() : integer;

        (*!------------------------------------------------
         * return field data as string value
         *-------------------------------------------------
         * @return value of field
         *-------------------------------------------------*)
        function asString() : string;

        (*!------------------------------------------------
         * return field data as double value
         *-------------------------------------------------
         * @return value of field
         *-------------------------------------------------*)
        function asFloat() : double;

        (*!------------------------------------------------
         * return field data as datetime value
         *-------------------------------------------------
         * @return value of field
         *-------------------------------------------------*)
        function asDateTime() : TDateTime;
    end;

implementation

end.
