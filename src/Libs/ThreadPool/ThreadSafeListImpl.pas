{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeListImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    ReadOnlyListIntf,
    ListIntf;

type

    (*!------------------------------------------------
     * class that wraps other IList and make it thread-safe
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeList = class(TInterfacedObject, IReadOnlyList, IList)
    private
        fLock : TCriticalSection;
        fList : IList;
    public
        constructor create(const alist : IList);
        destructor destroy(); override;

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
    end;

implementation

    constructor TThreadSafeList.create(const alist : IList);
    begin
        fLock := TCriticalSection.create();
        fList := alist;
    end;

    destructor TThreadSafeList.destroy();
    begin
        fList := nil;
        fLock.free();
        inherited destroy();
    end;

    (*!------------------------------------------------
     * get number of item in list
     *-----------------------------------------------
     * @return number of item in list
     *-----------------------------------------------*)
    function TThreadSafeList.count() : integer;
    begin
        fLock.acquire();
        try
            result := fList.count();
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * get item by index
     *-----------------------------------------------
     * @param indx index of item
     * @return item instance
     *-----------------------------------------------*)
    function TThreadSafeList.get(const indx : integer) : pointer;
    begin
        fLock.acquire();
        try
            result := fList.get(indx);
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * find by its key name
     *-----------------------------------------------
     * @param aKey name to use to find item
     * @return item instance
     *-----------------------------------------------*)
    function TThreadSafeList.find(const aKey : shortstring) : pointer;
    begin
        fLock.acquire();
        try
            result := fList.find(aKey);
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * get key name by using its index
     *-----------------------------------------------
     * @param indx index to find
     * @return key name
     *-----------------------------------------------*)
    function TThreadSafeList.keyOfIndex(const indx : integer) : shortstring;
    begin
        fLock.acquire();
        try
            result := fList.keyOfIndex(indx);
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * get index by key name
     *-----------------------------------------------
     * @param aKey name
     * @return index of key
     *-----------------------------------------------*)
    function TThreadSafeList.indexOf(const aKey : shortstring) : integer;
    begin
        fLock.acquire();
        try
            result := fList.indexOf(aKey);
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * delete item by index
     *-----------------------------------------------
     * @param indx index of item
     *-----------------------------------------------
     * implementor is free to decide whether delete
     * item in list only or also free item memory
     *-----------------------------------------------*)
    procedure TThreadSafeList.delete(const indx : integer);
    begin
        fLock.acquire();
        try
            result := fList.delete(indx);
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * add item and associate it with key name
     *-----------------------------------------------
     * @param aKey name to use to associate item
     * @param item item to be added
     * @return index of item
     *-----------------------------------------------*)
    function TThreadSafeList.add(const aKey : shortstring; const item : pointer) : integer;
    begin
        fLock.acquire();
        try
            result := fList.add(aKey, item);
        finally
            fLock.release();
        end;
    end;
end.
