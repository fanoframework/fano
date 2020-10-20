{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompositeReadOnlyListImpl;

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
    TCompositeReadOnlyList = class(TInterfacedObject, IReadonlyList)
    private
        fFirstList : IReadOnlyList;
        fSecondList : IReadOnlyList;
    public
        constructor create(const firstList : IReadOnlyList; const secondList : IReadOnlyList);
        destructor destroy(); override;

        function count() : integer;
        function get(const indx : integer) : pointer;
        function find(const aKey : shortstring) : pointer;
        function keyOfIndex(const indx : integer) : shortstring;

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

    constructor TCompositeReadOnlyList.create(
        const firstList : IReadOnlyList;
        const secondList : IReadOnlyList
    );
    begin
        fFirstList := firstList;
        fSecondList := secondList;
    end;

    destructor TCompositeReadOnlyList.destroy();
    begin
        fFirstList := nil;
        fSecondList := nil;
        inherited destroy();
    end;

    function TCompositeReadOnlyList.count() : integer;
    begin
        result := fFirstList.count() + fSecondList.count();
    end;

    function TCompositeReadOnlyList.get(const indx : integer) : pointer;
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

    function TCompositeReadOnlyList.find(const aKey : shortstring) : pointer;
    begin
        result := fFirstList.find(aKey);
        if (result = nil) then
        begin
            //not found in first list, try second one
            result := fSecondList.find(aKey);
        end;
    end;

    function TCompositeReadOnlyList.keyOfIndex(const indx : integer) : shortstring;
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
    function TCompositeReadOnlyList.indexOf(const aKey : shortstring) : integer;
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
