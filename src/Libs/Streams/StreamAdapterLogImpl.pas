{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StreamAdapterLogImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    StreamAdapterIntf,
    LoggerIntf;

type

    (*!------------------------------------------------
     * adapter class that implements IStreamAdapter and
     * write log each call
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStreamAdapterLog = class(TInterfacedObject, IStreamAdapter)
    private
        actualStream : IStreamAdapter;
    protected
        actualLogger : ILogger;
    public
        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param stream instance of actual IStreamAdapter interface
         * @param logger instance of ILogger interface
         *-------------------------------------*)
        constructor create(const stream : IStreamAdapter; const logger : ILogger);

        (*!------------------------------------
         * destructor
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

    SysUtils;

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
    constructor TStreamAdapterLog.create(const stream : IStreamAdapter; const logger : ILogger);
    begin
        actualStream := stream;
        actualLogger := logger;
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------
     * Note: because we use reference counting,
     * we need stream also be destroyed
     *-----------------------------------------------*)
    destructor TStreamAdapterLog.destroy();
    begin
        inherited destroy();
        actualStream := nil;
        actualLogger := nil;
    end;


    (*!------------------------------------------------
     * get stream size
     *-----------------------------------------------
     * @return stream size in bytes
     *-----------------------------------------------*)
    function TStreamAdapterLog.size() : int64;
    begin
        result := actualStream.size();
        actualLogger.debug('StreamAdapterLog size ' + intToStr(result) + ' bytes');
    end;

    (*!------------------------------------------------
     * read from stream to buffer
     *-----------------------------------------------
     * @param buffer, buffer to store data read
     * @param sizeToRead, total size in bytes to read
     * @return total bytes actually read
     *-----------------------------------------------*)
    function TStreamAdapterLog.read(var buffer; const sizeToRead : int64) : int64;
    begin
        result := actualStream.read(buffer, sizeToRead);
        actualLogger.debug('StreamAdapterLog read ' + intToStr(sizeToRead) + ' bytes');
    end;

    (*!------------------------------------------------
     * write from buffer to stream
     *-----------------------------------------------
     * @param buffer, buffer contains data to write
     * @param sizeToWrite, total size in bytes to write
     * @return total bytes actually written
     *-----------------------------------------------*)
    function TStreamAdapterLog.write(const buffer; const sizeToWrite : int64) : int64;
    begin
        result := actualStream.write(buffer, sizeToWrite);
        actualLogger.debug('StreamAdapterLog write ' + intToStr(sizeToWrite) + ' bytes');
    end;

    (*!------------------------------------------------
     * read from stream to buffer
     *-----------------------------------------------
     * @param buffer, buffer to store data read
     * @param sizeToRead, total size in bytes to read
     * @return total bytes actually read
     *-----------------------------------------------*)
    procedure TStreamAdapterLog.readBuffer(var buffer; const sizeToRead : int64);
    begin
        actualStream.readBuffer(buffer, sizeToRead);
        actualLogger.debug('StreamAdapterLog read buffer ' + intToStr(sizeToRead) + ' bytes');
    end;

    (*!------------------------------------------------
     * write from buffer to stream
     *-----------------------------------------------
     * @param buffer, buffer contains data to write
     * @param sizeToWrite, total size in bytes to write
     * @return total bytes actually written
     *-----------------------------------------------*)
    procedure TStreamAdapterLog.writeBuffer(const buffer; const sizeToWrite : int64);
    begin
        actualStream.writeBuffer(buffer, sizeToWrite);
        actualLogger.debug('StreamAdapterLog write buffer ' + intToStr(sizeToWrite) + ' bytes');
    end;

    (*!------------------------------------------------
     * read from current stream and store to destination stream
     *-----------------------------------------------
     * @param dstStream, destination stream
     * @param bytesToRead, number of bytes to read
     *-----------------------------------------------*)
    procedure TStreamAdapterLog.readStream(const dstStream : IStreamAdapter; const bytesToRead : int64);
    begin
        actualStream.readStream(dstStream, bytesToRead);
        actualLogger.debug('StreamAdapterLog read stream ' + intToStr(bytesToRead) + ' bytes');
    end;

    (*!------------------------------------------------
     * write data from source stream to current stream
     *-----------------------------------------------
     * @param srcStream, source stream
     * @param bytesToWrite, number of bytes to write
     *-----------------------------------------------*)
    procedure TStreamAdapterLog.writeStream(const srcStream : IStreamAdapter; const bytesToWrite : int64);
    begin
        actualStream.writeStream(srcStream, bytesToWrite);
        actualLogger.debug('StreamAdapterLog write stream ' + intToStr(bytesToWrite) + ' bytes');
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
    function TStreamAdapterLog.seek(const offset : int64; const origin : word = FROM_BEGINNING) : int64;
    begin
        result := actualStream.seek(offset, origin);
        actualLogger.debug('StreamAdapterLog seek ' + intToStr(offset) + ' bytes');
    end;

    (*!------------------------------------------------
     * reset stream
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TStreamAdapterLog.reset() : IStreamAdapter;
    begin
        actualStream.reset();
        actualLogger.debug('StreamAdapterLog reset');
        result := self;
    end;

    (*!------------------------------------------------
     * resize stream
     *-----------------------------------------------
     * @param newSize, stream new size in bytes
     * @return current instance
     *-----------------------------------------------*)
    function TStreamAdapterLog.resize(const newSize : int64) : IStreamAdapter;
    begin
        actualStream.resize(newSize);
        actualLogger.debug('StreamAdapterLog resize ' + intToStr(newSize) + ' bytes');
        result := self;
    end;
end.
