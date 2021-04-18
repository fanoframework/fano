{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StringFileReaderImpl;

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
    TStringFileReader = class(TInjectableObject, IFileReader)
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
    SysUtils;

    (*!------------------------------------------------
     * read file content to string
     *-----------------------------------------------
     * @param filePath path of file to be read
     * @return file content
     *-----------------------------------------------*)
    function TStringFileReader.readFile(const filePath : string) : string;
    var fstream : TFileStream;
        len : int64;
    begin
        //open for read and share but deny write
        //so if multiple processes of our application access same file
        //at the same time they stil can open and read it
        fstream := TFileStream.create(filePath, fmOpenRead or fmShareDenyWrite);
        try
            len := fstream.size;
            setLength(result, len);
            //pascal string start from index 1
            fstream.read(result[1], len);
        finally
            fstream.free();
        end;
    end;

end.
