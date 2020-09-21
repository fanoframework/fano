{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EmailValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RegexIntf,
    RegexValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate email input data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TEmailValidator = class(TRegexValidator)
    public
        constructor create(const regexInst : IRegex);
    end;

implementation

const

    REGEX_EMAIL = '^[_a-zA-Z\d\-.]+@([a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)*)$';

resourcestring

    sErrNotValidEmail = 'Field %s must be email format';

    constructor TEmailValidator.create(const regexInst : IRegex);
    begin
        inherited create(regexInst, REGEX_EMAIL, sErrNotValidEmail);
    end;

end.
