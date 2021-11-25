{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeStdOutImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    StdOutIntf,
    StreamAdapterIntf,
    DecoratorStdOutImpl;

type

    (*!------------------------------------------------
     * IStdOut thread-safe implmentation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeStdOut = class(TDecoratorStdOut)
    protected
        fLock : TCriticalSection;
    public
        constructor create(
            const lock : TCriticalSection;
            const actualStdOut : IStdOut
        );

        (*!------------------------------------------------
         * set stream to write to if any
         *-----------------------------------------------
         * @param stream, stream to write to
         * @return current instance
         *-----------------------------------------------*)
        function setStream(const astream : IStreamAdapter) : IStdOut; override;

        (*!------------------------------------------------
         * write string to stdout
         *-----------------------------------------------
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function write(const str : string) : IStdOut; override;

        (*!------------------------------------------------
         * write string with newline to stdout
         *-----------------------------------------------
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function writeln(const str : string) : IStdOut; override;

    end;

implementation

    constructor TThreadSafeStdout.create(
        const lock : TCriticalSection;
        const actualStdOut : IStdOut
    );
    begin
        inherited create(actualStdOut);
        fLock := lock;
    end;

    (*!------------------------------------------------
     * set stream to write to if any
     *-----------------------------------------------
     * @param stream, stream to write to
     * @return current instance
     *-----------------------------------------------*)
    function TThreadSafeStdOut.setStream(const astream : IStreamAdapter) : IStdOut;
    begin
        fLock.acquire();
        try
            inherited setStream(astream);
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
    function TThreadSafeStdOut.write(const str : string) : IStdOut;
    begin
        fLock.acquire();
        try
            inherited write(str);
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
    function TThreadSafeStdOut.writeln(const str : string) : IStdOut;
    begin
        fLock.acquire();
        try
            inherited writeln(str);
            result := self;
        finally
            fLock.release();
        end;
    end;

end.
