{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiRecordFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    FcgiRecordIntf,
    MemoryDeallocatorIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to create
     * FastCGI record
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IFcgiRecordFactory = interface
        ['{5B1B7CED-8804-4837-B0DE-D88C02BE66A2}']

        function setDeallocator(const deallocator : IMemoryDeallocator) : IFcgiRecordFactory;
        function setBuffer(const buffer : pointer; const size : ptrUint) : IFcgiRecordFactory;

        (*!------------------------------------------------
         * build fastcgi record instance
         *-----------------------------------------------*)
        function build() : IFcgiRecord;

        (*!------------------------------------------------
         * set request id
         *-----------------------------------------------
         * @return request id
         *-----------------------------------------------*)
        function setRequestId(const reqId : word) : IFcgiRecordFactory;
    end;

    TFcgiRecordFactoryArray = array of IFcgiRecordFactory;

implementation

end.
