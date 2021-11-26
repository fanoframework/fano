{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullMemoryDeallocatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    MemoryDeallocatorIntf;

type

    (*!------------------------------------------------
     * class that implements dummy memory deallocation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullMemoryDeallocator = class(TInterfacedObject, IMemoryDeallocator)
    public
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
     * dummy deallocate memory
     *-----------------------------------------------
     * @param ptr, pointer of memory to be allocated
     * @param requestedSize, number of bytes to deallocate
     *-----------------------------------------------*)
    procedure TNullMemoryDeallocator.deallocate(const ptr : pointer; const requestedSize : PtrUint);
    begin
        //intentionally does nothing
    end;

end.
