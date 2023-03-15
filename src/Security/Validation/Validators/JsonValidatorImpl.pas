{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    BaseValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate that data is valid JSON
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TJsonValidator = class(TBaseValidator)
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
    end;

implementation

uses

    SysUtils,
    fpjson,
    jsonparser;

resourcestring

    sErrFieldMustBeJson = 'Field %s must be valid JSON';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TJsonValidator.create();
    begin
        inherited create(sErrFieldMustBeJson);
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TJsonValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var jsonData : TJSONData;
    begin
        try
            //TODO: getJSON() will be called twice, first here then later in
            //actual code that process data. Can we avoid? cheap test using regex?
            jsonData := getJSON(dataToValidate);
            try
                result := (jsonData <> nil);
            finally
                jsonData.free();
            end;
        except
            //if exception is raised, it means not valid json
            result := false;
        end;
    end;
end.
