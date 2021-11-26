{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EndWithValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ValidatorIntf,
    ReadOnlyListIntf,
    RequestIntf,
    BaseValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate input data ends with a value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TEndWithValidator = class(TBaseValidator)
    private
        fValue : string;
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
        constructor create(const value : string);
    end;

implementation

uses

    SysUtils,
    StrUtils;

resourcestring

    sErrNotValidEnd = 'Field ''%s'' must ends with ''%s''';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TEndWithValidator.create(const value : string);
    begin
        inherited create(format(sErrNotValidEnd, ['%s', value]));
        fValue := value;
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TEndWithValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var endPos : integer;
    begin
        endPos := length(dataToValidate) - length(fValue) + 1;
        //if rpos return endPos it means fValue is found at end of string
        result := rpos(fValue, dataToValidate) = endPos;
    end;

end.
