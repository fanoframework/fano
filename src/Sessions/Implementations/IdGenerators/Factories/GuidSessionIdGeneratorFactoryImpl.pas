{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit GuidSessionIdGeneratorFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIdGeneratorIntf,
    SessionIdGeneratorFactoryIntf;

type

    (*!------------------------------------------------
     * class having capability to
     * create session id generator which use guid
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TGuidSessionIdGeneratorFactory = class(TInterfacedObject, ISessionIdGeneratorFactory)
    public
        (*!------------------------------------
         * build session id generator instance
         *-------------------------------------
         * @return session id generator instance
         *-------------------------------------*)
        function build() : ISessionIdGenerator;
    end;

implementation

uses

    GuidSessionIdGeneratorImpl;

    (*!------------------------------------
     * build session id generator instance
     *-------------------------------------
     * @return session id generator instance
     *-------------------------------------*)
    function TGuidSessionIdGeneratorFactory.build() : ISessionIdGenerator;
    begin
        result := TGuidSessionIdGenerator.create();
    end;
end.
