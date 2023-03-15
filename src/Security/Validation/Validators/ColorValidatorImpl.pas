{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ColorValidatorImpl;

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
     * validate HTML color input data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TColorValidator = class(TRegexValidator)
    public
        constructor create(const regexInst : IRegex);
    end;

implementation

const

    REGEX_COLOR = '^#[a-fA-F0-9]{6}|#[a-fA-F0-9]{3}$';

resourcestring

    sErrNotValidColor = 'Field ''%s'' must be hex color value';

    constructor TColorValidator.create(const regexInst : IRegex);
    begin
        inherited create(regexInst, REGEX_COLOR, sErrNotValidColor);
    end;

end.
