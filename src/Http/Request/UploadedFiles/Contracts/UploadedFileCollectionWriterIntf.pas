{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileCollectionWriterIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability as
     * add IUploadedFile instance to collection
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IUploadedFileCollectionWriter = interface
        ['{0CDF6913-B812-4359-9542-E03A3718BC17}']

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

end.
