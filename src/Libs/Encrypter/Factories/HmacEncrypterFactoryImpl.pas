{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HmacEncrypterFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type
    (*!------------------------------------------------
     * base abstract factory class for HMAC encrypter
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THmacEncrypterFactory = class(TFactory)
    protected
        fSecretKey : string;
        fSeparator : string;
    public
        constructor create();
        function secretKey(const key : string) : THmacEncrypterFactory;
        function separator(const sep : string) : THmacEncrypterFactory;
    end;

implementation

uses

    HmacEncrypterImpl;

    constructor THmacEncrypterFactory.create();
    begin
        fSeparator := DEFAULT_SEPARATOR;
    end;

    function THmacEncrypterFactory.secretKey(const key : string) : THmacEncrypterFactory;
    begin
        fSecretKey := key;
        result := self;
    end;

    function THmacEncrypterFactory.separator(const sep : string) : THmacEncrypterFactory;
    begin
        fSeparator := sep;
        result := self;
    end;
end.
