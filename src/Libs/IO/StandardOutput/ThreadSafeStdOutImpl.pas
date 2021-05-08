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
    StreamAdapterIntf,
    StdOutIntf,
    DecoratorStdOutImpl;

type

    (*!------------------------------------------------
     * decorator class having capability to
     * write string to standard output
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeStdOut = class(TDecoratorStdOut)
    private
        fCriticalSection : TCriticalSection;
    public
        constructor create(const actualStdOut : IStdOut);
        destructor destroy(); override;
        function setStream(const astream : IStreamAdapter) : IStdOut; override;
        function write(const str : string) : IStdOut; override;
        function writeln(const str : string = '') : IStdOut; override;
    end;

implementation

    constructor TThreadSafeStdOut.create(const actualStdOut : IStdOut);
    begin
        inherited create(actualStdOut);
        fCriticalSection := TCriticalSection.create();
    end;

    destructor TThreadSafeStdOut.destroy();
    begin
        fCriticalSection.free();
        inherited destroy();
    end;

    function TThreadSafeStdOut.setStream(const astream : IStreamAdapter) : IStdOut;
    begin
        fCriticalSection.acquire();
        try
            inherited setStream(astream);
            result := self;
        finally
            fCriticalSection.release();
        end;
    end;

    function TThreadSafeStdOut.write(const str : string) : IStdOut;
    begin
        fCriticalSection.acquire();
        try
            inherited write(str);
            result := self;
        finally
            fCriticalSection.release();
        end;
    end;

    function TThreadSafeStdOut.writeln(const str : string = '') : IStdOut;
    begin
        fCriticalSection.acquire();
        try
            inherited writeln(str);
            result := self;
        finally
            fCriticalSection.release();
        end;
    end;

end.
