{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Md5BlowfishEncrypterFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    HmacEncrypterFactoryImpl;

type
    (*!------------------------------------------------
     * TBlowfishEncrypter with HMAC MD5 factory class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMd5BlowfishEncrypterFactory = class(THmacEncrypterFactory)
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
    Md5HmacEncrypterImpl;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TMd5BlowfishEncrypterFactory.build(const container : IDependencyContainer) : IDependency;
    var bfEncrypter : IEncrypter;
        bfDecrypter : IDecrypter;
    begin
        bfEncrypter := TBlowfishEncrypter.create(fSecretKey);
        bfDecrypter := bfEncrypter as IDecrypter;

        result := TMd5HmacEncrypter.create(
            bfEncrypter,
            bfDecrypter,
            fSecretKey,
            fSeparator
        );
    end;
end.
