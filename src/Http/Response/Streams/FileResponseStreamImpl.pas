{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FileResponseStreamImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    ResponseStreamIntf;

type

    (*!----------------------------------------------
     * response stream that load its data from file
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFileResponseStream = class(TInterfacedObject, IStreamAdapter, IResponseStream)
    private
        fFilename : string;
        fStream : IStreamAdapter;
    public
        constructor create(const filename : string);

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

        (*!------------------------------------
         * write string to stream
         *-------------------------------------
         * @param buffer string to write
         * @return number of bytes actually written
         *-------------------------------------*)
        function write(const buffer : string) : int64; overload;

        (*!------------------------------------
         * read stream to string
         *-------------------------------------
         * @return string
         *-------------------------------------*)
        function read() : string; overload;
    end;

implementation

uses

    SysUtils,
    Classes,
    StreamAdapterImpl;


    constructor TFileResponseStream.create(const filename : string);
    begin
        fFilename := filename;
        fStream := TStreamAdapter.create(TFileStream.create(fFilename, fmOpenReadWrite));
    end;

    (*!------------------------------------------------
     * get stream size
     *-----------------------------------------------
     * @return stream size in bytes
     *-----------------------------------------------*)
    function TFileResponseStream.size() : int64;
    begin
        result := fStream.size();
    end;

    (*!------------------------------------------------
     * read from stream to buffer
     *-----------------------------------------------
     * @param buffer, buffer to store data read
     * @param sizeToRead, total size in bytes to read
     * @return total bytes actually read
     *-----------------------------------------------*)
    function TFileResponseStream.read(var buffer; const sizeToRead : int64) : int64;
    begin
        result := fStream.read(buffer, sizeToRead);
    end;

    (*!------------------------------------------------
     * write from buffer to stream
     *-----------------------------------------------
     * @param buffer, buffer contains data to write
     * @param sizeToWrite, total size in bytes to write
     * @return total bytes actually written
     *-----------------------------------------------*)
    function TFileResponseStream.write(const buffer; const sizeToWrite : int64) : int64;
    begin
        result := fStream.write(buffer, sizeToWrite);
    end;

    (*!------------------------------------------------
     * read from stream to buffer until all data is read
     *-----------------------------------------------
     * @param buffer, buffer to store data read
     * @param sizeToRead, total size in bytes to read
     *-----------------------------------------------*)
    procedure TFileResponseStream.readBuffer(var buffer; const sizeToRead : int64);
    begin
        fStream.readBuffer(buffer, sizeToRead);
    end;

    (*!------------------------------------------------
     * write from buffer to stream until all data is written
     *-----------------------------------------------
     * @param buffer, buffer contains data to write
     * @param sizeToWrite, total size in bytes to write
     *-----------------------------------------------*)
    procedure TFileResponseStream.writeBuffer(const buffer; const sizeToWrite : int64);
    begin
        fStream.writeBuffer(buffer, sizeToWrite);
    end;

    (*!------------------------------------------------
     * read from current stream and store to destination stream
     *-----------------------------------------------
     * @param dstStream, destination stream
     * @param bytesToRead, number of bytes to read
     *-----------------------------------------------*)
    procedure TFileResponseStream.readStream(const dstStream : IStreamAdapter; const bytesToRead : int64);
    begin
        fStream.readStream(dstStream, bytesToRead);
    end;

    (*!------------------------------------------------
     * write data from source stream to current stream
     *-----------------------------------------------
     * @param srcStream, source stream
     * @param bytesToWrite, number of bytes to write
     *-----------------------------------------------*)
    procedure TFileResponseStream.writeStream(const srcStream : IStreamAdapter; const bytesToWrite : int64);
    begin
        fStream.writeStream(srcStream, bytesToWrite);
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
    function TFileResponseStream.seek(const offset : int64; const origin : word = FROM_BEGINNING) : int64;
    begin
        result := fStream.seek(offset, origin);
    end;

    (*!------------------------------------------------
     * reset stream
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TFileResponseStream.reset() : IStreamAdapter;
    begin
        fStream.reset();
        result := self;
    end;

    (*!------------------------------------------------
     * resize stream
     *-----------------------------------------------
     * @param newSize, stream new size in bytes
     * @return current instance
     *-----------------------------------------------*)
    function TFileResponseStream.resize(const newSize : int64) : IStreamAdapter;
    begin
        fStream.resize(newSize);
        result := self;
    end;

    (*!------------------------------------
     * write string to stream
     *-------------------------------------
     * @param buffer string to write
     * @return number of bytes actually written
     *-------------------------------------*)
    function TFileResponseStream.write(const buffer : string) : int64;
    begin
        result := 0;
        if buffer <> '' then
        begin
            result := fStream.write(buffer[1], length(buffer));
        end;
    end;

    (*!------------------------------------
     * read stream to string
     *-------------------------------------
     * @return string
     *-------------------------------------*)
    function TFileResponseStream.read() : string;
    begin
        fStream.seek(0);
        setLength(result, fStream.size());
        if (fStream.size() > 0) then
        begin
            fStream.read(result[1], length(result));
        end;
    end;

end.
