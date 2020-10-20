{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HmacEncrypterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    EncrypterIntf,
    DecrypterIntf;

const

    DEFAULT_SEPARATOR = '||';

type

    (*!------------------------------------------------
     * abstract class having capability to encrypt/decrypt string
     * encoded as [hmac][separator][ciphertext]
     * hmac will be used to check for ciphertext data integrity
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THmacEncrypter = class(TInjectableObject, IEncrypter, IDecrypter)
    private
        fEncrypter : IEncrypter;
        fDecrypter : IDecrypter;
        fSecretKey : string;
        fSeparator : string;
    protected
        function calcHmac(const secretKey : string; const msg : string) : string; virtual; abstract;
    public
        constructor create(
            const encrypter : IEncrypter;
            const decrypter : IDecrypter;
            const secretKey : string;
            const separator : string = DEFAULT_SEPARATOR
        );
        destructor destroy(); override;

        (*!------------------------------------------------
         * encrypt string as [hmac][separator][ciphertext]
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
         * @throw EReadError exception when ciphertext is tampered
         *-----------------------------------------------*)
        function decrypt(const encryptedStr : string) : string;

    end;

implementation

uses

    Classes,
    SysUtils,
    hmac;

resourcestring

    sErrorDecrypt = 'Error decrypting text';

    constructor THmacEncrypter.create(
        const encrypter : IEncrypter;
        const decrypter : IDecrypter;
        const secretKey : string;
        const separator : string = DEFAULT_SEPARATOR
    );
    begin
        fEncrypter := encrypter;
        fDecrypter := decrypter;
        fSecretKey := secretKey;
        fSeparator := separator;
    end;

    destructor THmacEncrypter.destroy();
    begin
        fEncrypter := nil;
        fDecrypter := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * encrypt string as [hmac][separator][ciphertext]
     *-----------------------------------------------
     * @param originalStr original string
     * @return encrypted string
     *-----------------------------------------------*)
    function THmacEncrypter.encrypt(const originalStr : string) : string;
    var ciphertext : string;
    begin
        ciphertext := fEncrypter.encrypt(originalStr);
        result := calcHmac(fSecretKey, ciphertext) + fSeparator + ciphertext;
    end;

    (*!------------------------------------------------
     * decrypt string
     *-----------------------------------------------
     * @param encryptedStr encrypted string with format [hmac][separator][ciphertext]
     * @return original string
     * @throw EReadError exception when ciphertext is tampered
     *-----------------------------------------------*)
    function THmacEncrypter.decrypt(const encryptedStr : string) : string;
    var separatorPos : integer;
        hmac : string;
        ciphertext : string;
    begin
        separatorPos := pos(fSeparator, encryptedStr);
        if (separatorPos = 0) then
        begin
            //cipher text may be tampered
            raise EReadError.create(sErrorDecrypt);
        end;

        //extract hmac and ciphertext from encryptedStr
        hmac := copy(encryptedStr, 1, separatorPos - 1);
        ciphertext := copy(encryptedStr, separatorPos + 2, length(encryptedStr) - separatorPos - 1);

        if (hmac = calcHmac(fSecretKey, ciphertext)) then
        begin
            //ciphertext is not tampered, continue to decrypt it
            result := fDecrypter.decrypt(ciphertext);
        end else
        begin
            //cipher text may be tampered
            raise EReadError.create(sErrorDecrypt);
        end;
    end;
end.
