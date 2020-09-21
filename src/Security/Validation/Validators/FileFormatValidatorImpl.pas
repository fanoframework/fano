{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FileFormatValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    RequestIntf,
    ValidatorIntf,
    UploadedFileCollectionIntf;

const

    MinBuffSize = 64;

type

    (*!------------------------------------------------
     * bastract class which validate content of uploaded file
     * to match certain format
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TFileFormatValidator = class(TInterfacedObject, IValidator)
    private
        errorMsgFormat : string;
        function verifyFileFormat(const fname :  string) : boolean;
        function verifyUploadedFiles(const uploadedFiles : IUploadedFileArray) : boolean;
    protected
        function isValidFormat(const buffer; const buffSize : int64) : boolean; virtual; abstract;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param errMsgFormat message that is used as template
         *                    for error message
         *-------------------------------------------------
         * errMsgFormat can use format that is support by
         * SysUtils.Format() function
         *-------------------------------------------------*)
        constructor create(const errMsgFormat : string);

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
        ) : boolean;

        (*!------------------------------------------------
         * Get validation error message
         *-------------------------------------------------
         * @param key name of filed that is being validated
         * @return validation error message
         *-------------------------------------------------*)
        function errorMessage(const fieldName : shortstring) : string;
    end;

implementation

uses

    SysUtils,
    Classes;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param errMsgFormat message that is used as template
     *                    for error message
     *-------------------------------------------------
     * errMsgFormat can use format that is support by
     * SysUtils.Format() function
     *-------------------------------------------------*)
    constructor TFileFormatValidator.create(const errMsgFormat : string);
    begin
        errorMsgFormat := errMsgFormat;
    end;

    (*!------------------------------------------------
     * Get validation error message
     *-------------------------------------------------
     * @return validation error message
     *-------------------------------------------------*)
    function TFileFormatValidator.errorMessage(const fieldName : shortstring) : string;
    begin
        result := format(errorMsgFormat, [fieldName]);
    end;

    function TFileFormatValidator.verifyFileFormat(const fname :  string) : boolean;
    var fstream : TFileStream;
        buf : pointer;
    begin
        fstream := TFileStream.create(fname, fmOpenRead or fmShareDenyWrite);
        try
            getMem(buf, MinBuffSize);
            try
                //just read few bytes of header
                fstream.readBuffer(buf^, MinBuffSize);
                result := isValidFormat(buf^, MinBuffSize);
            finally
                freeMem(buf);
            end;
        finally
            fstream.free();
        end;
    end;

    function TFileFormatValidator.verifyUploadedFiles(const uploadedFiles : IUploadedFileArray) : boolean;
    var i, len : integer;
    begin
        result := true;
        len := length(uploadedFiles);
        for i := 0 to len - 1 do
        begin
            result := verifyFileFormat(uploadedFiles[i].getTmpFilename());
            if not result then
            begin
                exit;
            end;
        end;
    end;

    (*!------------------------------------------------
     * Validate data
     *-------------------------------------------------
     * @param key name of field
     * @param dataToValidate input data
     * @param request request object
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TFileFormatValidator.isValid(
        const fieldName : shortstring;
        const dataToValidate : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var uploadedFiles :  IUploadedFileArray;
    begin
        uploadedFiles := request.getUploadedFile(fieldName);
        if (uploadedFiles <> nil) then
        begin
            result := verifyUploadedFiles(uploadedFiles);
        end else
        begin
            //no file upload for this field. Assume success
            result := true;
        end;
    end;
end.
