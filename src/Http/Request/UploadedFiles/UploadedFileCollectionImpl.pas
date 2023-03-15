{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileCollectionImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    UploadedFileIntf,
    UploadedFileCollectionIntf,
    UploadedFileCollectionWriterIntf,
    UploadedFileFactoryIntf,
    ListIntf;

type

    (*!------------------------------------------------
     * basic class having capability as
     * contain array of IUploadedFile instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUploadedFileCollection = class(TInterfacedObject, IUploadedFileCollection, IUploadedFileCollectionWriter)
    private
        uploadedFiles : IList;
        uploadedFileFactory : IUploadedFileFactory;

        procedure clearUploadedFiles(const listInst : IList);
    public

        constructor create(
            const listInst : IList;
            const factory : IUploadedFileFactory
        );
        destructor destroy(); override;

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
         * @return IUploadedFileArray instance
         *------------------------------------------------*)
        function getUploadedFile(const key : shortstring) : IUploadedFileArray;

        (*!------------------------------------------------
         * get IUploadedFile instance by index
         *-------------------------------------------------
         * @return IUploadedFileArray instance
         *------------------------------------------------*)
        function getUploadedFile(const indx : integer) : IUploadedFileArray;

        (*!-------------------------------------
         * Add content as IUploadedFile
         *--------------------------------------
         * @param key name of field
         * @param content content of file
         * @param contentType file content type
         * @param originalFilename original filename uploaded by user
         *--------------------------------------*)
        function add(
            const key : shortstring;
            const content : string;
            const contentType : string;
            const originalFilename : string
        ) : IUploadedFileCollectionWriter;
    end;

implementation

uses

    UploadedFileImpl;

type

    TUploadedFileRec = record
        //variable name
        key : shortstring;

        //this will store the actual number of uploaded file data
        uploadedFilesCount : integer;

        //array is used so we can support multiple
        //uploaded file with same name.
        //Number of element in array may be different than uploadedFilesCount
        //because they may be pre-allocated to avoid too many SetLength() call
        uploadedFiles : IUploadedFileArray;
    end;
    PUploadedFileRec = ^TUploadedFileRec;

    constructor TUploadedFileCollection.create(
        const listInst : IList;
        const factory : IUploadedFileFactory
    );
    begin
        uploadedFiles := listInst;
        uploadedFileFactory := factory;
    end;

    destructor TUploadedFileCollection.destroy();
    begin
        inherited destroy();
        clearUploadedFiles(uploadedFiles);
        uploadedFiles := nil;
    end;

    procedure TUploadedFileCollection.clearUploadedFiles(const listInst : IList);
    var item : PUploadedFileRec;
        i : integer;
    begin
        for i:=listInst.count()-1 downto 0 do
        begin
            item := listInst.get(i);
            setLength(item^.key, 0);
            item^.uploadedFiles := nil;
            dispose(item);
            listInst.delete(i);
        end;
    end;

    (*!------------------------------------------------
     * get total uploaded file in collection
     *-------------------------------------------------
     * @return number of item in collection
     *------------------------------------------------*)
    function TUploadedFileCollection.count() : integer;
    begin
        result := uploadedFiles.count();
    end;

    (*!------------------------------------------------
     * test if there is uploaded file specified by name
     *-------------------------------------------------
     * @return true if specified
     *------------------------------------------------*)
    function TUploadedFileCollection.has(const key : shortstring) : boolean;
    begin
        result := (uploadedFiles.find(key) <> nil);
    end;

    (*!------------------------------------------------
     * get IUploadedFile instance by name
     *-------------------------------------------------
     * @return IUploadedFileArray instance
     *------------------------------------------------*)
    function TUploadedFileCollection.getUploadedFile(const key : shortstring) : IUploadedFileArray;
    var item : PUploadedFileRec;
    begin
        result := nil;
        item := uploadedFiles.find(key);
        if (item <> nil) then
        begin
            //uploadedFiles is pre allocated so it may or may not bigger than
            //actual element which is stored uploadedFilesCount so we need to copy
            //to ensure that we return correct array
            result := copy(item^.uploadedFiles, 0, item^.uploadedFilesCount);
        end;
    end;

    (*!------------------------------------------------
     * get IUploadedFile instance by index
     *-------------------------------------------------
     * @return IUploadedFile instance
     *------------------------------------------------*)
    function TUploadedFileCollection.getUploadedFile(const indx : integer) : IUploadedFileArray;
    var item : PUploadedFileRec;
    begin
        item := uploadedFiles.get(indx);
        //uploadedFiles is pre allocated so it may or may not bigger than
        //actual element which is stored uploadedFilesCount so we need to copy
        //to ensure that we return correct array
        result := copy(item^.uploadedFiles, 0, item^.uploadedFilesCount);
    end;

    (*!-------------------------------------
     * Add content as IUploadedFile
     *--------------------------------------
     * @param key key name
     * @param content content of file
     * @param contentType file content type
     * @param originalFilename original filename uploaded by user
     *--------------------------------------
     * RFC 7578 requires that form data with
     * same name do not coalesce. So if we have
     * multiple file upload, we will keep them
     * in array
     *--------------------------------------*)
    function TUploadedFileCollection.add(
        const key : shortstring;
        const content : string;
        const contentType : string;
        const originalFilename : string
    ) : IUploadedFileCollectionWriter;
    var item : PUploadedFileRec;
    begin
        item := uploadedFiles.find(key);
        if (item = nil) then
        begin
            new(item);
            item^.key := key;
            item^.uploadedFilesCount := 0;
            //pre allocated array
            setLength(item^.uploadedFiles, length(item^.uploadedFiles) + 10);
            uploadedFiles.add(key, item);
        end else
        begin
            if (length(item^.uploadedFiles) <= item^.uploadedFilesCount) then
            begin
                //resize array
                setLength(item^.uploadedFiles, length(item^.uploadedFiles) + 10);
            end;
        end;

        item^.uploadedFiles[item^.uploadedFilesCount] := uploadedFilefactory.createUploadedFile(
            content,
            contentType,
            originalFilename
        );
        inc(item^.uploadedFilesCount);
        result := self;
    end;
end.
