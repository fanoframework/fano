{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit KeyGuidSessionIdGeneratorFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIdGeneratorIntf,
    SessionIdGeneratorFactoryIntf;

type

    (*!------------------------------------------------
     * class having capability to
     * create session id generator which use SHA1 of secret key + guid
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TKeyGuidSessionIdGeneratorFactory = class(TInterfacedObject, ISessionIdGeneratorFactory)
    private
        fSecretKey : string;
    public
        constructor create(const secretKey : string);

        (*!------------------------------------
         * build session id generator instance
         *-------------------------------------
         * @return session id generator instance
         *-------------------------------------*)
        function build() : ISessionIdGenerator;
    end;

implementation

uses

    KeySessionIdGeneratorImpl,
    GuidSessionIdGeneratorImpl,
    Sha1SessionIdGeneratorImpl;

    constructor TKeyGuidSessionIdGeneratorFactory.create(const secretKey : string);
    begin
        fSecretKey := secretKey;
    end;

    (*!------------------------------------
     * build session id generator instance
     *-------------------------------------
     * @return session id generator instance
     *-------------------------------------*)
    function TKeyGuidSessionIdGeneratorFactory.build() : ISessionIdGenerator;
    begin
        result := TSha1SessionIdGenerator.create(
            TKeySessionIdGenerator.create(
                TGuidSessionIdGenerator.create(),
                fSecretKey
            )
        );
    end;
end.
