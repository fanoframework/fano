{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MemAllocatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    MemoryAllocatorIntf,
    MemoryDeallocatorIntf;

type

    (*!-----------------------------------------------
     * Memory allocator deallocator
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMemAllocator = class (TInjectableObject, IMemoryAllocator, IMemoryDeallocator)
    public
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

    (*!------------------------------------------------
     * allocate memory
     *-----------------------------------------------
     * @param requestedSize, number of bytes to allocate
     * @return pointer of allocated memory
     *-----------------------------------------------*)
    function TMemAllocator.allocate(const requestedSize : PtrUint) : pointer;
    begin
        result := getMem(requestedSize);
    end;

    (*!------------------------------------------------
     * deallocate memory
     *-----------------------------------------------
     * @param ptr, pointer of memory to be allocated
     * @param requestedSize, number of bytes to deallocate
     *-----------------------------------------------*)
    procedure TMemAllocator.deallocate(const ptr : pointer; const requestedSize : PtrUint);
    begin
        freeMem(ptr, requestedSize);
    end;
end.
