{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Md5HmacEncrypterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    HmacEncrypterImpl;

type

    (*!------------------------------------------------
     * class having capability to encrypt/decrypt string
     * encoded as [hmac][separator][ciphertext]
     * hmac MD5 will be used to check for ciphertext data integrity
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMd5HmacEncrypter = class(THmacEncrypter)
    protected
        function calcHmac(const secretKey : string; const msg : string) : string; override;
    end;

implementation

uses

    hmac;

    function TMD5HmacEncrypter.calcHmac(const secretKey : string; const msg : string) : string;
    begin
        result := HMACMD5Print(HMACMD5Digest(secretKey, msg));
    end;

end.
