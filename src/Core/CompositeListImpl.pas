{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompositeListImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    contnrs,
    ReadOnlyListIntf,
    ListIntf;

type

    (*!------------------------------------------------
     * basic class having capability to combine two IList
     * instance as one
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCompositeList = class(TInterfacedObject, IReadonlyList, IList)
    private
        fFirstList : IList;
        fSecondList : IList;
    public
        constructor create(const firstList : IList; const secondList : IList);
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

uses

    EIndexOutOfBoundImpl;

resourcestring

    sErrIndexOutOfBound = 'Index is out of bound';

    constructor TCompositeList.create(const firstList : IList; const secondList : IList);
    begin
        fFirstList := firstList;
        fSecondList := secondList;
    end;

    destructor TCompositeList.destroy();
    begin
        fFirstList := nil;
        fSecondList := nil;
        inherited destroy();
    end;

    function TCompositeList.count() : integer;
    begin
        result := fFirstList.count() + fSecondList.count();
    end;

    function TCompositeList.get(const indx : integer) : pointer;
    var tot1st : integer;
    begin
        if not ((indx >= 0) and (indx < count())) then
        begin
            raise EIndexOutOfBound.create(sErrIndexOutOfBound);
        end;

        tot1st := fFirstList.count();
        if (indx >= 0) and (indx < tot1st) then
        begin
            result := fFirstList.get(indx);
        end else
        if (indx >= tot1st) and (indx < tot1st + fSecondList.count()) then
        begin
            result := fSecondList.get(indx - tot1st);
        end else
        begin
            //this should not happen
            result := nil;
        end;
    end;

    procedure TCompositeList.delete(const indx : integer);
    var tot1st : integer;
    begin
        if not ((indx >= 0) and (indx < count())) then
        begin
            raise EIndexOutOfBound.create(sErrIndexOutOfBound);
        end;

        tot1st := fFirstList.count();
        if (indx >= 0) and (indx < tot1st) then
        begin
            fFirstList.delete(indx);
        end else
        if (indx >= tot1st) and (indx < tot1st + fSecondList.count()) then
        begin
            fSecondList.delete(indx - tot1st);
        end;
    end;

    function TCompositeList.add(const aKey : shortstring; const data : pointer) : integer;
    begin
        //just add to the end of list
        result := fSecondList.add(aKey, data);
    end;

    function TCompositeList.find(const aKey : shortstring) : pointer;
    begin
        result := fFirstList.find(aKey);
        if (result = nil) then
        begin
            //not found in first list, try second one
            result := fSecondList.find(aKey);
        end;
    end;

    function TCompositeList.remove(const aKey : shortstring) : pointer;
    begin
        result := fFirstList.remove(aKey);
        if result = nil then
        begin
            //not found in first list, try second one
            result := fSecondList.remove(aKey);
        end;
    end;

    function TCompositeList.keyOfIndex(const indx : integer) : shortstring;
    var tot1st : integer;
    begin
        if not ((indx >= 0) and (indx < count())) then
        begin
            raise EIndexOutOfBound.create(sErrIndexOutOfBound);
        end;

        tot1st := fFirstList.count();
        if (indx >= 0) and (indx < tot1st) then
        begin
            result := fFirstList.keyOfIndex(indx);
        end else
        if (indx >= tot1st) and (indx < tot1st + fSecondList.count()) then
        begin
            result := fSecondList.keyOfIndex(indx - tot1st);
        end else
        begin
            //this should not happen
            result := '';
        end;
    end;

    (*!------------------------------------------------
     * get index by key name
     *-----------------------------------------------
     * @param key name
     * @return index of key
     *-----------------------------------------------*)
    function TCompositeList.indexOf(const aKey : shortstring) : integer;
    begin
        result := fFirstList.indexOf(aKey);
        if (result = -1) then
        begin
            //not found in first list, try second one
            result := fSecondList.indexOf(aKey);
            if (result <> -1) then
            begin
                //if we get here then it is found, add offset to make it
                //point to correct index
                result := result + fFirstList.count();
            end;
        end;
    end;
end.
