{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit OutputBufferExImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    classes,
    DependencyIntf,
    OutputBufferIntf,
    OutputBufferStreamIntf;

type

    (*!------------------------------------------------
     * class having capability to buffer
     * standard output to a storage using stream
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TOutputBufferEx = class(TInterfacedObject, IOutputBuffer, IDependency)
    private
        stream : IOutputBufferStream;
        isBuffering : boolean;
    protected
        originalStdOutput, streamStdOutput: TextFile;
        procedure redirectOutput(); virtual;
        procedure restoreOutput(); virtual;
    public
        constructor create(const aStream : IOutputBufferStream);
        destructor destroy(); override;

        {------------------------------------------------
         begin output buffering
        -----------------------------------------------}
        function beginBuffering() : IOutputBuffer;

        {------------------------------------------------
         end output buffering
        -----------------------------------------------}
        function endBuffering() : IOutputBuffer;

        {------------------------------------------------
         read output buffer content
        -----------------------------------------------}
        function read() : string;

        {------------------------------------------------
         read output buffer content and empty the buffer
        -----------------------------------------------}
        function flush() : string;
    end;

implementation

    constructor TOutputBufferEx.create(const aStream : IOutputBufferStream);
    begin
        stream := aStream;
        isBuffering := false;
    end;

    destructor TOutputBufferEx.destroy();
    begin
        inherited destroy();
        isBuffering := false;
        stream := nil;

    end;

    procedure TOutputBufferEx.redirectOutput();
    begin
        //save original standard output, we can restore it
        originalStdOutput := Output;
        Output := streamStdOutput;
    end;

    procedure TOutputBufferEx.restoreOutput();
    begin
        //restore original standard output
        Output := originalStdOutput;
    end;

    {------------------------------------------------
     begin output buffering
    -----------------------------------------------}
    function TOutputBufferEx.beginBuffering() : IOutputBuffer;
    begin
        if (not isBuffering) then
        begin
            isBuffering := true;
            stream.clear();
            stream.assignToFile(streamStdOutput);
            rewrite(streamStdOutput);
            redirectOutput();
        end;
        result := self;
    end;

    {------------------------------------------------
     end output buffering
    -----------------------------------------------}
    function TOutputBufferEx.endBuffering() : IOutputBuffer;
    begin
        if (isBuffering) then
        begin
            isBuffering := false;
            restoreOutput();
            stream.seek(0);
            closeFile(streamStdOutput);
        end;
        result := self;
    end;

    {------------------------------------------------
     read output buffer content
    -----------------------------------------------}
    function TOutputBufferEx.read() : string;
    begin
        result := stream.getContent();
    end;

    {------------------------------------------------
     read output buffer content and empty the buffer
    -----------------------------------------------}
    function TOutputBufferEx.flush() : string;
    begin
        result := stream.getContent();
        stream.clear();
    end;

    {------------------------------------------------
     read content length
    -----------------------------------------------}
    function TOutputBufferEx.size() : int64;
    begin
        result := stream.size;
    end;
end.
