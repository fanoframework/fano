{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ConfirmedValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    CompareFieldValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate data that must be equal to other field.
     * This is mostly used for password confirmation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TConfirmedValidator = class(TCompareFieldValidator)
    protected

        (*!------------------------------------------------
         * actual data validation
         *-------------------------------------------------
         * @param dataToValidate input data
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
        function compare(
            const dataToValidate : string;
            const otherFieldData : string
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create(const confirmationField : shortstring);

    end;

implementation

resourcestring

    sErrFieldIsConfirmed = 'Field %s value must be equals to %s value';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TConfirmedValidator.create(const confirmationField : shortstring);
    begin
        inherited create(sErrFieldIsConfirmed, confirmationField);
    end;

    (*!------------------------------------------------
     * compare data with data from other field
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TConfirmedValidator.compare(
        const dataToValidate : string;
        const otherFieldData : string
    ) : boolean;
    begin
        result := (dataToValidate = otherFieldData);
    end;

end.
