{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ResponseStreamImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    DependencyIntf,
    ResponseStreamIntf,
    StreamAdapterImpl;

type

    (*!----------------------------------------------
     * adapter class having capability as
     * HTTP response body
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TResponseStream = class(TStreamAdapter, IResponseStream, IDependency)
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
    function TResponseStream.write(const buffer : string) : int64;
    begin
        result := 0;
        if buffer <> '' then
        begin
            result := self.write(buffer[1], length(buffer));
        end;
    end;

    (*!------------------------------------
     * read stream to string
     *-------------------------------------
     * @return string
     *-------------------------------------*)
    function TResponseStream.read() : string;
    begin
        self.seek(0);
        setLength(result, self.size());
        if (self.size() > 0) then
        begin
            self.read(result[1], length(result));
        end;
    end;

end.
