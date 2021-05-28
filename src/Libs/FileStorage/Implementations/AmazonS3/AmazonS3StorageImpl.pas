{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AmazonS3StorageImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    FileIntf,
    DirectoryIntf,
    StorageIntf,
    InjectableObjectImpl,
    aws_s3;

type

    (*!------------------------------------------------
     * class having capability to manage Amazon S3
     * storage
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAmazonS3Storage = class (TInjectableObject, IStorage)
    private
        fS3Service : IS3Service;

    public
        constructor create(const accessKey : string; const secretKey : string);

        destructor destroy(); override;

        (*!------------------------------------------------
         * test if file or directory exists
         *-----------------------------------------------
         * @param path file path to check
         * @return true if file exists in filePath
         *-----------------------------------------------*)
        function exists(const path : string) : boolean;

        (*!------------------------------------------------
         * get file
         *-----------------------------------------------
         * @param filePath file path to retrieve
         * @return instance of file
         *-----------------------------------------------*)
        function getFile(const path : string) : IFile;

        (*!------------------------------------------------
         * test if path is file
         *-----------------------------------------------
         * @param path file path to retrieve
         * @return boolean
         *-----------------------------------------------*)
        function isFile(const path : string) : boolean;

        (*!------------------------------------------------
         * get directory
         *-----------------------------------------------
         * @param path path to retrieve
         * @return instance of directory
         *-----------------------------------------------*)
        function getDir(const path : string) : IDirectory;

        (*!------------------------------------------------
         * test if path is directory
         *-----------------------------------------------
         * @param path directory path to retrieve
         * @return boolean
         *-----------------------------------------------*)
        function isDir(const path : string) : boolean;

        (*!------------------------------------------------
         * move file or directory
         *-----------------------------------------------
         * @param srcPath source path
         * @param dstPath destination path
         *-----------------------------------------------*)
        procedure move(const srcPath : string; const dstPath : string);

        (*!------------------------------------------------
         * delete file or directory
         *-----------------------------------------------
         * @param path file path
         *-----------------------------------------------*)
        procedure delete(const path : string);
    end;

implementation

uses

    sysutils,
    aws_client,
    aws_credentials,
    AmazonS3FileImpl,
    AmazonS3DirectoryImpl;

    constructor TAmazonS3Storage.create(
        const accessKey : string;
        const secretKey : string
    );
    const USE_SSL = true;
    begin
        FS3Service := TS3Service.Create(
            TAWSClient.Create(
                TAWSSignatureVersion1.New(
                    TAWSCredentials.New(
                        accessKey,
                        secretKey,
                        USE_SSL
                    )
                )
            )
        );
    end;

    destructor TAmazonS3Storage.destroy();
    begin
        fS3Service := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * test if file or directory exists
     *-----------------------------------------------
     * @param path file path to check
     * @return true if file exists in filePath
     *-----------------------------------------------*)
    function TAmazonS3Storage.exists(const path : string) : boolean;
    begin
        result := fS3Service.Buckets.Check(path);
    end;

    (*!------------------------------------------------
     * get file
     *-----------------------------------------------
     * @param filePath file path to retrieve
     * @return instance of file
     *-----------------------------------------------*)
    function TAmazonS3Storage.getFile(const path : string) : IFile;
    begin
        result := TAmazonS3File.create(fS3Service, path);
    end;

    (*!------------------------------------------------
     * test if path is file
     *-----------------------------------------------
     * @param path file path to retrieve
     * @return boolean
     *-----------------------------------------------*)
    function TAmazonS3Storage.isFile(const path : string) : boolean;
    begin
        result := fS3Service.Buckets.Check(path);
    end;

    (*!------------------------------------------------
     * get directory
     *-----------------------------------------------
     * @param path path to retrieve
     * @return instance of directory
     *-----------------------------------------------*)
    function TAmazonS3Storage.getDir(const path : string) : IDirectory;
    begin
        result := TAmazonS3Directory.create(path);
    end;

    (*!------------------------------------------------
     * test if path is directory
     *-----------------------------------------------
     * @param path directory path to retrieve
     * @return boolean
     *-----------------------------------------------*)
    function TAmazonS3Storage.isDir(const path : string) : boolean;
    begin
        result := fS3Service.Buckets.Check(path);
    end;

    (*!------------------------------------------------
     * move file or directory
     *-----------------------------------------------
     * @param srcPath source path
     * @param dstPath destination path
     *-----------------------------------------------*)
    procedure TAmazonS3Storage.move(const srcPath : string; const dstPath : string);
    begin
        if FileExists(srcPath) then
        begin
            //move local file to Amazon S3
        end;

        if FileExists(dstPath) then
        begin
            //move Amazon S3 to local
        end;
    end;

    (*!------------------------------------------------
     * delete file or directory
     *-----------------------------------------------*)
    procedure TAmazonS3Storage.delete(const path : string);
    begin
        if isDir(path) then
        begin
            fS3Service.Buckets.Delete(ExtractFilePath(path));
        end else
        begin
            fS3Service.Buckets.Delete(ExtractFilePath(path), ExtractFilename(path));
        end;
    end;
end.