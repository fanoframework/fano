{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JwtAlgSignerIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    JwtAlgIntf;

type

    (*!------------------------------------------------
     * interface for any JWT algorithm class having
     * capability to generate jwt token signature
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IJwtAlgSigner = interface(IJwtAlg)
        ['{7BF0C343-C778-44D8-A3DE-1C55956BA19E}']

        (*!------------------------------------------------
         * compute JWT signature of payload
         *-------------------------------------------------
         * @param headerPayload payload to sign
         * @param secretKey secret key
         * @return string signature
         *-------------------------------------------------
         * Note: headerPayload is assumed concatenated value of
         * base64url_header + '.' + base64url_claim
         *-------------------------------------------------*)
        function sign(const headerPayload : string; const secretKey : string) : string;

    end;

implementation

end.
