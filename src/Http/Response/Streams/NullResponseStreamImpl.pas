{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullResponseStreamImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    ResponseStreamIntf,
    NullStreamAdapterImpl;

type

    (*!----------------------------------------------
     * dummy adapter class having capability as
     * HTTP response body
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullResponseStream = class(TNullStreamAdapter, IResponseStream, IDependency)
    public
        (*!------------------------------------
         * write string to stream
         *-------------------------------------
         * @param buffer string to write
         * @return number of bytes actually written
         *-------------------------------------*)
        function write(const buffer : string) : int64; overload;

        (*!------------------------------------
         * read stream to string
         *-------------------------------------
         * @return string
         *-------------------------------------*)
        function read() : string; overload;
    end;

implementation

    (*!------------------------------------
     * write string to stream
     *-------------------------------------
     * @param buffer string to write
     * @return number of bytes actually written
     *-------------------------------------*)
    function TNullResponseStream.write(const buffer : string) : int64;
    begin
        //intentionally does nothing
        result := 0;
    end;

    (*!------------------------------------
     * read stream to string
     *-------------------------------------
     * @return string
     *-------------------------------------*)
    function TNullResponseStream.read() : string;
    begin
        result := '';
    end;

end.
