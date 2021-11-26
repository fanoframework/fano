{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedMimeValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    ReadOnlyListIntf,
    RequestIntf,
    ValidatorIntf,
    UploadedFileValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate field that is a valid uploaded file must be
     * in certain mime types
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TUploadedMimeValidator = class(TUploadedFileValidator)
    private
        fMimeTypes : TStringArray;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create(const mimes : array of string);
        destructor destroy(); override;

        (*!------------------------------------------------
         * Validate data
         *-------------------------------------------------
         * @param fieldName name of field
         * @param dataToValidate input data
         * @param request request object
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
         function isValid(
             const fieldName : shortstring;
             const dataToValidate : IReadOnlyList;
             const request : IRequest
         ) : boolean; override;
    end;

implementation

uses

    StringUtils,
    UploadedFileCollectionIntf;

resourcestring

    sErrFieldIsUploadedMime = 'Field %%s must be a valid uploaded file with MIME type in [%s]';

    function inMimeTypes(const aType : string; const mimeTypes : TStringArray) : boolean;
    var i, len : integer;
    begin
        result := false;
        len := length(mimeTypes);
        for i := 0 to len -1 do
        begin
            if (aType = mimeTypes[i]) then
            begin
                result := true;
                exit();
            end;
        end;
    end;

    function isValidMimeTypes(const uploadedFiles : IUploadedFileArray; const mimeTypes : TStringArray) : boolean;
    var i, len : integer;
    begin
        result := true;
        len := length(uploadedFiles);
        for i:= 0 to len - 1 do
        begin
            if not inMimeTypes(uploadedFiles[i].getClientMediaType(), mimeTypes) then
            begin
                result := false;
                exit();
            end;
        end;
    end;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TUploadedMimeValidator.create(const mimes : array of string);
    begin
        inherited create();
        errorMsgFormat := format(sErrFieldIsUploadedMime, [ join(', ', mimes) ]);
        fMimeTypes := toStringArray(mimes);
    end;

    destructor TUploadedMimeValidator.destroy();
    begin
        setLength(fMimeTypes, 0);
        fMimeTypes := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * Validate data
     *-------------------------------------------------
     * @param fieldName name of field
     * @param dataToValidate input data
     * @param request request object
     * @return true if data is valid otherwise false
     *-------------------------------------------------
     * We assume dataToValidate <> nil
     *-------------------------------------------------*)
    function TUploadedMimeValidator.isValid(
        const fieldName : shortstring;
        const dataToValidate : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    begin
        result := inherited isValid(fieldName, dataToValidate, request);
        if not result then
        begin
            //not valid uploaded file
            exit();
        end;

        //if we get here, it means it is valid uploaded file, test for its mime
        result := isValidMimeTypes(request.getUploadedFile(fieldName), fMimeTypes);
    end;
end.
