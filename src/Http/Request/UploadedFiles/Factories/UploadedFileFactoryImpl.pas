{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    UploadedFileIntf,
    UploadedFileFactoryIntf,
    InjectableObjectImpl;

type
    (*!------------------------------------------------
     * factory class TUploadedFile
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUploadedFileFactory = class(TInjectableObject, IUploadedFileFactory)
    public
        (*!----------------------------------------
         * create instance of IUploadedFile
         *-----------------------------------------
         * @param content content of uploaded file
         * @param contentType content type of uploaded file
         * @param origFilename original filename as uploaded by user
         *-----------------------------------------
         * We will create temporary file to hold uploaded
         * file content.
         *-----------------------------------------*)
        function createUploadedFile(
            const content : string;
            const contentType : string;
            const origFilename : string
        ) : IUploadedFile;
    end;

implementation

uses

    UploadedFileImpl;

    (*!----------------------------------------
     * create instance of IUploadedFile
     *-----------------------------------------
     * @param content content of uploaded file
     * @param contentType content type of uploaded file
     * @param origFilename original filename as uploaded by user
     *-----------------------------------------
     * We will create temporary file to hold uploaded
     * file content.
     *-----------------------------------------*)
    function TUploadedFileFactory.createUploadedFile(
        const content : string;
        const contentType : string;
        const origFilename : string
    ) : IUploadedFile;
    begin
        result := TUploadedFile.create(
            content,
            contentType,
            origFilename
        );
    end;
end.
