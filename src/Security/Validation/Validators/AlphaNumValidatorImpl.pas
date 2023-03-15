{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AlphaNumValidatorImpl;

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
     * validate alpha numeric input data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAlphaNumValidator = class(TRegexValidator)
    public
        constructor create(const regexInst : IRegex);
    end;

implementation

const

    REGEX_ALPHANUM = '^[a-zA-Z0-9]+$';

resourcestring

    sErrNotValidAlphaNum = 'Field ''%s'' must be alpha numeric characters';

    constructor TAlphaNumValidator.create(const regexInst : IRegex);
    begin
        inherited create(regexInst, REGEX_ALPHANUM, sErrNotValidAlphaNum);
    end;

end.
