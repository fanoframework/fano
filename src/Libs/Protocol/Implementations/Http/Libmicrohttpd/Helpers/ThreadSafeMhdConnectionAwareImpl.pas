{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeMhdConnectionAwareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    libmicrohttpd,
    SyncObjs,
    StdOutIntf,
    MhdConnectionAwareIntf,
    ThreadSafeStdOutImpl,
    StreamAdapterIntf;

type

    (*!------------------------------------------------
     * IStdOut implmentation class having maintain libmicrohttpd
     * connection instance in thread-safe way
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeMhdConnectionAware = class(TThreadSafeStdOut, IMhdConnectionAware)
    private
        fActualConnectionAware : IMhdConnectionAware;
    public
        constructor create(
            const lock : TCriticalSection;
            const actualStdOut : IStdOut;
            const actualConnectionAware : IMhdConnectionAware
        );

        (*!------------------------------------------------
         * get libmicrohttpd connection
         *-----------------------------------------------
         * @return connection
         *-----------------------------------------------*)
        function getConnection() : PMHD_Connection;

        (*!------------------------------------------------
         * set libmicrohttpd connection
         *-----------------------------------------------*)
        procedure setConnection(aconnection : PMHD_Connection);

    end;

implementation

    constructor TThreadSafeMhdConnectionAware.create(
        const lock : TCriticalSection;
        const actualStdOut : IStdOut;
        const actualConnectionAware : IMhdConnectionAware
    );
    begin
        inherited create(lock, actualStdOut);
        fActualConnectionAware := actualConnectionAware;
    end;

    (*!------------------------------------------------
     * get libmicrohttpd connection
     *-----------------------------------------------
     * @return connection
     *-----------------------------------------------*)
    function TThreadSafeMhdConnectionAware.getConnection() : PMHD_Connection;
    begin
        fLock.acquire();
        try
            result := fActualConnectionAware.getConnection();
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * set libmicrohttpd connection
     *-----------------------------------------------*)
    procedure TThreadSafeMhdConnectionAware.setConnection(aconnection : PMHD_Connection);
    begin
        fLock.acquire();
        try
            fActualConnectionAware.setConnection(aconnection);
        finally
            fLock.release();
        end;
    end;

end.
