{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StartWithValidatorImpl;

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
     * validate input data starts with a value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStartWithValidator = class(TBaseValidator)
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

    SysUtils;

resourcestring

    sErrNotValidStart = 'Field ''%s'' must starts with ''%s''';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TStartWithValidator.create(const value : string);
    begin
        inherited create(format(sErrNotValidStart, ['%s', value]));
        fValue := value;
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TStartWithValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    begin
        //if pos return 1 it means fValue is found at beginning of string
        result := pos(fValue, dataToValidate) = 1;
    end;

end.
