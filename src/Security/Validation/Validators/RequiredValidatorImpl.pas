{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RequiredValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    RequestIntf,
    ValidatorIntf,
    BaseValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate required input data, i.e, data that must
     * be present and not empty
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TRequiredValidator = class(TBaseValidator)
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
        constructor create();

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

    KeyValueTypes;

resourcestring

    sErrFieldIsRequired = 'Field %s is required and not empty';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TRequiredValidator.create();
    begin
        inherited create(sErrFieldIsRequired);
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
    function TRequiredValidator.isValid(
        const fieldName : shortstring;
        const dataToValidate : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var val : PKeyValue;
    begin
        val := dataToValidate.find(fieldName);
        result := ((val <> nil) and isValidData(val^.value, dataToValidate, request)) or
            //required validator that validates against uploaded files
            //will fail above test because dataToValidate does not include uploaded files
            //so we need to make sure that if there
            //is entry in uploaded file, assume pass validation
            ((request.uploadedFiles <> nil) and request.uploadedFiles.has(fieldName));
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TRequiredValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    begin
        result := (dataToValidate <> '');
    end;
end.
