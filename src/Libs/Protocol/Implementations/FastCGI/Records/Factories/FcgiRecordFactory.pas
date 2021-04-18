{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiRecordFactory;

interface

{$MODE OBJFPC}
{$H+}

uses

    FcgiRecordIntf,
    FcgiRecordFactoryIntf,
    MemoryDeallocatorIntf,
    StreamAdapterIntf;

type

    (*!-----------------------------------------------
     * Base fastcgi record factory
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiRecordFactory = class(TInterfacedObject, IFcgiRecordFactory)
    protected
        fBuffer : pointer;
        fBufferSize : ptrUint;
        fRequestId : word;
        fDeallocator : IMemoryDeallocator;

        function initEmptyStream() : IStreamAdapter;
        function initStreamFromBuffer(const buffer : pointer; const size : ptrUint) : IStreamAdapter;
    public
        constructor create();
        destructor destroy(); override;

        function setDeallocator(const deallocator : IMemoryDeallocator) : IFcgiRecordFactory;
        function setBuffer(const buffer : pointer; const size : ptrUint) : IFcgiRecordFactory;

        (*!------------------------------------------------
         * build fastcgi record from stream
         *-----------------------------------------------
         * @param stream, stream instance where to write
         * @return number of bytes actually written
         *-----------------------------------------------*)
        function build() : IFcgiRecord; virtual; abstract;

        (*!------------------------------------------------
         * set request id
         *-----------------------------------------------
         * @return request id
         *-----------------------------------------------*)
        function setRequestId(const reqId : word) : IFcgiRecordFactory;
    end;

implementation

uses

    classes,
    StreamAdapterImpl,
    MappedMemoryStreamImpl;

    constructor TFcgiRecordFactory.create();
    begin
        inherited create();
        setBuffer(nil, 0);
        fDeallocator := nil;
    end;

    destructor TFcgiRecordFactory.destroy();
    begin
        inherited destroy();
        //add check to make sure we working with initialized instance
        if (assigned(fDeallocator)) then
        begin
            fDeallocator.deallocate(fBuffer, fBufferSize);
        end;

        //remove call to setBuffer(nil, 0) because it somehow cause stack overflow,
        //when we create record factory but does nothing
        fBuffer := nil;
        fBufferSize := 0;
    end;

    function TFcgiRecordFactory.setDeallocator(const deallocator : IMemoryDeallocator) : IFcgiRecordFactory;
    begin
        fDeallocator := deallocator;
        result := self;
    end;

    function TFcgiRecordFactory.setBuffer(const buffer : pointer; const size : ptrUint) : IFcgiRecordFactory;
    begin
        fBuffer := buffer;
        fBufferSize := size;
        result := self;
    end;

    function TFcgiRecordFactory.initEmptyStream() : IStreamAdapter;
    begin
        result := TStreamAdapter.create(TMemoryStream.create());
    end;

    function TFcgiRecordFactory.initStreamFromBuffer(const buffer : pointer; const size : ptrUint) : IStreamAdapter;
    begin
        result := TStreamAdapter.create(TMappedMemoryStream.create(buffer, size, fDeallocator));
    end;

    (*!------------------------------------------------
     * set request id
     *-----------------------------------------------
     * @return request id
     *-----------------------------------------------*)
    function TFcgiRecordFactory.setRequestId(const reqId : word) : IFcgiRecordFactory;
    begin
        fRequestId := reqId;
        result := self;
    end;
end.
