{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiFrameParserIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    FcgiRecordIntf,
    StreamAdapterIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to parse
     * FastCGI Frame
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IFcgiFrameParser = interface
        ['{06B79D63-55E3-4B6E-BFD9-65CE6ED72636}']

        (*!------------------------------------------------
         * read stream and return found record in memory buffer
         *-----------------------------------------------
         * @param bufPtr, memory buffer to store FastCGI record
         * @param bufSize, memory buffer size
         * @return true if stream is exhausted
         *-----------------------------------------------*)
        function readRecord(
            const stream : IStreamAdapter;
            out bufPtr : pointer;
            out bufSize : ptrUint
        ) : boolean;

        (*!------------------------------------------------
        * test if buffer contain FastCGI frame package
        * i.e FastCGI header + payload
        *-----------------------------------------------
        * @param buffer, pointer to current buffer
        * @return true if buffer contain valid frame
        *-----------------------------------------------*)
        function hasFrame(const buffer : pointer;  const bufferSize : ptrUint) : boolean;

        (*!------------------------------------------------
         * parse current buffer and create its corresponding
         * FastCGI record instance
         *-----------------------------------------------
         * @param buffer, pointer to current buffer
         * @param bufferSize, size of buffer
         * @return IFcgiRecord instance
         * @throws EInvalidFcgiBuffer exception when buffer is nil
         * @throws EInvalidFcgiHeaderLen exception when header size not valid
         *-----------------------------------------------*)
        function parseFrame(const buffer : pointer;  const bufferSize : ptrUint) : IFcgiRecord;
    end;

implementation

end.
