{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    UploadedFileIntf;

type

    (*!------------------------------------------------
     * basic class having capability to store
     * HTTP file upload
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUploadedFile = class(TInterfacedObject, IUploadedFile)
    private

        (*!----------------------------------------
         * temporary file path
         *-----------------------------------------*)
        tmpFile : string;

        (*!----------------------------------------
         * original filename as uploaded by user
         *-----------------------------------------*)
        clientFilename : string;

        (*!----------------------------------------
         * file size
         *-----------------------------------------*)
        tmpFileSize : int64;

        (*!----------------------------------------
         * MIME type as uploaded by user
         *-----------------------------------------*)
        tmpMimeType : string;

    public

        (*!----------------------------------------
         * constructor
         *-----------------------------------------
         * @param content content of uploaded file
         * @param contentType content type of uploaded file
         * @param origFilename original filename as uploaded by user
         *-----------------------------------------
         * We will create temporary file to hold uploaded
         * file content.
         *-----------------------------------------*)
        constructor create(
            const content : string;
            const contentType : string;
            const origFilename : string
        );

        (*!----------------------------------------
         * destructor
         *-----------------------------------------
         * we will delete any unmoved uploaded files
         *-----------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * move uploaded file to specified
         *-------------------------------------------------
         * @param string target path
         * @return current instance
         * @throws EInvalidOperation
         *------------------------------------------------
         * Implementor must raise exception when moveTo()
         * called multiple time
         * Implementor must check for file permission
         *------------------------------------------------*)
        function moveTo(const targetPath : string) : IUploadedFile;

        (*!------------------------------------------------
         * get uploaded file size
         *-------------------------------------------------
         * @return size in bytes of uploaded file
         *------------------------------------------------*)
        function size() : int64;

        (*!------------------------------------------------
         * get client side filename
         *-------------------------------------------------
         * @return string original filename as uploaded by client
         *------------------------------------------------*)
        function getClientFilename() : string;

        (*!------------------------------------------------
         * get client side MIME type
         *-------------------------------------------------
         * @return string original MIME type as uploaded by client
         *------------------------------------------------*)
        function getClientMediaType() : string;

        (*!------------------------------------------------
         * get temporary filepath
         *-------------------------------------------------
         * @return string path of tmp file
         *------------------------------------------------*)
        function getTmpFilename() : string;
    end;

implementation

uses

    Classes,
    SysUtils,
    EInvalidUploadedFileImpl;

resourcestring

    sErrDuplicateTemporaryUploadedFile = 'Duplicate temporary uploaded file %s';
    sErrInvalidUploadedFile = 'Invalid uploaded file. You can move uploaded file only once';

    function makeRandomStr(const prefix : string; const suffix : string) : string;
    var id : TGUID;
    begin
        createGUID(id);
        //convert GUID to string and remove { and } part and add prefix suffix
        result := prefix + copy(GUIDToString(id), 2, 36) + suffix;
    end;

    (*!----------------------------------------
     * Create temporary file
     *-----------------------------------------
     * @param content content of file
     * @param prefix string prepended before random string
     * @param suffix string appended after random string
     * @return filename of file
     *-----------------------------------------*)
    function createTmpFile(
        const content : string;
        const prefix : string;
        const suffix : string
    ) : string;
    var fstream : TFileStream;
    begin
        result := getTempDir() + makeRandomStr(prefix, suffix);
        if (fileExists(result)) then
        begin
            //this is just pre caution, try to recreate name
            result := getTempDir() + makeRandomStr(prefix, suffix);
            if (fileExists(result)) then
            begin
                //give up
                raise EInvalidUploadedFile.createFmt(
                    sErrDuplicateTemporaryUploadedFile,
                    [ result ]
                );
            end;
        end;

        fstream := TFileStream.create(result, fmCreate);
        try
            fstream.write(content[1], length(content));
        finally
            freeAndNil(fstream);
        end;
    end;

    (*!----------------------------------------
     * move temporary file
     *-----------------------------------------
     * @param srcFilename source filename
     * @param dstFilename destination filename
     *-----------------------------------------*)
    procedure moveTmpFile(const srcFilename : string; const dstFilename : string);
    var srcStream, dstStream : TFileStream;
    begin
        srcStream := TFileStream.create(srcFilename, fmOpenRead);
        try
            dstStream := TFileStream.create(dstFilename, fmCreate);
            try
                dstStream.copyFrom(srcStream, srcStream.size);
            finally
                dstStream.free();
            end;
        finally
            srcStream.free();
        end;
    end;

    (*!----------------------------------------
     * constructor
     *-----------------------------------------
     * @param content content of uploaded file
     * @param contentType content type of uploaded file
     * @param origFilename original filename as uploaded by user
     *-----------------------------------------
     * We will create temporary file to hold uploaded
     * file content.
     *-----------------------------------------*)
    constructor TUploadedFile.create(
        const content : string;
        const contentType : string;
        const origFilename : string
    );
    begin
        tmpFile := createTmpFile(content, 'fano-', origFilename);
        tmpFileSize := length(tmpFile);
        tmpMimeType := contentType;
        clientFilename := origFilename;
    end;

    (*!----------------------------------------
     * destructor
     *-----------------------------------------
     * we will delete any unmoved uploaded files
     *-----------------------------------------*)
    destructor TUploadedFile.destroy();
    begin
        if (fileExists(tmpFile)) then
        begin
            deleteFile(tmpFile);
        end;
    end;

    (*!------------------------------------------------
     * move uploaded file to specified
     *-------------------------------------------------
     * @param string target path
     * @return current instance
     * @throws EInvalidOperation
     *------------------------------------------------
     * Implementor must raise exception when moveTo()
     * called multiple time
     * Implementor must check for file permission
     *------------------------------------------------*)
    function TUploadedFile.moveTo(const targetPath : string) : IUploadedFile;
    begin
        if (fileExists(tmpFile)) then
        begin
            moveTmpFile(tmpFile, targetPath);
            deleteFile(tmpFile);
        end else
        begin
            raise EInvalidUploadedFile.create(sErrInvalidUploadedFile);
        end;
        result := self;
    end;

    (*!------------------------------------------------
     * get uploaded file size
     *-------------------------------------------------
     * @return size in bytes of uploaded file
     *------------------------------------------------*)
    function TUploadedFile.size() : int64;
    begin
        result := tmpFileSize;
    end;

    (*!------------------------------------------------
     * get client side filename
     *-------------------------------------------------
     * @return string original filename as uploaded by client
     *------------------------------------------------*)
    function TUploadedFile.getClientFilename() : string;
    begin
        result := clientFilename;
    end;

    (*!------------------------------------------------
     * get client side MIME type
     *-------------------------------------------------
     * @return string original MIME type as uploaded by client
     *------------------------------------------------*)
    function TUploadedFile.getClientMediaType() : string;
    begin
        result := tmpMimeType;
    end;

    (*!------------------------------------------------
     * get temporary filepath
     *-------------------------------------------------
     * @return string path of tmp file
     *------------------------------------------------*)
    function TUploadedFile.getTmpFilename() : string;
    begin
        result := tmpFile;
    end;
end.
