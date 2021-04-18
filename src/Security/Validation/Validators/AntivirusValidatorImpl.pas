{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AntivirusValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    RequestIntf,
    ValidatorIntf,
    AntivirusIntf,
    UploadedFileCollectionIntf,
    UploadedFileIntf,
    BaseValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate field that uploaded file must be free from virus
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAntivirusValidator = class(TBaseValidator)
    private
        fAntivirus : IAntivirus;
        fOriginalErrMsg : string;
        function scanUploadedFiles(const uploadedFiles : IUploadedFileArray) : boolean;
    protected
        (*!------------------------------------------------
         * actual data validation
         *-------------------------------------------------
         * @param dataToValidate input data
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
        function isValidData(
            const dataToValidate : string;
            const dataCollection : IReadOnlyList;
            const request : IRequest
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create(const antivirus : IAntivirus);

        (*!------------------------------------------------
         * destructor
         *-------------------------------------------------*)
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

    sysutils,
    ScanResultIntf;

resourcestring

    sErrFieldIsMustBeFreeFromVirus = 'Field %s must be a free from virus.';
    sErrVirusDetected = ' Virus "%s" detected in file "%s"';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TAntivirusValidator.create(const antivirus : IAntivirus);
    begin
        inherited create(sErrFieldIsMustBeFreeFromVirus);
        fOriginalErrMsg := sErrFieldIsMustBeFreeFromVirus;
        fAntivirus := antivirus;
        fAntivirus.beginScan();
    end;

    (*!------------------------------------------------
     * destructor
     *-------------------------------------------------*)
    destructor TAntivirusValidator.destroy();
    begin
        fAntivirus := nil;
        inherited destroy();
    end;

    function TAntivirusValidator.scanUploadedFiles(const uploadedFiles : IUploadedFileArray) : boolean;
    var scanRes : IScanResult;
        i, len : integer;
    begin
        result := true;
        len := length(uploadedFiles);
        for i := 0 to len -1 do
        begin
            scanRes := fAntivirus.scanFile(uploadedFiles[i].getTmpFilename());
            result := result and scanRes.isCleaned();
            if not result then
            begin
                //virus detected, exit loop early
                errorMsgFormat := fOriginalErrMsg +
                    format(
                        sErrVirusDetected,
                        [
                            scanRes.virusName() ,
                            uploadedFiles[i].getClientFilename()
                        ]
                    );
                exit;
            end;
        end;
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
    function TAntivirusValidator.isValid(
        const fieldName : shortstring;
        const dataToValidate : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var uploadedFiles : IUploadedFileArray;
    begin
        uploadedFiles := request.getUploadedFile(fieldName);
        if (uploadedFiles <> nil) then
        begin
            result := scanUploadedFiles(uploadedFiles);
        end else
        begin
            //assume validation pass
            result := true;
        end;
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TAntivirusValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    begin
        //not used here but we must implement, as this is abstract method
        result := true;
    end;
end.
