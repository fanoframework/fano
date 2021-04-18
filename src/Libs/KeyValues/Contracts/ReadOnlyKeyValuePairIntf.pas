{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ReadOnlyKeyValuePairIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability key value
     * pair for read only access
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IReadOnlyKeyValuePair = interface
        ['{1A8D8D5F-A1FB-41BC-8D25-3BC4141E994F}']

        (*!------------------------------------------------
         * get value by key
         *-----------------------------------------------
         * @param key name to use
         * @return value
         * @throws EKeyNotFound exception if not set
         *-----------------------------------------------*)
        function getValue(const keyName : shortstring) : string;

        (*!------------------------------------------------
         * test if key is set
         *-----------------------------------------------
         * @param key name to use
         * @return boolean true if key is set otherwise false
         *-----------------------------------------------*)
        function has(const keyName : shortstring) : boolean;

        (*!------------------------------------------------
         * get number of keys
         *-----------------------------------------------
         * @return number of keys
         *-----------------------------------------------*)
        function count() : integer;

        (*!------------------------------------------------
         * get key by index
         *-----------------------------------------------
         * @param index index to use
         * @return key name
         * @throws EKeyNotFound exception if not set
         *-----------------------------------------------*)
        function getKey(const indx : integer) : shortstring;
    end;

implementation
end.
