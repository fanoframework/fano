{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MappedMemoryStreamImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    classes,
    MemoryDeallocatorIntf;

type

    (*!------------------------------------------------
     * memory stream that use existing buffer as
     * underlying memory buffer. This stream is fixed in
     * size and will not reallocate memory
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMappedMemoryStream = class(TCustomMemoryStream)
    private
        fDeallocator : IMemoryDeallocator;
    public

        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param ptr, memory buffer to be used
         * @param aSize, memory buffer size
         * @param deallocator, memory deallocator
         *-------------------------------------
         * Memory deallocator can be passed to allow
         * this class to own memory buffer.
         * if no deallocation needed (e.g, buffer is owned by something else)
         * just pass null deallocator implementation such
         * TNullMemoryDeallocator
         *-------------------------------------*)
        constructor create(ptr: pointer; aSize: ptrInt; const deallocator : IMemoryDeallocator);

        (*!------------------------------------
         * destructor
         *-------------------------------------*)
        destructor destroy(); override;

        {$IFDEF CPU64}
        procedure setSize(const newSize: int64); override;
        {$ELSE}
        procedure setSize(newSize: Longint); override;
        {$ENDIF}
    end;

implementation

resourcestring

    strOperationNotSupported = 'Operation not supported';

    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param ptr, memory buffer to be used
     * @param aSize, memory buffer size
     * @param deallocator, memory deallocator
     *-------------------------------------
     * Memory deallocator can be passed to allow
     * this class to own memory buffer.
     * if no deallocation needed (e.g, buffer is owned by something else)
     * just pass null deallocator implementation such
     * TNullMemoryDeallocator
     *-------------------------------------*)
    constructor TMappedMemoryStream.create(ptr: pointer; aSize: ptrInt; const deallocator : IMemoryDeallocator);
    begin
        inherited create();
        fDeallocator := deallocator;
        setPointer(ptr, aSize);
    end;

    destructor TMappedMemoryStream.destroy();
    begin
        inherited destroy();
        fDeallocator.deallocate(memory, size);
    end;

    {$IFDEF CPU64}
    procedure TMappedMemoryStream.setSize(const newSize: int64);
    begin
        raise EStreamError.create(strOperationNotSupported);
    end;
    {$ELSE}
    procedure TMappedMemoryStream.setSize(newSize: longint);
    begin
        raise EStreamError.create(strOperationNotSupported);
    end;
    {$ENDIF}
end.
