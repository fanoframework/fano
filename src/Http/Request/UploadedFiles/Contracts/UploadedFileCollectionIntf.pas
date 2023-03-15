{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileCollectionIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    UploadedFileIntf;

type
    IUploadedFileArray = array of IUploadedFile;

    (*!------------------------------------------------
     * interface for any class having capability as
     * contain array of IUploadedFile instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IUploadedFileCollection = interface
        ['{116083C1-4484-489D-AE15-5565B29CE802}']

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

end.
