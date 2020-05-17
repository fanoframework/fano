{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ListIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability store
     * list of item
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IList = interface(IReadOnlyList)
        ['{7EEE23CC-9713-49E2-BE92-CC63BDEA17F3}']

        (*!------------------------------------------------
         * delete item by index
         *-----------------------------------------------
         * @param indx index of item
         *-----------------------------------------------
         * implementor is free to decide whether delete
         * item in list only or also free item memory
         *-----------------------------------------------*)
        procedure delete(const indx : integer);

        (*!------------------------------------------------
         * add item and associate it with key name
         *-----------------------------------------------
         * @param aKey name to use to associate item
         * @param item item to be added
         * @return index of item
         *-----------------------------------------------*)
        function add(const aKey : shortstring; const item : pointer) : integer;

        (*!------------------------------------------------
         * delete item by key
         *-----------------------------------------------
         * @param aKey name to use to associate item
         * @return item being removed
         *-----------------------------------------------
         * implementor is free to decide whether delete
         * item in list only or also free item memory
         *-----------------------------------------------*)
        function remove(const aKey : shortstring) : pointer;
    end;

implementation
end.
