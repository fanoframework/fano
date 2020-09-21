{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StreamAdapterIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    classes;

const

    FROM_BEGINNING = soFromBeginning;
    FROM_CURRENT = soFromCurrent;
    FROM_END = soFromEnd;

type

    (*!------------------------------------------------
     * adapter interface for working with TStream descendant
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IStreamAdapter = interface
        ['{5BED84CE-FF09-4024-9CB1-F454E822FCE3}']

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

end.
