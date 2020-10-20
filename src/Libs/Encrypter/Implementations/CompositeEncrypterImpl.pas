{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompositeEncrypterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    EncrypterIntf,
    DecrypterIntf;

type

    TEncrypterArray = array of IEncrypter;
    TDecrypterArray = array of IDecrypter;

    (*!------------------------------------------------
     * class having capability to encrypt/decrypt string
     * using several external encrypter
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCompositeEncrypter = class(TInjectableObject, IEncrypter, IDecrypter)
    private
        fEncrypters : TEncrypterArray;
        fDecrypters : TDecrypterArray;
        procedure freeEncrypters(var encrypters : TEncrypterArray);
        function initEncrypters(const encrypters : array of IEncrypter) : TEncrypterArray;
        procedure freeDecrypters(var decrypters : TDecrypterArray);
        function initDecrypters(const decrypters : array of IDecrypter) : TDecrypterArray;
    public

        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param encrypters array of encrypter
         * @param decrypters array of decrypter
         *-----------------------------------------------
         * the order of encrypters and decrypters must match
         * as decrypters is looped reverse. See decrypt() method
         * for example
         * TComposetEncrypter.create(
         *    [AEncrypter, BEncrypter]
         *    [ADecrypter, BDecrypter]
         * );
         *-----------------------------------------------*)
        constructor create(
            const encrypters : array of IEncrypter;
            const decrypters : array of IDecrypter
        );

        destructor destroy(); override;

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

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------
     * @param encrypters array of encrypter
     * @param decrypters array of decrypter
     *-----------------------------------------------
     * the order of encrypters and decrypters must match
     * as decrypters is looped reverse. See decrypt() method
     * for example
     * TComposetEncrypter.create(
     *    [AEncrypter, BEncrypter]
     *    [ADecrypter, BDecrypter]
     * );
     *-----------------------------------------------*)
    constructor TCompositeEncrypter.create(
        const encrypters : array of IEncrypter;
        const decrypters : array of IDecrypter
    );
    begin
        fEncrypters := initEncrypters(encrypters);
        fDecrypters := initDecrypters(decrypters);
    end;

    destructor TCompositeEncrypter.destroy();
    begin
        freeEncrypters(fEncrypters);
        freeDecrypters(fDecrypters);
        inherited destroy();
    end;

    procedure TCompositeEncrypter.freeEncrypters(var encrypters : TEncrypterArray);
    var i, totEncrypters : integer;
    begin
        totEncrypters := length(encrypters);
        for i := 0 to totEncrypters - 1 do
        begin
            encrypters[i] := nil;
        end;
        setLength(encrypters, 0);
        encrypters := nil;
    end;

    function TCompositeEncrypter.initEncrypters(const encrypters : array of IEncrypter) : TEncrypterArray;
    var i, totEncrypters : integer;
    begin
        result := default(TEncrypterArray);
        totEncrypters := high(encrypters) - low(encrypters) + 1;
        setLength(result, totEncrypters);
        for i := 0 to totEncrypters - 1 do
        begin
            result[i] := encrypters[i];
        end;
    end;

    procedure TCompositeEncrypter.freeDecrypters(var decrypters : TDecrypterArray);
    var i, totDecrypters : integer;
    begin
        totDecrypters := length(decrypters);
        for i := 0 to totDecrypters - 1 do
        begin
            decrypters[i] := nil;
        end;
        setLength(decrypters, 0);
        decrypters := nil;
    end;

    function TCompositeEncrypter.initDecrypters(const decrypters : array of IDecrypter) : TDecrypterArray;
    var i, totDecrypters : integer;
    begin
        result := default(TDecrypterArray);
        totDecrypters := high(decrypters) - low(decrypters) + 1;
        setLength(result, totDecrypters);
        for i := 0 to totDecrypters - 1 do
        begin
            result[i] := decrypters[i];
        end;
    end;

    (*!------------------------------------------------
     * encrypt string
     *-----------------------------------------------
     * @param originalStr original string
     * @return encrypted string
     *-----------------------------------------------*)
    function TCompositeEncrypter.encrypt(const originalStr : string) : string;
    var i, totEncrypters : integer;
    begin
        result := originalStr;
        totEncrypters := length(fEncrypters);
        for i:=0 to totEncrypters - 1 do
        begin
            result := fEncrypters[i].encrypt(result);
        end;
    end;

    (*!------------------------------------------------
     * decrypt string
     *-----------------------------------------------
     * @param encryptedStr encrypted string
     * @return original string
     *-----------------------------------------------*)
    function TCompositeEncrypter.decrypt(const encryptedStr : string) : string;
    var i, totDecrypters : integer;
    begin
        result := encryptedStr;
        totDecrypters := length(fDecrypters);
        //it is assumed that order of encrypter and decrypter matches
        //so to decrypt we must reverse order.
        for i := totDecrypters - 1 downto 0 do
        begin
            result := fDecrypters[i].decrypt(result);
        end;
    end;
end.
