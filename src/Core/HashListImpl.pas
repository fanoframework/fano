{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HashListImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    contnrs,
    ReadOnlyListIntf,
    ListIntf;

type

    (*!------------------------------------------------
     * basic class having capability to store hash list
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THashList = class(TInterfacedObject, IReadOnlyList, IList)
    private
        hashes : TFPHashList;
    public
        constructor create();
        destructor destroy(); override;

        function count() : integer;
        function get(const indx : integer) : pointer;
        procedure delete(const indx : integer);
        function add(const aKey : shortstring; const data : pointer) : integer;
        function find(const aKey : shortstring) : pointer;
        function keyOfIndex(const indx : integer) : shortstring;

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

        (*!------------------------------------------------
         * get index by key name
         *-----------------------------------------------
         * @param key name
         * @return index of key
         *-----------------------------------------------*)
        function indexOf(const aKey : shortstring) : integer;
    end;

implementation

    constructor THashList.create();
    begin
        hashes := TFPHashList.create();
    end;

    destructor THashList.destroy();
    begin
        hashes.free();
        inherited destroy();
    end;

    function THashList.count() : integer;
    begin
        result := hashes.count;
    end;

    function THashList.get(const indx : integer) : pointer;
    begin
        result := hashes.items[indx];
    end;

    procedure THashList.delete(const indx : integer);
    begin
        hashes.delete(indx);
    end;

    function THashList.add(const aKey : shortstring; const data : pointer) : integer;
    begin
        result := hashes.add(aKey, data);
    end;

    function THashList.find(const aKey : shortstring) : pointer;
    begin
        result := hashes.find(aKey);
    end;

    function THashList.remove(const aKey : shortstring) : pointer;
    begin
        result := find(aKey);
        if result <> nil then
        begin
            hashes.remove(result);
        end;
    end;

    function THashList.keyOfIndex(const indx : integer) : shortstring;
    begin
        result := hashes.nameOfIndex(indx);
    end;

    (*!------------------------------------------------
     * get index by key name
     *-----------------------------------------------
     * @param key name
     * @return index of key
     *-----------------------------------------------*)
    function THashList.indexOf(const aKey : shortstring) : integer;
    begin
        result := hashes.findIndexOf(aKey);
    end;
end.
