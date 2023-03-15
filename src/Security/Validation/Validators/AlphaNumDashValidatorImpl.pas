{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AlphaNumDashValidatorImpl;

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
     * validate alpha numeric and dash input data.
     * This is mostly used to validate guid/id string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAlphaNumDashValidator = class(TRegexValidator)
    public
        constructor create(const regexInst : IRegex);
    end;

implementation

resourcestring

    sErrNotValidAlphaNumDash = 'Field ''%s'' must be alpha numeric or dash charaters';

    constructor TAlphaNumDashValidator.create(const regexInst : IRegex);
    begin
        inherited create(regexInst, '^[a-zA-Z0-9\-]+$', sErrNotValidAlphaNumDash);
    end;

end.
