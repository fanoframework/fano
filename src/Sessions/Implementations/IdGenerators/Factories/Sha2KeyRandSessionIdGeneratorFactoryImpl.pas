{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Sha2KeyRandSessionIdGeneratorFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIdGeneratorIntf,
    SessionIdGeneratorFactoryIntf;

type

    (*!------------------------------------------------
     * class having capability to
     * create session id generator which use SHA2 of
     * secret key + IP address + time + random bytes
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSha2KeyRandSessionIdGeneratorFactory = class(TInterfacedObject, ISessionIdGeneratorFactory)
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

    DevUrandomImpl,
    KeySessionIdGeneratorImpl,
    RawSessionIdGeneratorImpl,
    Sha2SessionIdGeneratorImpl;

    constructor TSha2KeyRandSessionIdGeneratorFactory.create(const secretKey : string);
    begin
        fSecretKey := secretKey;
    end;

    (*!------------------------------------
     * build session id generator instance
     *-------------------------------------
     * @return session id generator instance
     *-------------------------------------*)
    function TSha2KeyRandSessionIdGeneratorFactory.build() : ISessionIdGenerator;
    begin
        result := TSha2SessionIdGenerator.create(
            TKeySessionIdGenerator.create(
                TRawSessionIdGenerator.create(TDevurandom.create()),
                fSecretKey
            )
        );
    end;
end.
