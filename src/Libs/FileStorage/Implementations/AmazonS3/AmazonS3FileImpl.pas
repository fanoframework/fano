{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AmazonS3FileImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    FileIntf,
    aws_s3;

type

    (*!------------------------------------------------
     * class having capability to read, write and
     * get stats of file stored in Amazon S3
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAmazonS3File = class (TInterfacedObject, IFile)
    private
        fS3Service : IS3Service;
        fFilePath : string;
    public
        constructor create(const s3Svc : IS3Service; const filePath : string);

        destructor destroy(); override;

        (*!------------------------------------------------
         * retrieve content of a file as string
         *-----------------------------------------------
         * @param filePath file path to retrieve
         * @return content of file
         *-----------------------------------------------*)
        function get() : string;

        (*!------------------------------------------------
         * write content to file
         *-----------------------------------------------
         * @param content content to write
         *-----------------------------------------------*)
        procedure put(const content : string);

        property content : string read get write put;

        (*!------------------------------------------------
         * retrieve content of a file as string
         *-----------------------------------------------
         * @return content of file
         *-----------------------------------------------*)
        function getStream() : IStreamAdapter;

        (*!------------------------------------------------
         * write content to file
         *-----------------------------------------------
         * @param filePath file path to write
         * @param content content to write
         *-----------------------------------------------*)
        procedure putStream(const content : IStreamAdapter);

        property stream : IStreamAdapter read getStream write putStream;

        (*!------------------------------------------------
         * prepend content at begining of file
         *-----------------------------------------------
         * @param content content to write
         *-----------------------------------------------*)
        procedure prepend(const content : string);

        (*!------------------------------------------------
         * append content at end of file
         *-----------------------------------------------
         * @param content content to write
         *-----------------------------------------------*)
        procedure append(const content : string);

        (*!------------------------------------------------
         * copy file
         *-----------------------------------------------
         * @param dstPath destination file path
         *-----------------------------------------------*)
        procedure copy(const dstPath : string);


        (*!------------------------------------------------
         * get file size
         *-----------------------------------------------
         * @param filePath file path to check
         * @return size of file
         *-----------------------------------------------*)
        function size() : int64;

        (*!------------------------------------------------
         * get file last modified
         *-----------------------------------------------
         * @param filePath file path to check
         * @return last modified as unix timestamp
         *-----------------------------------------------*)
        function lastModified() : longint;
    end;


implementation

uses

    classes,
    sysutils,
    StreamAdapterImpl;

    constructor TAmazonS3File.create(const filePath : string);
    begin
        fFilePath := filePath;
    end;

    destructor TAmazonS3File.destroy();
    begin
        inherited destroy();
    end;

    (*!------------------------------------------------
     * retrieve content of a file as string
     *-----------------------------------------------
     * @param filePath file path to retrieve
     * @return content of file
     *-----------------------------------------------*)
    function TAmazonS3File.get() : string;
    var fStream : TFileStream;
        strStream : TStringStream;
    begin
        fStream := TFileStream.create(fFilePath, fmOpenWrite);
        try
            strStream := TStringStream.create('');
            try
                strStream.CopyFrom(fStream);
                result := strStream.DataString;
            finally
                strStream.free();
            end;
        finally
            fStream.free();
        end;
    end;

    (*!------------------------------------------------
     * write content to file
     *-----------------------------------------------
     * @param content content to write
     *-----------------------------------------------*)
    procedure TAmazonS3File.put(const content : string);
    var fStream : TFileStream;
    begin
        fStream := TFileStream.create(fFilePath, fmCreate);
        try
            fStream.WriteBuffer(content[1], length(content));
        finally
            fStream.free();
        end;
    end;


    (*!------------------------------------------------
     * retrieve content of a file as string
     *-----------------------------------------------
     * @return content of file
     *-----------------------------------------------*)
    function TAmazonS3File.getStream() : IStreamAdapter;
    begin
        result := TStreamAdapter.create(TFileStream.create(fFilePath, fmOpenReadWrite));
    end;

    (*!------------------------------------------------
     * write content to file
     *-----------------------------------------------
     * @param filePath file path to write
     * @param content content to write
     *-----------------------------------------------*)
    procedure TAmazonS3File.putStream(const content : IStreamAdapter);
    var fStream : TFileStream;
        buff : pointer;
        byteRead, totRead : int64;
    begin
        fStream := TFileStream.create(fFilePath, fmCreate);
        try
            getMem(buff, 4096);
            try
                totRead := 0;
                repeat
                    byteRead := content.read(buff^, 4096);
                    fStream.WriteBuffer(buff^, byteRead);
                    totRead := totRead + byteRead;
                until (byteRead < 4096) and (totRead < content.size);
            finally
                freeMem(buff);
            end;
        finally
            fStream.free();
        end;
    end;


    (*!------------------------------------------------
     * prepend content at begining of file
     *-----------------------------------------------
     * @param content content to write
     *-----------------------------------------------*)
    procedure TAmazonS3File.prepend(const content : string);
    var fStream : TFileStream;
    begin
        fStream := TFileStream.create(fFilePath, fmOpenReadWrite);
        try
            fStream.Seek(0, soFromBeginning);
            fStream.WriteBuffer(content[1], length(content));
        finally
            fStream.free();
        end;
    end;

    (*!------------------------------------------------
     * append content at end of file
     *-----------------------------------------------
     * @param content content to write
     *-----------------------------------------------*)
    procedure TAmazonS3File.append(const content : string);
    var fStream : TFileStream;
    begin
        fStream := TFileStream.create(fFilePath, fmOpenReadWrite);
        try
            fStream.Seek(0, soEnd);
            fStream.WriteBuffer(content[1], length(content));
        finally
            fStream.free();
        end;
    end;

    (*!------------------------------------------------
     * copy file
     *-----------------------------------------------
     * @param dstPath destination file path
     *-----------------------------------------------*)
    procedure TAmazonS3File.copy(const dstPath : string);
    var fStream : TFileStream;
    begin
        fStream := TFileStream.create(fFilePath, fmOpenReadWrite);
        try
            fStream.Seek(0, soEnd);
            fStream.WriteBuffer(content[1], length(content));
        finally
            fStream.free();
        end;
    end;


    (*!------------------------------------------------
     * get file size
     *-----------------------------------------------
     * @param filePath file path to check
     * @return size of file
     *-----------------------------------------------*)
    function TAmazonS3File.size() : int64;
    var fStream : TFileStream;
    begin
        fStream := TFileStream.create(fFilePath, fmOpenRead);
        try
            result := fStream.Size;
        finally
            fStream.free();
        end;
    end;

    (*!------------------------------------------------
     * get file last modified
     *-----------------------------------------------
     * @param filePath file path to check
     * @return size of file
     *-----------------------------------------------*)
    function TAmazonS3File.lastModified() : longint;
    begin
        result := FileAge(fFilePath);
    end;

end.
