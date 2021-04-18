{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiBaseParserImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    FcgiRecordIntf,
    FcgiRecordFactoryIntf,
    FcgiFrameParserIntf,
    StreamAdapterIntf,
    MemoryAllocatorIntf,
    MemoryDeallocatorIntf;

type

    (*!-----------------------------------------------
     * FastCGI Base Parser
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiBaseParser = class (TInjectableObject, IFcgiFrameParser, IMemoryAllocator, IMemoryDeallocator)
    protected
        fRecordFactories : TFcgiRecordFactoryArray;
        fMemAlloc : IMemoryAllocator;
        fMemDealloc : IMemoryDeallocator;

        procedure raiseExceptionIfBufferNil(const buffer : pointer);
        procedure raiseExceptionIfInvalidBufferSize(const bufferSize : int64);
        procedure raiseExceptionIfInvalidBuffer(const buffer : pointer;  const bufferSize : int64);

        function isValidRecordType(const reqType : byte) : boolean;
        procedure raiseExceptionIfInvalidRecordType(const reqType : byte);

    public
        constructor create(
            const factories : TFcgiRecordFactoryArray;
            const memAlloc : IMemoryAllocator;
            const memDealloc : IMemoryDeallocator
        );
        destructor destroy(); override;

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
        ) : boolean; virtual; abstract;

        (*!------------------------------------------------
        * test if buffer contain FastCGI frame package
        * i.e FastCGI header + payload
        *-----------------------------------------------
        * @param buffer, pointer to current buffer
        * @return true if buffer contain valid frame
        *-----------------------------------------------*)
        function hasFrame(const buffer : pointer; const bufferSize : ptrUint) : boolean;

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
        function parseFrame(const buffer : pointer; const bufferSize : ptrUint) : IFcgiRecord;

        (*!------------------------------------------------
         * allocate memory
         *-----------------------------------------------
         * @param requestedSize, number of bytes to allocate
         * @return pointer of allocated memory
         *-----------------------------------------------*)
        function allocate(const requestedSize : PtrUint) : pointer;

        (*!------------------------------------------------
         * deallocate memory
         *-----------------------------------------------
         * @param ptr, pointer of memory to be allocated
         * @param requestedSize, number of bytes to deallocate
         *-----------------------------------------------*)
        procedure deallocate(const ptr : pointer; const requestedSize : PtrUint);
    end;

implementation

uses

    fastcgi,
    EInvalidFcgiBufferImpl,
    EInvalidFcgiRecordTypeImpl,
    EInvalidFcgiHeaderLenImpl;

    constructor TFcgiBaseParser.create(
        const factories : TFcgiRecordFactoryArray;
        const memAlloc : IMemoryAllocator;
        const memDealloc : IMemoryDeallocator
    );
    begin
        inherited create();
        fRecordFactories := factories;
        fMemAlloc := memAlloc;
        fMemDealloc := memDealloc;
    end;

    destructor TFcgiBaseParser.destroy();
    var i : integer;
    begin
        inherited destroy();
        for i:= length(fRecordFactories) -1 downto 0 do
        begin
            fRecordFactories[i] := nil;
        end;
        setLength(fRecordFactories, 0);
        fRecordFactories := nil;
        fMemAlloc := nil;
        fMemDealloc := nil;
    end;

    procedure TFcgiBaseParser.raiseExceptionIfBufferNil(const buffer : pointer);
    begin
        if (buffer = nil) then
        begin
            raise EInvalidFcgiBuffer.create('FastCGI buffer nil');
        end;
    end;

    procedure TFcgiBaseParser.raiseExceptionIfInvalidBufferSize(const bufferSize : int64);
    begin
        if (bufferSize < FCGI_HEADER_LEN) then
        begin
            raise EInvalidFcgiHeaderLen.create('Not enough data in the buffer to parse');
        end;
    end;

    procedure TFcgiBaseParser.raiseExceptionIfInvalidBuffer(const buffer : pointer;  const bufferSize : int64);
    begin
        raiseExceptionIfBufferNil(buffer);
        raiseExceptionIfInvalidBufferSize(bufferSize);
    end;

    (*!------------------------------------------------
     * test if buffer contain FastCGI frame package
     * i.e FastCGI header + payload
     *-----------------------------------------------
     * @param buffer, pointer to current buffer
     * @param bufferSize, size of buffer
     * @return true if buffer contain valid frame
     *-----------------------------------------------*)
    function TFcgiBaseParser.hasFrame(const buffer : pointer; const bufferSize : ptrUint) : boolean;
    var header : PFCGI_Header;
        contentLength :word;
    begin
        raiseExceptionIfBufferNil(buffer);
        header := buffer;
        //header^.contentlength is big endian, convert it to native endian
        contentLength := BEtoN(header^.contentLength);
        result := (bufferSize >= (FCGI_HEADER_LEN + contentLength + header^.paddingLength));
    end;

    function TFcgiBaseParser.isValidRecordType(const reqType : byte) : boolean;
    begin
        result := (reqType = FCGI_BEGIN_REQUEST) or
                  (reqType = FCGI_ABORT_REQUEST) or
                  (reqType = FCGI_END_REQUEST) or
                  (reqType = FCGI_PARAMS) or
                  (reqType = FCGI_STDIN) or
                  (reqType = FCGI_STDOUT) or
                  (reqType = FCGI_STDERR) or
                  (reqType = FCGI_DATA) or
                  (reqType = FCGI_GET_VALUES) or
                  (reqType = FCGI_GET_VALUES_RESULT) or
                  (reqType = FCGI_UNKNOWN_TYPE);
    end;

    procedure TFcgiBaseParser.raiseExceptionIfInvalidRecordType(const reqType : byte);
    begin
        if (not isValidRecordType(reqType)) then
        begin
            raise EInvalidFcgiRecordType.createFmt('Invalid FCGI record type %d received', [reqType]);
        end;
    end;

    (*!------------------------------------------------
     * parse current buffer and create its corresponding
     * FastCGI record instance
     *-----------------------------------------------
     * @param buffer, pointer to current buffer
     * @param bufferSize, size of buffer
     * @return IFcgiRecord instance
     * @throws EInvalidFcgiHeaderLen exception when header size not valid
     *-----------------------------------------------*)
    function TFcgiBaseParser.parseFrame(const buffer : pointer; const bufferSize : ptrUint) : IFcgiRecord;
    var header : PFCGI_Header;
        factory : IFcgiRecordFactory;
    begin
        raiseExceptionIfInvalidBuffer(buffer, bufferSize);
        header := buffer;
        raiseExceptionIfInvalidRecordType(header^.reqtype);
        factory := fRecordFactories[header^.reqtype];
        factory.setDeallocator(self);
        try
            result := factory.setBuffer(buffer, bufferSize).build();
        finally
            //remove reference to ourself, so reference count properly incr/decr
            //to avoid memory leak
            factory.setDeallocator(nil);
            factory := nil;
        end;
    end;

    (*!------------------------------------------------
     * allocate memory
     *-----------------------------------------------
     * @param requestedSize, number of bytes to allocate
     * @return pointer of allocated memory
     *-----------------------------------------------*)
    function TFcgiBaseParser.allocate(const requestedSize : PtrUint) : pointer;
    begin
        result := fMemAlloc.allocate(requestedSize);
    end;

    (*!------------------------------------------------
     * deallocate memory
     *-----------------------------------------------
     * @param ptr, pointer of memory to be allocated
     * @param requestedSize, number of bytes to deallocate
     *-----------------------------------------------*)
    procedure TFcgiBaseParser.deallocate(const ptr : pointer; const requestedSize : PtrUint);
    begin
        fMemDealloc.deallocate(ptr, requestedSize);
    end;
end.
