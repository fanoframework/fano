{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Sha1HmacEncrypterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    HmacEncrypterImpl;

type

    (*!------------------------------------------------
     * class having capability to encrypt/decrypt string
     * encoded as [hmac][separator][ciphertext]
     * hmac SHA1 will be used to check for ciphertext data integrity
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSha1HmacEncrypter = class(THmacEncrypter)
    protected
        function calcHmac(const secretKey : string; const msg : string) : string; override;
    end;

implementation

uses

    hmac;

    function TSha1HmacEncrypter.calcHmac(const secretKey : string; const msg : string) : string;
    begin
        result := HMACSHA1Print(HMACSHA1Digest(secretKey, msg));
    end;

end.
