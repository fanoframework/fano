{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiRecordIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    StreamAdapterAwareIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to hold
     * FastCGI record
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IFcgiRecord = interface(IStreamAdapterAware)
        ['{93576A1E-23AB-4DC0-AFA7-DAEDB067F8C1}']

        (*!------------------------------------------------
         * get current record type
         *-----------------------------------------------
         * @return type of record
          *-----------------------------------------------*)
        function getType() : byte;

        (*!------------------------------------------------
         * get request id
         *-----------------------------------------------
         * @return request id
         *-----------------------------------------------*)
        function getRequestId() : word;

        (*!------------------------------------------------
         * get content length
         *-----------------------------------------------
         * @return content length
         *-----------------------------------------------*)
        function getContentLength() : word;

        (*!------------------------------------------------
         * calculate total record data size
         *-----------------------------------------------
         * @return number of bytes of current record
         *-----------------------------------------------*)
        function getRecordSize() : integer;

        (*!------------------------------------------------
         * write record data to destination stream
         *-----------------------------------------------
         * @param dstStream, stream instance where to write
         * @return number of bytes actually written
         *-----------------------------------------------*)
        function write(const dstStream : IStreamAdapter) : integer;
    end;

implementation

end.
