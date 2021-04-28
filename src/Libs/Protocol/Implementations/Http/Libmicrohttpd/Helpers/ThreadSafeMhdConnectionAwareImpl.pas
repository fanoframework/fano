{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
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
    StreamAdapterIntf;

type

    (*!------------------------------------------------
     * IStdOut implmentation class having maintain libmicrohttpd
     * connection instance in thread-safe way
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeMhdConnectionAware = class(TInterfacedObject, IStdOut, IMhdConnectionAware)
    private
        fLock : TCriticalSection;
        fActualStdOut : IStdOut;
        fActualConnectionAware : IMhdConnectionAware;
    public
        constructor create(
            const lock : TCriticalSection;
            const actualStdOut : IStdOut;
            const actualConnectionAware : IMhdConnectionAware
        );

        (*!------------------------------------------------
         * set stream to write to if any
         *-----------------------------------------------
         * @param stream, stream to write to
         * @return current instance
         *-----------------------------------------------*)
        function setStream(const astream : IStreamAdapter) : IStdOut;

        (*!------------------------------------------------
         * write string to stdout
         *-----------------------------------------------
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function write(const str : string) : IStdOut;

        (*!------------------------------------------------
         * write string with newline to stdout
         *-----------------------------------------------
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function writeln(const str : string) : IStdOut;

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
        fLock := lock;
        fActualStdOut := actualStdOut;
        fActualConnectionAware := actualConnectionAware;
    end;

    (*!------------------------------------------------
     * set stream to write to if any
     *-----------------------------------------------
     * @param stream, stream to write to
     * @return current instance
     *-----------------------------------------------*)
    function TThreadSafeMhdConnectionAware.setStream(const astream : IStreamAdapter) : IStdOut;
    begin
        fLock.acquire();
        try
            fActualStdOut.setStream(astream);
            result := self;
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * write string to stdout
     *-----------------------------------------------
     * @param str, string to write
     * @return current instance
     *-----------------------------------------------*)
    function TThreadSafeMhdConnectionAware.write(const str : string) : IStdOut;
    begin
        fLock.acquire();
        try
            fActualStdOut.write(str);
            result := self;
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * write string with newline to stdout
     *-----------------------------------------------
     * @param str, string to write
     * @return current instance
     *-----------------------------------------------*)
    function TThreadSafeMhdConnectionAware.writeln(const str : string) : IStdOut;
    begin
        fLock.acquire();
        try
            fActualStdOut.writeln(str);
            result := self;
        finally
            fLock.release();
        end;
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
