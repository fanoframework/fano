{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeStdInImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    InjectableObjectImpl,
    StreamAdapterIntf,
    StdInIntf,
    DecoratorStdInImpl;

type

    (*!------------------------------------------------
     * thread-safe decorator IStdIn implementation class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeStdIn = class(TDecoratorStdIn)
    private
        fCriticalSection : TCriticalSection;
    public
        constructor create(const actualStdIn : IStdIn);
        destructor destroy(); override;

        (*!------------------------------------------------
         * set stream to write to if any
         *-----------------------------------------------
         * @param stream, stream to write to
         * @return current instance
         *-----------------------------------------------*)
        function setStream(const astream : IStreamAdapter) : IStdIn; override;

        function readStdIn(const contentLength : int64) : string; override;
    end;

implementation

    constructor TThreadSafeStdIn.create(const actualStdIn : IStdIn);
    begin
        inherited create(actualStdIn);
        fCriticalSection := TCriticalSection.create();
    end;

    destructor TThreadSafeStdIn.destroy();
    begin
        fCriticalSection.free();
        inherited destroy();
    end;

    function TThreadSafeStdIn.readStdIn(const contentLength : int64) : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited readStdIn(contentLength);
        finally
            fCriticalSection.release();
        end;
    end;

    (*!------------------------------------------------
     * set stream to write to if any
     *-----------------------------------------------
     * @param stream, stream to write to
     * @return current instance
     *-----------------------------------------------*)
    function TThreadSafeStdIn.setStream(const astream : IStreamAdapter) : IStdIn;
    begin
        fCriticalSection.acquire();
        try
            inherited setStream(astream);
            result := self;
        finally
            fCriticalSection.release();
        end;
    end;
end.
