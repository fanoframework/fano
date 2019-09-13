{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedSizeValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    ListIntf,
    RequestIntf,
    ValidatorIntf,
    UploadedFileValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate field that is a valid uploaded file size
     * must not exceed maximum size
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TUploadedSizeValidator = class(TUploadedFileValidator)
    private
        fMaxSize : int64;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create(const maxSize : int64);

        (*!------------------------------------------------
         * Validate data
         *-------------------------------------------------
         * @param key name of field
         * @param dataToValidate input data
         * @param request request object
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
         function isValid(
             const key : shortstring;
             const dataToValidate : IList;
             const request : IRequest
         ) : boolean; override;
    end;

implementation

uses

    UploadedFileCollectionIntf;

resourcestring

    sErrFieldIsUploadedSize = 'Field %s must be a valid uploaded file with size not exceed ';

    function isValidSize(const uploadedFiles : IUploadedFiles; const size : int64) : boolean;
    var i, len : integer;
    begin
        result := true;
        len := length(uploadedFiles);
        for i:= 0 to len - 1 do
        begin
            if (uploadedFiles[i].size() > size) then
            begin
                result := false;
                exit();
            end;
        end;
    end;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TUploadedSizeValidator.create(const maxSize : int64);
    begin
        inherited create(sErrFieldIsUploadedSize);
        fMaxSize := maxSize;
    end;

    (*!------------------------------------------------
     * Validate data
     *-------------------------------------------------
     * @param key name of field
     * @param dataToValidate input data
     * @param request request object
     * @return true if data is valid otherwise false
     *-------------------------------------------------
     * We assume dataToValidate <> nil
     *-------------------------------------------------*)
    function TUploadedSizeValidator.isValid(
        const key : shortstring;
        const dataToValidate : IList;
        const request : IRequest
    ) : boolean;
    begin
        result := inherited isValid(key, dataToValidate, request);
        if not result then
        begin
            //not valid uploaded file
            exit();
        end;

        //if we get here, it means it is valid uploaded file, test for its size
        result := isValidSize(request.getUploadedFile(key), fMaxSize);
    end;
end.