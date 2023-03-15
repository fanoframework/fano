{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StreamAdapterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    StreamAdapterIntf;

type

    (*!------------------------------------------------
     * adapter class that implements IStreamAdapter
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStreamAdapter = class(TInterfacedObject, IStreamAdapter)
    private
        isOwned : boolean;

        (*!------------------------------------------------
         * copy from source stream and store to destination stream
         *-----------------------------------------------
         * @param srcStream, source stream
         * @param dstStream, destination stream
         * @param bytesToCopy, number of bytes to copy
         *-----------------------------------------------*)
        procedure copyStream(
            const srcStream : IStreamAdapter;
            const dstStream : IStreamAdapter;
            const bytesToCopy : int64
        );

    protected
        actualStream : TStream;
    public
        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param stream instance of actual stream
         * @param owned true if streamInst is owned, meaning, its
         *        memory will be deallocated when destructor
         *        is called
         *-------------------------------------*)
        constructor create(const stream : TStream; const owned : boolean = true);

        (*!------------------------------------
         * destructor
         *-------------------------------------
         * if isOwned true, stream memory
         * will be deallocated when destructor
         * is called
         *-------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * get stream size
         *-----------------------------------------------
         * @return stream size in bytes
         *-----------------------------------------------*)
        function size() : int64;

        (*!------------------------------------------------
         * read from stream to buffer
         *-----------------------------------------------
         * @param buffer, buffer to store data read
         * @param sizeToRead, total size in bytes to read
         * @return total bytes actually read
         *-----------------------------------------------*)
        function read(var buffer; const sizeToRead : int64) : int64;

        (*!------------------------------------------------
         * write from buffer to stream
         *-----------------------------------------------
         * @param buffer, buffer contains data to write
         * @param sizeToWrite, total size in bytes to write
         * @return total bytes actually written
         *-----------------------------------------------*)
        function write(const buffer; const sizeToWrite : int64) : int64;

        (*!------------------------------------------------
         * read from stream to buffer until all data is read
         *-----------------------------------------------
         * @param buffer, buffer to store data read
         * @param sizeToRead, total size in bytes to read
         *-----------------------------------------------*)
        procedure readBuffer(var buffer; const sizeToRead : int64);

        (*!------------------------------------------------
         * write from buffer to stream until all data is written
         *-----------------------------------------------
         * @param buffer, buffer contains data to write
         * @param sizeToWrite, total size in bytes to write
         *-----------------------------------------------*)
        procedure writeBuffer(const buffer; const sizeToWrite : int64);

        (*!------------------------------------------------
         * read from current stream and store to destination stream
         *-----------------------------------------------
         * @param dstStream, destination stream
         * @param bytesToRead, number of bytes to read
         *-----------------------------------------------*)
        procedure readStream(const dstStream : IStreamAdapter; const bytesToRead : int64);

        (*!------------------------------------------------
         * write data from source stream to current stream
         *-----------------------------------------------
         * @param srcStream, source stream
         * @param bytesToWrite, number of bytes to write
         *-----------------------------------------------*)
        procedure writeStream(const srcStream : IStreamAdapter; const bytesToWrite : int64);

        (*!------------------------------------
         * seek
         *-------------------------------------
         * @param offset in bytes to seek start from beginning
         * @return actual offset
         *-------------------------------------
         * if offset >= stream size then it is capped
         * to stream size-1
         *-------------------------------------*)
        function seek(const offset : int64; const origin : word = FROM_BEGINNING) : int64;

        (*!------------------------------------------------
         * reset stream
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function reset() : IStreamAdapter;

        (*!------------------------------------------------
         * resize stream
         *-----------------------------------------------
         * @param newSize, stream new size in bytes
         * @return current instance
         *-----------------------------------------------*)
        function resize(const newSize : int64) : IStreamAdapter;
    end;

implementation

uses

    sysutils,
    math,
    EInvalidStreamImpl;

resourcestring

    SErrInvalidStream = 'Stream can not be nil';

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------
     * @param stream instance of stream
     *-----------------------------------------------
     * Note: because we use reference counting,
     * stream will be owned by adapter, so when
     * adapter destroy() is called, the stream also
     * be destroyed
     *-----------------------------------------------*)
    constructor TStreamAdapter.create(const stream : TStream; const owned : boolean = true);
    begin
        actualStream := stream;
        isOwned := owned;
        if (actualStream = nil) then
        begin
            raise EInvalidStream.create(SErrInvalidStream);
        end;
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------
     * Note: because we use reference counting,
     * we need stream also be destroyed
     *-----------------------------------------------*)
    destructor TStreamAdapter.destroy();
    begin
        inherited destroy();
        if (isOwned) then
        begin
            freeAndNil(actualStream);
        end;
    end;


    (*!------------------------------------------------
     * get stream size
     *-----------------------------------------------
     * @return stream size in bytes
     *-----------------------------------------------*)
    function TStreamAdapter.size() : int64;
    begin
        result := actualStream.size;
    end;

    (*!------------------------------------------------
     * read from stream to buffer
     *-----------------------------------------------
     * @param buffer, buffer to store data read
     * @param sizeToRead, total size in bytes to read
     * @return total bytes actually read
     *-----------------------------------------------*)
    function TStreamAdapter.read(var buffer; const sizeToRead : int64) : int64;
    begin
        result := actualStream.read(buffer, sizeToRead);
    end;

    (*!------------------------------------------------
     * write from buffer to stream
     *-----------------------------------------------
     * @param buffer, buffer contains data to write
     * @param sizeToWrite, total size in bytes to write
     * @return total bytes actually written
     *-----------------------------------------------*)
    function TStreamAdapter.write(const buffer; const sizeToWrite : int64) : int64;
    begin
        result := actualStream.write(buffer, sizeToWrite);
    end;

    (*!------------------------------------------------
     * read from stream to buffer until all data is read
     *-----------------------------------------------
     * @param buffer, buffer to store data read
     * @param sizeToRead, total size in bytes to read
     *-----------------------------------------------*)
    procedure TStreamAdapter.readBuffer(var buffer; const sizeToRead : int64);
    begin
        actualStream.readBuffer(buffer, sizeToRead);
    end;

    (*!------------------------------------------------
     * write from buffer to stream until all data is written
     *-----------------------------------------------
     * @param buffer, buffer contains data to write
     * @param sizeToWrite, total size in bytes to write
     *-----------------------------------------------*)
    procedure TStreamAdapter.writeBuffer(const buffer; const sizeToWrite : int64);
    begin
        actualStream.writeBuffer(buffer, sizeToWrite);
    end;

    (*!------------------------------------------------
     * copy from source stream and store to destination stream
     *-----------------------------------------------
     * @param srcStream, source stream
     * @param dstStream, destination stream
     * @param bytesToCopy, number of bytes to copy
     *-----------------------------------------------*)
    procedure TStreamAdapter.copyStream(
        const srcStream : IStreamAdapter;
        const dstStream : IStreamAdapter;
        const bytesToCopy : int64
    );
    const MAX_BUFF_SIZE = 4096;
    var buff : pointer;
        buffSize, excessBytes : int64;
        i, totIteration : integer;
    begin
        if (bytesToCopy = 0) then
        begin
            exit();
        end;

        buffSize := min(MAX_BUFF_SIZE, bytesToCopy);
        totIteration := bytesToCopy div buffSize;
        excessBytes := bytesToCopy mod buffSize;

        getMem(buff, buffSize);
        try
            for i:= 0 to totIteration-1 do
            begin
                srcStream.readBuffer(buff^, buffSize);
                dstStream.writeBuffer(buff^, buffSize);
            end;

            if (excessBytes > 0) then
            begin
                srcStream.readBuffer(buff^, excessBytes);
                dstStream.writeBuffer(buff^, excessBytes);
            end;
        finally
            freeMem(buff);
        end;
    end;

    (*!------------------------------------------------
     * read from current stream and store to destination stream
     *-----------------------------------------------
     * @param dstStream, destination stream
     * @param bytesToRead, number of bytes to read
     *-----------------------------------------------*)
    procedure TStreamAdapter.readStream(const dstStream : IStreamAdapter; const bytesToRead : int64);
    begin
        copyStream(self, dstStream, bytesToRead);
    end;

    (*!------------------------------------------------
     * write data from source stream to current stream
     *-----------------------------------------------
     * @param srcStream, source stream
     * @param bytesToWrite, number of bytes to write
     *-----------------------------------------------*)
    procedure TStreamAdapter.writeStream(const srcStream : IStreamAdapter; const bytesToWrite : int64);
    begin
        copyStream(srcStream, self, bytesToWrite);
    end;

    (*!------------------------------------
     * seek
     *-------------------------------------
     * @param offset in bytes to seek start from beginning
     * @return actual offset
     *-------------------------------------
     * if offset >= stream size then it is capped
     * to stream size-1
     *-------------------------------------*)
    function TStreamAdapter.seek(const offset : int64; const origin : word = FROM_BEGINNING) : int64;
    begin
        result := actualStream.seek(offset, origin);
    end;

    (*!------------------------------------------------
     * reset stream
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TStreamAdapter.reset() : IStreamAdapter;
    begin
        actualStream.size := 0;
        seek(0);
        result := self;
    end;

    (*!------------------------------------------------
     * resize stream
     *-----------------------------------------------
     * @param newSize, stream new size in bytes
     * @return current instance
     *-----------------------------------------------*)
    function TStreamAdapter.resize(const newSize : int64) : IStreamAdapter;
    begin
        actualStream.size := newSize;
        result := self;
    end;
end.
