{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UrlValidatorImpl;

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
     * validate URL input data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TUrlValidator = class(TRegexValidator)
    public
        constructor create(const regexInst : IRegex);
    end;

implementation

const


    (*!------------------------------------------------
     * regular expression to match URL
     *
     * @author Chris Fryer
     * @credit https://blogs.lse.ac.uk/lti/2008/04/23/a-regular-expression-to-match-any-url
     *-------------------------------------------------*)
    REGEX_URL = '^([A-Za-z]{3,9})://|//|mailto:|news:([-;:&=\+\$,\w]+@{1})?' +
        '([-A-Za-z0-9\.]+)+:?(\d+)?((/[-\+~%/\.\w]+)' +
        '?\??([-\+=&;%@\.\w]+)?#?([\w]+)?)?$';

resourcestring

    sErrNotValidUrl = 'Field %s must be URL format';

    constructor TUrlValidator.create(const regexInst : IRegex);
    begin
        inherited create(regexInst, REGEX_URL, sErrNotValidUrl);
    end;

end.
