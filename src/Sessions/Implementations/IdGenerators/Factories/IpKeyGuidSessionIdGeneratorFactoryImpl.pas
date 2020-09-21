{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IpKeyGuidSessionIdGeneratorFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIdGeneratorIntf,
    SessionIdGeneratorFactoryIntf;

type

    (*!------------------------------------------------
     * class having capability to
     * create session id generator which use SHA1 of
     * IP address + time + secret key + guid
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TIpKeyGuidSessionIdGeneratorFactory = class(TInterfacedObject, ISessionIdGeneratorFactory)
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

    IpTimeSessionIdGeneratorImpl,
    KeySessionIdGeneratorImpl,
    GuidSessionIdGeneratorImpl,
    Sha1SessionIdGeneratorImpl;

    constructor TIpKeyGuidSessionIdGeneratorFactory.create(const secretKey : string);
    begin
        fSecretKey := secretKey;
    end;

    (*!------------------------------------
     * build session id generator instance
     *-------------------------------------
     * @return session id generator instance
     *-------------------------------------*)
    function TIpKeyGuidSessionIdGeneratorFactory.build() : ISessionIdGenerator;
    begin
        result := TSha1SessionIdGenerator.create(
            TIpTimeSessionIdGenerator.create(
                TKeySessionIdGenerator.create(
                    TGuidSessionIdGenerator.create(),
                    fSecretKey
                )
            )
        );
    end;
end.
