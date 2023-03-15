{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NonBlockingProtocolProcessorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ListIntf,
    StreamAdapterIntf,
    CloseableIntf,
    StreamIdIntf,
    ReadyListenerIntf,
    ProtocolProcessorIntf;

type

    TBuffInfo = record
        id : shortstring;
        buffer : IStreamAdapter;
        expectedSize : int64;
    end;

    PBuffInfo = ^TBuffInfo;

    (*!-----------------------------------------------
     * class having capability to process
     * stream from web server in non-blocking fashion
     * this class basically just collect all data until
     * it is completed, then it calls actual processor
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNonBlockingProtocolProcessor = class(TInterfacedObject, IProtocolProcessor)
    private
        fBuffLists : IList;
        fActualProcessor : IProtocolProcessor;

        procedure clearBuffers();


        (*!------------------------------------------------
         * read socket stream to memory
         *-----------------------------------------------
         * @param sockStream socket stream adapter
         * @param buffInfo temporary buffer
         * @return true if all data is complete
         *-----------------------------------------------*)
        function nonBlockingCopyStream(
            const sockStream : IStreamAdapter;
            const buffInfo : PBuffInfo
        ) : boolean;

        procedure nonBlockingCopyBuffer(
            const sockStream : IStreamAdapter;
            const buffInfo : PBuffInfo;
            const buff : pointer;
            const buffSize : integer;
            var keepReading : boolean
        );

        procedure processBuffer(
            buff : PBuffInfo;
            const stream : IStreamAdapter;
            const streamCloser : ICloseable;
            const streamId : IStreamId
        );
    public
        constructor create(
            const actualProcessor : IProtocolProcessor;
            const buffList : IList
        );
        destructor destroy(); override;

        (*!------------------------------------------------
         * process request stream
         *-----------------------------------------------*)
        function process(
            const stream : IStreamAdapter;
            const streamCloser : ICloseable;
            const streamId : IStreamId
        ) : boolean;

        (*!------------------------------------------------
         * get StdIn stream for complete request
         *-----------------------------------------------*)
        function getStdIn() : IStreamAdapter;

        (*!------------------------------------------------
         * set listener to be notified when request is ready
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function setReadyListener(const listener : IReadyListener) : IProtocolProcessor;

        (*!------------------------------------------------
         * get number of bytes of complete request based
         * on information buffer
         *-----------------------------------------------
         * @return number of bytes of complete request
         *-----------------------------------------------*)
        function expectedSize(const buff : IStreamAdapter) : int64;
    end;

implementation

uses

    SysUtils,
    Classes,
    BaseUnix,
    StreamAdapterImpl,
    SegregatedStreamAdapterImpl,
    ESockStreamImpl,
    ESockWouldBlockImpl;

    constructor TNonBlockingProtocolProcessor.create(
        const actualProcessor : IProtocolProcessor;
        const buffList : IList
    );
    begin
        inherited create();
        fActualProcessor := actualProcessor;
        fBuffLists := buffList;
    end;

    destructor TNonBlockingProtocolProcessor.destroy();
    begin
        clearBuffers();
        fBuffLists := nil;
        fActualProcessor := nil;
        inherited destroy();
    end;

    procedure TNonBlockingProtocolProcessor.clearBuffers();
    var i, len : integer;
        buff : PBuffInfo;
    begin
        len := fBuffLists.count();
        for i := len -1 downto 0 do
        begin
            buff := fBuffLists.get(i);
            fBuffLists.delete(i);
            buff^.buffer := nil;
            dispose(buff);
        end;
    end;

    procedure TNonBlockingProtocolProcessor.nonBlockingCopyBuffer(
        const sockStream : IStreamAdapter;
        const buffInfo : PBuffInfo;
        const buff : pointer;
        const buffSize : integer;
        var keepReading : boolean
    );
    var bytesRead : longint;
        remainingSize, tmpSize : int64;
    begin
        try
            tmpSize := buffSize;
            if (buffInfo^.expectedSize <> UNKNOWN_SIZE) then
            begin
                remainingSize := buffInfo^.expectedSize - buffInfo^.buffer.size();
                if remainingSize < buffSize then
                begin
                    tmpSize := remainingSize;
                end;
            end;

            bytesRead := sockStream.read(buff^, tmpSize);
            if (bytesRead > 0) then
            begin
                buffInfo^.buffer.write(buff^, bytesRead);
                if (buffInfo^.expectedSize = UNKNOWN_SIZE) then
                begin
                    //try to get number of expected bytes if any available
                    buffInfo^.expectedSize := fActualProcessor.expectedSize(
                        buffInfo^.buffer
                    );
                end else
                begin
                    if (buffInfo^.buffer.size() = buffInfo^.expectedSize) then
                    begin
                        keepReading := false;
                    end;
                end;
            end else
            if (bytesRead = 0) then
            begin
                //end of file
                keepReading := false;
            end;
        except
            on e : ESockWouldBlock do
            begin
                keepReading := false;
            end;
        end;
    end;

    function TNonBlockingProtocolProcessor.nonBlockingCopyStream(
        const sockStream : IStreamAdapter;
        const buffInfo : PBuffInfo
    ) : boolean;
    const BUFF_SIZE = 4096;
    var buff : pointer;
        keepReading : boolean;
    begin
        getMem(buff, BUFF_SIZE);
        try
            keepReading := true;
            while keepReading do
            begin
                nonBlockingCopyBuffer(
                    sockStream,
                    buffInfo,
                    buff,
                    BUFF_SIZE,
                    keepReading
                );
            end;
            result := (buffInfo^.expectedSize <> UNKNOWN_SIZE) and
                (buffInfo ^.buffer.size() = buffInfo^.expectedSize);
        finally
            freeMem(buff);
        end;
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    procedure TNonBlockingProtocolProcessor.processBuffer(
        buff : PBuffInfo;
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    );
    var segStream : IStreamAdapter;
    begin
        //we use segregated stream, so that we can read from data in memory
        //but write to socket
        segStream := TSegregatedStreamAdapter.create(buff^.buffer, stream);
        buff^.buffer.seek(0, soFromBeginning);
        fActualProcessor.process(segStream, streamCloser, streamId);
        //data has been processed, remove buffer.
        fBuffLists.delete(fBuffLists.indexOf(buff^.id));
        buff^.buffer := nil;
        dispose(buff);
    end;

    (*!------------------------------------------------
     * process request stream
     *-----------------------------------------------*)
    function TNonBlockingProtocolProcessor.process(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    ) : boolean;
    var id : shortString;
        buff : PBuffInfo;
    begin
        result := false;
        id := streamId.getId();
        buff := fBuffLists.find(id);
        if (buff = nil) then
        begin
            new(buff);
            buff^.id := id;
            buff^.buffer := TStreamAdapter.create(TMemoryStream.create());
            buff^.expectedSize := UNKNOWN_SIZE;
            fBuffLists.add(id, buff);
        end;

        if nonBlockingCopyStream(stream, buff) then
        begin
            //all data is complete, process it
            processBuffer(buff, stream, streamCloser, streamId);
            result := true;
        end;
    end;

    (*!------------------------------------------------
     * get StdIn stream for complete request
     *-----------------------------------------------*)
    function TNonBlockingProtocolProcessor.getStdIn() : IStreamAdapter;
    begin
        result := fActualProcessor.getStdIn();
    end;

    (*!------------------------------------------------
     * set listener to be notified when request is ready
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TNonBlockingProtocolProcessor.setReadyListener(const listener : IReadyListener) : IProtocolProcessor;
    begin
        fActualProcessor.setReadyListener(listener);
        result := self;
    end;

    (*!------------------------------------------------
     * get number of bytes of complete request based
     * on information buffer
     *-----------------------------------------------
     * @return number of bytes of complete request
     *-----------------------------------------------*)
    function TNonBlockingProtocolProcessor.expectedSize(const buff : IStreamAdapter) : int64;
    begin
        result := fActualProcessor.expectedSize(buff);
    end;
end.
