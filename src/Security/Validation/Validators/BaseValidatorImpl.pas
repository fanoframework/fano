{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BaseValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    RequestIntf,
    ValidatorIntf;

type

    (*!------------------------------------------------
     * base abstract class having capability to
     * validate input data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TBaseValidator = class(TInterfacedObject, IValidator)
    protected
        errorMsgFormat : string;

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
        ) : boolean; virtual; abstract;

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
        ) : boolean; virtual;

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

    KeyValueTypes,
    SysUtils;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param errMsgFormat message that is used as template
     *                    for error message
     *-------------------------------------------------
     * errMsgFormat can use format that is support by
     * SysUtils.Format() function
     *-------------------------------------------------*)
    constructor TBaseValidator.create(const errMsgFormat : string);
    begin
        errorMsgFormat := errMsgFormat;
    end;

    (*!------------------------------------------------
     * Get validation error message
     *-------------------------------------------------
     * @return validation error message
     *-------------------------------------------------*)
    function TBaseValidator.errorMessage(const fieldName : shortstring) : string;
    begin
        result := format(errorMsgFormat, [fieldName]);
    end;

    (*!------------------------------------------------
     * Validate data
     *-------------------------------------------------
     * @param key name of field
     * @param dataToValidate input data
     * @param request request object
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TBaseValidator.isValid(
        const fieldName : shortstring;
        const dataToValidate : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var val : PKeyValue;
    begin
        val := dataToValidate.find(fieldName);
        if (val = nil) then
        begin
            //if we get here it means there is no field with that name
            //so assume that validation is success
            result := true;
        end else
        begin
            result := isValidData(val^.value, dataToValidate, request);
        end;
    end;
end.
