{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ReferrerPolicyConfig;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * configuration for Referrer Policy header
     *-------------------------------------------------
     * https://www.w3.org/TR/referrer-policy
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TReferrerPolicyToken = (
        noReferrer,
        noReferrerWhenDowngrade,
        strictOrigin,
        strictOriginWhenCrossOrigin,
        sameOrigin,
        origin,
        originWhenCrossOrigin,
        unsafeUrl
    );

    TReferrerPolicyConfig = set of TReferrerPolicyToken;
    TReferrerPolicyTokenStr = array[TReferrerPolicyToken] of shortstring;

const

    ReferrerPolicyTokenStr : TReferrerPolicyTokenStr = (
        'no-referrer',
        'no-referrer-when-downgrade',
        'strict-origin',
        'strict-origin-when-cross-origin',
        'same-origin',
        'origin',
        'origin-when-cross-origin',
        'unsafe-url'
    );

implementation

end.
