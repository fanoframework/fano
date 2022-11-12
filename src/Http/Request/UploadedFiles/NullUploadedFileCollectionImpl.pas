{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullUploadedFileCollectionImpl;

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
     * null class having capability as
     * contain array of IUploadedFile instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullUploadedFileCollection = class(TInterfacedObject, IUploadedFileCollection, IUploadedFileCollectionWriter)
    public

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


    (*!------------------------------------------------
     * get total uploaded file in collection
     *-------------------------------------------------
     * @return number of item in collection
     *------------------------------------------------*)
    function TNullUploadedFileCollection.count() : integer;
    begin
        result := 0;
    end;

    (*!------------------------------------------------
     * test if there is uploaded file specified by name
     *-------------------------------------------------
     * @return true if specified
     *------------------------------------------------*)
    function TNullUploadedFileCollection.has(const key : shortstring) : boolean;
    begin
        result := false;
    end;

    (*!------------------------------------------------
     * get IUploadedFile instance by name
     *-------------------------------------------------
     * @return IUploadedFileArray instance
     *------------------------------------------------*)
    function TNullUploadedFileCollection.getUploadedFile(const key : shortstring) : IUploadedFileArray;
    begin
        result := nil;
    end;

    (*!------------------------------------------------
     * get IUploadedFile instance by index
     *-------------------------------------------------
     * @return IUploadedFile instance
     *------------------------------------------------*)
    function TNullUploadedFileCollection.getUploadedFile(const indx : integer) : IUploadedFileArray;
    begin
        result := nil;
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
    function TNullUploadedFileCollection.add(
        const key : shortstring;
        const content : string;
        const contentType : string;
        const originalFilename : string
    ) : IUploadedFileCollectionWriter;
    begin
        result := self;
    end;
end.
