{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileAdapterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    InjectableObjectImpl,
    UploadedFileIntf,
    httpdefs;

type

    (*!------------------------------------------------
     * adapter class having capability to store so
     * so that we can use fcl-web TUploadedFile
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUploadedFileAdapter = class(TInterfacedObject, IUploadedFile)
    private
        fUploadedFile : httpdefs.TUploadedFile;

        procedure moveTmpFile(srcStream : TStream; const dstFilename : string);
    public

        (*!----------------------------------------
         * constructor
         *-----------------------------------------
         * @param uploadedFile fcl-web uploaded file
         *-----------------------------------------*)
        constructor create(const uploadedFile : httpdefs.TUploadedFile);

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

    SysUtils,
    EInvalidUploadedFileImpl;

resourcestring

    sErrInvalidUploadedFile = 'Invalid uploaded file. You can move uploaded file only once';

    (*!----------------------------------------
     * constructor
     *-----------------------------------------
     * @param uploadedFile fcl-web uploaded file
     *-----------------------------------------*)
    constructor TUploadedFileAdapter.create(const uploadedFile : httpdefs.TUploadedFile);
    begin
        fUploadedFile := uploadedFile;
    end;

    procedure TUploadedFileAdapter.moveTmpFile(srcStream : TStream; const dstFilename : string);
    var dstStream : TStream;
    begin
        dstStream := TFileStream.create(dstFilename, fmCreate);
        try
            dstStream.copyFrom(srcStream, srcStream.size);
        finally
            dstStream.free();
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
    function TUploadedFileAdapter.moveTo(const targetPath : string) : IUploadedFile;
    begin
        if (fileExists(fUploadedFile.LocalFileName)) then
        begin
            moveTmpFile(fUploadedFile.stream, targetPath);
            deleteFile(fUploadedFile.LocalFileName);
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
    function TUploadedFileAdapter.size() : int64;
    begin
        result := fUploadedFile.stream.size;
    end;

    (*!------------------------------------------------
     * get client side filename
     *-------------------------------------------------
     * @return string original filename as uploaded by client
     *------------------------------------------------*)
    function TUploadedFileAdapter.getClientFilename() : string;
    begin
        result := fUploadedFile.filename;
    end;

    (*!------------------------------------------------
     * get client side MIME type
     *-------------------------------------------------
     * @return string original MIME type as uploaded by client
     *------------------------------------------------*)
    function TUploadedFileAdapter.getClientMediaType() : string;
    begin
        result := fUploadedFile.contentType;
    end;

    (*!------------------------------------------------
     * get temporary filepath
     *-------------------------------------------------
     * @return string path of tmp file
     *------------------------------------------------*)
    function TUploadedFileAdapter.getTmpFilename() : string;
    begin
        result := fUploadedFile.LocalFileName;
    end;
end.
