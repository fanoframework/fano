{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DigestInfoTypes;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * type to hold data from HTTP Digest Authentication (RFC 2617)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TDigestInfo = record
        username : string;
        nonce : string;
        realm : string;
        uri : string;
        qop : string;
        nc : string;
        cnonce : string;
        response : string;
        opaque : string;
        method : string;
    end;

    PDigestInfo = ^TDigestInfo;

implementation

end.
