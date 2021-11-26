{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    UploadedFileIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability create
     * instance of IUploadedFileCollection
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IUploadedFileFactory = interface
        ['{3616D812-7ECF-4CFF-9C8D-E5E167B67EA7}']

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

end.
