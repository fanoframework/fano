{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileCollectionAdapterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    httpdefs,
    UploadedFileIntf,
    UploadedFileCollectionIntf;

type

    (*!------------------------------------------------
     * adapter class to be able to work with fcl-web
     * TUploadedFiles
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUploadedFileCollectionAdapter = class(TInterfacedObject, IUploadedFileCollection)
    private
        fUploadedFiles : httpdefs.TUploadedFiles;
    public
        constructor create(const uploadedFiles : httpdefs.TUploadedFiles);

        (*!------------------------------------------------
         * get total uploaded file in collection
         *-------------------------------------------------
         * @return number of item in collection
         *------------------------------------------------*)
        function count() : integer;

        (*!------------------------------------------------
         * test if there is uploaded file specified by name
         *-------------------------------------------------
         * @return true if specified
         *------------------------------------------------*)
        function has(const key : shortstring) : boolean;

        (*!------------------------------------------------
         * get IUploadedFile instance by name
         *-------------------------------------------------
         * @return IUploadedFile instance
         *------------------------------------------------*)
        function getUploadedFile(const key : shortstring) : IUploadedFileArray;

        (*!------------------------------------------------
         * get IUploadedFile instance by index
         *-------------------------------------------------
         * @return IUploadedFile instance
         *------------------------------------------------*)
        function getUploadedFile(const indx : integer) : IUploadedFileArray;

    end;

implementation

uses

    UploadedFileAdapterImpl;

    constructor TUploadedFileCollectionAdapter.create(
        const uploadedFiles : httpdefs.TUploadedFiles
    );
    begin
        fUploadedFiles := uploadedFiles;
    end;

    (*!------------------------------------------------
     * get total uploaded file in collection
     *-------------------------------------------------
     * @return number of item in collection
     *------------------------------------------------*)
    function TUploadedFileCollectionAdapter.count() : integer;
    begin
        result := fUploadedFiles.count;
    end;

    (*!------------------------------------------------
     * test if there is uploaded file specified by name
     *-------------------------------------------------
     * @return true if specified
     *------------------------------------------------*)
    function TUploadedFileCollectionAdapter.has(const key : shortstring) : boolean;
    begin
        result := fUploadedFiles.indexOfFile(key) > -1;
    end;

    (*!------------------------------------------------
     * get IUploadedFile instance by name
     *-------------------------------------------------
     * @return IUploadedFile instance
     *------------------------------------------------*)
    function TUploadedFileCollectionAdapter.getUploadedFile(const key : shortstring) : IUploadedFileArray;
    var uploadedFile : httpdefs.TUploadedFile;
    begin
        result := nil;
        setLength(result, 1);
        uploadedFile := fUploadedFiles.fileByName(key);
        result[0] := TUploadedFileAdapter.create(uploadedFile);
    end;

    (*!------------------------------------------------
     * get IUploadedFile instance by index
     *-------------------------------------------------
     * @return IUploadedFile instance
     *------------------------------------------------*)
    function TUploadedFileCollectionAdapter.getUploadedFile(const indx : integer) : IUploadedFileArray;
    var uploadedFile : httpdefs.TUploadedFile;
    begin
        result := nil;
        setLength(result, 1);
        uploadedFile := fUploadedFiles.files[indx];
        result[0] := TUploadedFileAdapter.create(uploadedFile);
    end;

end.
