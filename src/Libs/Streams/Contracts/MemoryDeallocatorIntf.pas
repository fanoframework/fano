{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MemoryDeallocatorIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to deallocate
     * memory
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IMemoryDeallocator = interface
        ['{663E73B5-C114-4941-B919-49872DBF6583}']

        (*!------------------------------------------------
         * deallocate memory
         *-----------------------------------------------
         * @param ptr, pointer of memory to be allocated
         * @param requestedSize, number of bytes to deallocate
         *-----------------------------------------------*)
        procedure deallocate(const ptr : pointer; const requestedSize : PtrUint);
    end;

implementation

end.
