{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MultipartFormDataParserIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ListIntf,
    EnvironmentIntf,
    UploadedFileCollectionWriterIntf;

type

    (*!----------------------------------------------
     * interface for any class having capability as
     * parse multipart/form-data request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IMultipartFormDataParser = interface
        ['{F0C5A45D-B8F0-4CF6-86FD-84C60C17E67E}']

        (*!----------------------------------------
         * Read POST data and parse
         * it and store parsed data in body request parameter
         * and uploaded files (if any). If not file upload
         * then TNullUploadedFileCollection instance is return
         *------------------------------------------
         * @param contentType Content-Type request header
         * @param postData POST data from web server
         * @param body instance of IList that will store
         *             parsed body parameter
         * @param uploadedFiles instance of uploaded file collection
         * @return current instance
         *------------------------------------------*)
        function parse(
            const contentType : string;
            const postData : string;
            const body : IList;
            out uploadedFiles : IUploadedFileCollectionWriter
        ) : IMultipartFormDataParser;
    end;

implementation
end.
