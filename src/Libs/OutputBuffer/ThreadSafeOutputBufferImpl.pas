{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeOutputBufferImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    OutputBufferIntf,
    DecoratorOutputBufferImpl;

type

    (*!------------------------------------------------
     * thread-safe decorator class having capability to buffer
     * standard output to a storage
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TThreadSafeOutputBuffer = class (TDecoratorOutputBuffer)
    private
        fCriticalSection : TCriticalSection;
    public
        constructor create(const actualOutputBuffer : IOutputBuffer);
        destructor destroy(); override;

        {------------------------------------------------
         begin output buffering
        -----------------------------------------------}
        function beginBuffering() : IOutputBuffer; override;

        {------------------------------------------------
         end output buffering
        -----------------------------------------------}
        function endBuffering() : IOutputBuffer; override;

        {------------------------------------------------
         read output buffer content
        -----------------------------------------------}
        function read() : string; override;

        {------------------------------------------------
         read output buffer content and empty the buffer
        -----------------------------------------------}
        function flush() : string; override;

        {------------------------------------------------
         read content length
        -----------------------------------------------}
        function size() : int64; override;
    end;

implementation

    constructor TThreadSafeOutputBuffer.create(const actualOutputBuffer : IOutputBuffer);
    begin
        inherited create(actualOutputBuffer);
        fCriticalSection := TCriticalSection.create();
    end;

    destructor TThreadSafeOutputBuffer.destroy();
    begin
        fCriticalSection.free();
        inherited destroy();
    end;

    function TThreadSafeOutputBuffer.beginBuffering() : IOutputBuffer;
    begin
        fCriticalSection.acquire();
        try
            inherited beginBuffering();
            result := self;
        finally
            fCriticalSection.release();
        end;
    end;

    function TThreadSafeOutputBuffer.endBuffering() : IOutputBuffer;
    begin
        fCriticalSection.acquire();
        try
            inherited endBuffering();
            result := self;
        finally
            fCriticalSection.release();
        end;
    end;

    function TThreadSafeOutputBuffer.read() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited read();
        finally
            fCriticalSection.release();
        end;
    end;

    function TThreadSafeOutputBuffer.flush() : string;
    begin
        fCriticalSection.acquire();
        try
            result := inherited flush();
        finally
            fCriticalSection.release();
        end;
    end;

    function TThreadSafeOutputBuffer.size() : int64;
    begin
        fCriticalSection.acquire();
        try
            result := inherited size();
        finally
            fCriticalSection.release();
        end;
    end;
end.
