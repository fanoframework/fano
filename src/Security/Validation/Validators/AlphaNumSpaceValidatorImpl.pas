{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AlphaNumSpaceValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RegexIntf,
    ValidatorIntf,
    RegexValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate alpha numeric space input data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAlphaNumSpaceValidator = class(TRegexValidator)
    public
        constructor create(const regexInst : IRegex);
    end;

implementation

const

    REGEX_ALPHANUMSPACE = '^[a-zA-Z0-9\s]+$';

resourcestring

    sErrNotValidAlphaNumSpace = 'Field %s must be alpha numeric whitespace characters';

    constructor TAlphaNumSpaceValidator.create(const regexInst : IRegex);
    begin
        inherited create(regexInst, REGEX_ALPHANUMSPACE, sErrNotValidAlphaNumSpace);
    end;

end.
