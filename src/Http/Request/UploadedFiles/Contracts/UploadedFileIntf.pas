{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability as
     * to handle HTTP file upload
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IUploadedFile = interface
        ['{FB845D92-7F41-4902-8C7A-F43EAEEA205D}']


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

end.
