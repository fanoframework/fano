{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ReadOnlyListIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability read
     * list of item
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IReadOnlyList = interface
        ['{E0C2048D-A5EC-4AF6-8F2B-BECBB52C0960}']

        (*!------------------------------------------------
         * get number of item in list
         *-----------------------------------------------
         * @return number of item in list
         *-----------------------------------------------*)
        function count() : integer;

        (*!------------------------------------------------
         * get item by index
         *-----------------------------------------------
         * @param indx index of item
         * @return item instance
         *-----------------------------------------------*)
        function get(const indx : integer) : pointer;

        (*!------------------------------------------------
         * find by its key name
         *-----------------------------------------------
         * @param aKey name to use to find item
         * @return item instance
         *-----------------------------------------------*)
        function find(const aKey : shortstring) : pointer;

        (*!------------------------------------------------
         * get key name by using its index
         *-----------------------------------------------
         * @param indx index to find
         * @return key name
         *-----------------------------------------------*)
        function keyOfIndex(const indx : integer) : shortstring;

        (*!------------------------------------------------
         * get index by key name
         *-----------------------------------------------
         * @param aKey name
         * @return index of key
         *-----------------------------------------------*)
        function indexOf(const aKey : shortstring) : integer;
    end;

implementation
end.
