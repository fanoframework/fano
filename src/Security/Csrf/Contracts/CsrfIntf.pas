{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CsrfIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIntf,
    RequestIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * generate token to protect Cross-Site Request Forgery
     * (CSRF) attack
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ICsrf = interface
        ['{7B3FA924-39FD-4EE3-B782-F76A5559160F}']

        (*!------------------------------------------------
         * generate token name and value
         *-------------------------------------------------
         * @param tokenName token name
         * @param tokenValue token value
         * @return current instance
         *-------------------------------------------------*)
        function generateToken(out tokenName : string; out tokenValue : string) : ICsrf;

        (*!------------------------------------------------
         * test if request has valid token
         *-------------------------------------------------
         * @param request current request
         * @param sess current session
         * @param nameKey key contains name of token
         * @param valueKey key contains value of token
         * @return current instance
         *-------------------------------------------------*)
        function hasValidToken(
            const request : IRequest;
            const sess : ISession;
            const nameKey : shortstring;
            const valueKey : shortstring
        ) : boolean;
    end;

implementation

end.
