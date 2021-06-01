{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BasicFileReaderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    FileReaderIntf;

type

    (*!------------------------------------------------
     * basic class having capability to read
     * file content to string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TBasicFileReader = class(TInjectableObject, IFileReader)
    public

        (*!------------------------------------------------
         * read file content to string
         *-----------------------------------------------
         * @param filePath path of file to be read
         * @return file content
         *-----------------------------------------------*)
        function readFile(const filePath : string) : string;
    end;

implementation

uses

    Classes,
    SysUtils,
    SerializeableIntf,
    SerializeableStreamImpl;

    (*!------------------------------------------------
     * read file content to string
     *-----------------------------------------------
     * @param filePath path of file to be read
     * @return file content
     *-----------------------------------------------*)
    function TBasicFileReader.readFile(const filePath : string) : string;
    var serializeStream : ISerializeable;
    begin
        serializeStream := TSerializeableStream.create(
            //open for read and share but deny write
            //so if multiple processes of our application access same file
            //at the same time they stil can open and read it
            TFileStream.create(
                filePath,
                fmOpenRead or fmShareDenyWrite
            )
        );
        try
            result := serializeStream.serialize();
        finally
            serializeStream := nil;
        end;
    end;

end.
