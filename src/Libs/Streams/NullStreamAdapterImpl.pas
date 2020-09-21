{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullStreamAdapterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf;

type

    (*!------------------------------------------------
     * adapter class that implements IStreamAdapter but
     * does nothing
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullStreamAdapter = class(TInterfacedObject, IStreamAdapter)
    public
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
        function seek(const offset : int64; const origin : word = FROM_CURRENT) : int64;

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


    (*!------------------------------------------------
     * get stream size
     *-----------------------------------------------
     * @return stream size in bytes
     *-----------------------------------------------*)
    function TNullStreamAdapter.size() : int64;
    begin
        //intentionally return empty stream
        result := 0;
    end;

    (*!------------------------------------------------
     * read from stream to buffer
     *-----------------------------------------------
     * @param buffer, buffer to store data read
     * @param sizeToRead, total size in bytes to read
     * @return total bytes actually read
     *-----------------------------------------------*)
    function TNullStreamAdapter.read(var buffer; const sizeToRead : int64) : int64;
    begin
        //intentionally does nothing
        result := 0;
    end;

    (*!------------------------------------------------
     * write from buffer to stream
     *-----------------------------------------------
     * @param buffer, buffer contains data to write
     * @param sizeToWrite, total size in bytes to write
     * @return total bytes actually written
     *-----------------------------------------------*)
    function TNullStreamAdapter.write(const buffer; const sizeToWrite : int64) : int64;
    begin
        //intentionally does nothing
        result := 0;
    end;

    (*!------------------------------------------------
     * read from stream to buffer
     *-----------------------------------------------
     * @param buffer, buffer to store data read
     * @param sizeToRead, total size in bytes to read
     * @return total bytes actually read
     *-----------------------------------------------*)
    procedure TNullStreamAdapter.readBuffer(var buffer; const sizeToRead : int64);
    begin
        //intentionally does nothing
    end;

    (*!------------------------------------------------
     * write from buffer to stream
     *-----------------------------------------------
     * @param buffer, buffer contains data to write
     * @param sizeToWrite, total size in bytes to write
     * @return total bytes actually written
     *-----------------------------------------------*)
    procedure TNullStreamAdapter.writeBuffer(const buffer; const sizeToWrite : int64);
    begin
        //intentionally does nothing
    end;

    (*!------------------------------------------------
     * read from current stream and store to destination stream
     *-----------------------------------------------
     * @param dstStream, destination stream
     * @param bytesToRead, number of bytes to read
     *-----------------------------------------------*)
    procedure TNullStreamAdapter.readStream(const dstStream : IStreamAdapter; const bytesToRead : int64);
    begin
        //intentionally does nothing
    end;

    (*!------------------------------------------------
     * write data from source stream to current stream
     *-----------------------------------------------
     * @param srcStream, source stream
     * @param bytesToWrite, number of bytes to write
     *-----------------------------------------------*)
    procedure TNullStreamAdapter.writeStream(const srcStream : IStreamAdapter; const bytesToWrite : int64);
    begin
        //intentionally does nothing
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
    function TNullStreamAdapter.seek(const offset : int64; const origin : word = FROM_CURRENT) : int64;
    begin
        //intentionally does nothing
        result := 0;
    end;

    (*!------------------------------------------------
     * reset stream
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TNullStreamAdapter.reset() : IStreamAdapter;
    begin
        //intentionally does nothing
        result := self;
    end;

    (*!------------------------------------------------
     * resize stream
     *-----------------------------------------------
     * @param newSize, stream new size in bytes
     * @return current instance
     *-----------------------------------------------*)
    function TNullStreamAdapter.resize(const newSize : int64) : IStreamAdapter;
    begin
        //intentionally does nothing
        result := self;
    end;
end.
