{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Sha1BlowfishEncrypterFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    HmacEncrypterFactoryImpl;

type
    (*!------------------------------------------------
     * TBlowfishEncrypter with HMAC SHA1 factory class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSha1BlowfishEncrypterFactory = class(THmacEncrypterFactory)
    public
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
    Sha1HmacEncrypterImpl;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TSha1BlowfishEncrypterFactory.build(const container : IDependencyContainer) : IDependency;
    var bfEncrypter : IEncrypter;
        bfDecrypter : IDecrypter;
    begin
        bfEncrypter := TBlowfishEncrypter.create(fSecretKey);
        bfDecrypter := bfEncrypter as IDecrypter;

        result := TSha1HmacEncrypter.create(
            bfEncrypter,
            bfDecrypter,
            fSecretKey,
            fSeparator
        );
    end;
end.
