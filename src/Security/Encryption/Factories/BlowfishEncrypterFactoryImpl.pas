{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BlowfishEncrypterFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type
    (*!------------------------------------------------
     * TBlowfishEncrypter factory class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TBlowfishEncrypterFactory = class(TFactory)
    private
        fSecretKey : string;
    public
        function secretKey(const key : string) : TBlowfishEncrypterFactory;

        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *----------------------------------------------------
         * This is implementation of IDependencyFactory
         *---------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses
    EncrypterIntf,
    DecrypterIntf,
    BlowfishEncrypterImpl,
    Base64EncrypterImpl,
    CompositeEncrypterImpl;

    function TBlowfishEncrypterFactory.secretKey(const key : string) : TBlowfishEncrypterFactory;
    begin
        fSecretKey := key;
        result := self;
    end;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TBlowfishEncrypterFactory.build(const container : IDependencyContainer) : IDependency;
    var blowfishEncrypter : IEncrypter;
        base64Encrypter : IEncrypter;
        blowfishDecrypter : IDecrypter;
        base64Decrypter : IDecrypter;
    begin
        blowfishEncrypter := TBlowfishEncrypter.create(fSecretKey);
        blowfishDecrypter := blowfishEncrypter as IDecrypter;
        base64Encrypter := TBase64Encrypter.create();
        base64Decrypter := base64Encrypter as IDecrypter;
        result := TCompositeEncrypter.create(
            [ blowfishEncrypter, base64Encrypter ],
            [ blowfishDecrypter, base64Decrypter ]
        );
    end;
end.
