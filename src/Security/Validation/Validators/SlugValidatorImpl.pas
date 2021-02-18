{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SlugValidatorImpl;

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
     * validate input data that matched slug pattern
     * for example 'this-is-slug'
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TSlugValidator = class(TRegexValidator)
    public
        constructor create(const regexInst : IRegex);
    end;

implementation

const

    REGEX_SLUG = '^[a-z0-9]+(-[a-z0-9]+)*$';

resourcestring

    sErrNotValidSlug = 'Field ''%s'' must be slug format';

    constructor TSlugValidator.create(const regexInst : IRegex);
    begin
        inherited create(regexInst, REGEX_SLUG, sErrNotValidSlug);
    end;

end.
