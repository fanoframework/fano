{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MemoryAllocatorIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to allocate
     * memory
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IMemoryAllocator = interface
        ['{492D5075-4DB4-462C-AF36-6C9C2ABF9073}']

        (*!------------------------------------------------
         * allocate memory
         *-----------------------------------------------
         * @param requestedSize, number of bytes to allocate
         * @return pointer of allocated memory
         *-----------------------------------------------*)
        function allocate(const requestedSize : PtrUint) : pointer;
    end;

implementation

end.
