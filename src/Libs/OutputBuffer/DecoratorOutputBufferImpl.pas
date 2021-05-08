{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorOutputBufferImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    OutputBufferIntf;

type

    (*!------------------------------------------------
     * decorator class having capability to buffer
     * standard output to a storage
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TDecoratorOutputBuffer = class (TInterfacedObject, IOutputBuffer)
    protected
        fActualOutputBuffer : IOutputBuffer;
    public
        constructor create(const actualOutputBuffer : IOutputBuffer);

        {------------------------------------------------
         begin output buffering
        -----------------------------------------------}
        function beginBuffering() : IOutputBuffer; virtual;

        {------------------------------------------------
         end output buffering
        -----------------------------------------------}
        function endBuffering() : IOutputBuffer; virtual;

        {------------------------------------------------
         read output buffer content
        -----------------------------------------------}
        function read() : string; virtual;

        {------------------------------------------------
         read output buffer content and empty the buffer
        -----------------------------------------------}
        function flush() : string; virtual;

        {------------------------------------------------
         read content length
        -----------------------------------------------}
        function size() : int64; virtual;
    end;

implementation

    constructor TDecoratorOutputBuffer.create(const actualOutputBuffer : IOutputBuffer);
    begin
        fActualOutputBuffer := actualOutputBuffer;
    end;

    function TDecoratorOutputBuffer.beginBuffering() : IOutputBuffer;
    begin
        fActualOutputBuffer.beginBuffering();
        result := self;
    end;

    function TDecoratorOutputBuffer.endBuffering() : IOutputBuffer;
    begin
        fActualOutputBuffer.endBuffering();
        result := self;
    end;

    function TDecoratorOutputBuffer.read() : string;
    begin
        result := fActualOutputBuffer.read();
    end;

    function TDecoratorOutputBuffer.flush() : string;
    begin
        result := fActualOutputBuffer.flush();
    end;

    function TDecoratorOutputBuffer.size() : int64;
    begin
        result := fActualOutputBuffer.size();
    end;
end.
