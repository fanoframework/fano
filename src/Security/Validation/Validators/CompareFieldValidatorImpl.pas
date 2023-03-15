{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompareFieldValidatorImpl;

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
     * basic abstract class having capability to
     * validate data that must be compared with other field
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCompareFieldValidator = class(TBaseValidator)
    protected
        fComparedField : shortstring;

        (*!------------------------------------------------
         * compare data with other data from field
         *-------------------------------------------------
         * @param dataToValidate input data
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
        function compare(
            const dataToValidate : string;
            const otherFieldData : string
        ) : boolean; virtual; abstract;

        function isValidData(
            const dataToValidate : string;
            const dataCollection : IReadOnlyList;
            const request : IRequest
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create(
            const errorMsg : string;
            const comparedField : shortstring
        );
    end;

implementation

uses

    KeyValueTypes;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TCompareFieldValidator.create(
        const errorMsg : string;
        const comparedField : shortstring
    );
    begin
        inherited create(errorMsg);
        fComparedField := comparedField;
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TCompareFieldValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var comparedVal : PKeyValue;
    begin
        comparedVal := dataCollection.find(fComparedField);
        if (comparedVal = nil) then
        begin
            //no field to compared, so assumed fails
            result := false;
        end else
        begin
            result := compare(dataToValidate, comparedVal^.value);
        end;
    end;
end.
