{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Base64EncrypterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    EncrypterIntf,
    DecrypterIntf;

type

    (*!------------------------------------------------
     * class having capability to encrypt/decrypt string
     * using Base64
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TBase64Encrypter = class(TInjectableObject, IEncrypter, IDecrypter)
    private
        function encodeBase64SpecialChars(const base64Str : string) : string;
        function decodeBase64SpecialChars(const base64Str : string) : string;
    public

        (*!------------------------------------------------
         * encrypt string
         *-----------------------------------------------
         * @param originalStr original string
         * @return encrypted string
         *-----------------------------------------------*)
        function encrypt(const originalStr : string) : string;

        (*!------------------------------------------------
         * decrypt string
         *-----------------------------------------------
         * @param encryptedStr encrypted string
         * @return original string
         *-----------------------------------------------*)
        function decrypt(const encryptedStr : string) : string;

    end;

implementation

uses

    Classes,
    Base64,
    SysUtils;

    function TBase64Encrypter.encodeBase64SpecialChars(const base64Str : string) : string;
    begin
        result := StringReplace(base64Str, '+', '.', [rfReplaceAll]);
        result := StringReplace(result, '/', '_', [rfReplaceAll]);
        result := StringReplace(result, '=', '-', [rfReplaceAll]);
    end;

    function TBase64Encrypter.decodeBase64SpecialChars(const base64Str : string) : string;
    begin
        result := StringReplace(base64Str, '.', '+', [rfReplaceAll]);
        result := StringReplace(result, '_', '/', [rfReplaceAll]);
        result := StringReplace(result, '-', '=', [rfReplaceAll]);
    end;

    (*!------------------------------------------------
     * encrypt string
     *-----------------------------------------------
     * @param originalStr original string
     * @return encrypted string
     *-----------------------------------------------*)
    function TBase64Encrypter.encrypt(const originalStr : string) : string;
    begin
        result := encodeBase64SpecialChars(encodeStringBase64(originalStr));
    end;

    (*!------------------------------------------------
     * decrypt string
     *-----------------------------------------------
     * @param encryptedStr encrypted string
     * @return original string
     *-----------------------------------------------*)
    function TBase64Encrypter.decrypt(const encryptedStr : string) : string;
    begin
        result := decodeStringBase64(decodeBase64SpecialChars(encryptedStr));
    end;
end.
