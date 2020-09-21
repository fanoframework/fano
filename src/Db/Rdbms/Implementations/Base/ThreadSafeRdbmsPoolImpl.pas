{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeRdbmsPoolImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    syncobjs,
    RdbmsIntf,
    RdbmsPoolIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * handle database connection pool
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TThreadSafeRdbmsPool = class(TInjectableObject, IRdbmsPool)
    private
        fActualPool : IRdbmsPool;
        fPoolEvent : TEventObject;
        fLock : TCriticalSection;
        function tryAcquire() : IRdbms;
    public
        constructor create(const pool : IRdbmsPool);
        destructor destroy(); override;

        (*!------------------------------------------------
         * get rdbms connection from pool
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        function acquire() : IRdbms;

        (*!------------------------------------------------
         * release rdbms connection back into pool
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        procedure release(const conn : IRdbms);

        (*!------------------------------------------------
         * get total rdbms connection in pool
         *-------------------------------------------------
         * @return number of connection in pool
         *-------------------------------------------------*)
        function count() : integer;

        (*!------------------------------------------------
         * get total available rdbms connection in pool
         *-------------------------------------------------
         * @return number of available connection in pool
         *-------------------------------------------------*)
        function availableCount() : integer;

        (*!------------------------------------------------
         * get total used rdbms connection in pool
         *-------------------------------------------------
         * @return number of used connection in pool
         *-------------------------------------------------*)
        function usedCount() : integer;

        (*!------------------------------------------------
         * test if there is available connection in pool
         *-------------------------------------------------
         * @return true if one or more item available
         *-------------------------------------------------*)
        function isAvailable() : boolean;
    end;

implementation

uses

    SysUtils,
    fgl,
    EPoolConnectionImpl;

resourcestring

    sErrPoolConnNotAvail = 'No available connections to acquire';
    sErrPoolConnNotUsed = 'No used connections to release';

    constructor TThreadSafeRdbmsPool.create(const pool : IRdbmsPool);
    begin
        fActualPool := pool;

        //create event object that is initially set if actual pool
        //contains available item
        fPoolEvent := TEventObject.create(
            nil,
            true,
            fActualPool.available,
            'TThreadSafeRdbmsPool'
        );

        fLock := TCriticalSection.create();
    end;

    destructor TThreadSafeRdbmsPool.destroy();
    begin
        fLock.free();
        fPoolEvent.free();
        fActualPool := nil;
        inherited destroy();
    end;

    function TThreadSafeRdbmsPool.tryAcquire() : IRdbms;
    begin
        fLock.acquire();
        try
            result := fActualPool.acquire();

            if not fActualPool.available then
            begin
                //reset event so when other thread tries to acquire, it blocks.
                fPoolEvent.resetEvent();
            end;
        finally
            fLock.release();
        end;

    end;

    (*!------------------------------------------------
     * get rdbms connection from pool
     *-------------------------------------------------
     * @return database connection instance
     *-------------------------------------------------*)
    function TThreadSafeRdbmsPool.acquire() : IRdbms;
    begin
        //block thread until pool is available
        fPoolEvent.waitFor(INFINITE);
        result := tryAcquire();
    end;

    (*!------------------------------------------------
     * release rdbms connection back into pool
     *-------------------------------------------------
     * @return database connection instance
     *-------------------------------------------------*)
    procedure TThreadSafeRdbmsPool.release(const conn : IRdbms);
    begin
        fLock.acquire();
        try
            fActualPool.release(conn);
            if fActualPool.available then
            begin
                fPoolEvent.setEvent();
            end;
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * get total rdbms connection in pool
     *-------------------------------------------------
     * @return number of connection in pool
     *-------------------------------------------------*)
    function TThreadSafeRdbmsPool.count() : integer;
    begin
        fLock.acquire();
        try
            result := fActualPool.count();
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * get total available rdbms connection in pool
     *-------------------------------------------------
     * @return number of available connection in pool
     *-------------------------------------------------*)
    function TThreadSafeRdbmsPool.availableCount() : integer;
    begin
        fLock.acquire();
        try
            result := fActualPool.availableCount();
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * get total used rdbms connection in pool
     *-------------------------------------------------
     * @return number of used connection in pool
     *-------------------------------------------------*)
    function TThreadSafeRdbmsPool.usedCount() : integer;
    begin
        fLock.acquire();
        try
            result := fActualPool.usedCount();
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * test if there is available connection in pool
     *-------------------------------------------------
     * @return true if one or more item available
     *-------------------------------------------------*)
    function TThreadSafeRdbmsPool.isAvailable() : boolean;
    begin
        fLock.acquire();
        try
            result := fActualPool.isAvailable();
        finally
            fLock.release();
        end;
    end;
end.
