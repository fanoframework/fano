{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JcbValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RegexIntf,
    ValidatorIntf,
    RegexValidatorImpl;

type

    (*!------------------------------------------------
     * class having capability to validate input data
     * that matched JCB credit card number pattern
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TJcbValidator = class(TRegexValidator)
    public
        constructor create(const regexInst : IRegex);
    end;

implementation

const

    REGEX_JCB = '^(?:2131|1800|35[0-9]{3})[0-9]{11}$';

resourcestring

    sErrNotValidJcbCreditCardNumber = 'Field ''%s'' must be JCB credit card number';

    constructor TJcbValidator.create(const regexInst : IRegex);
    begin
        inherited create(regexInst, REGEX_JCB, sErrNotValidJcbCreditCardNumber);
    end;

end.
