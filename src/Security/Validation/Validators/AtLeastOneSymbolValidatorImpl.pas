{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AtLeastOneSymbolValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RegexIntf,
    ValidatorIntf,
    RegexValidatorImpl;

type

    (*!------------------------------------------------
     * class having capability to validate
     * that input data at least contains one symbol character
     *-------------------------------------------------
     * This is provided so that we can provide password form
     * validation with custom rule such as min 8 characters
     * length with combination at least one letter, at least
     * one number, at least one symbol with mixed capitalization etc
     *--------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAtLeastOneSymbolValidator = class(TRegexValidator)
    public
        constructor create(const regexInst : IRegex);
    end;

implementation

const

    REGEX_AT_LEAST_ONE_SYMBOL = '\W+';

resourcestring

    sErrNotValidAtLeastOneSymbol = 'Field ''%s'' must contain at least one symbol character';

    constructor TAtLeastOneSymbolValidator.create(const regexInst : IRegex);
    begin
        inherited create(regexInst, REGEX_AT_LEAST_ONE_SYMBOL, sErrNotValidAtLeastOneSymbol);
    end;

end.
