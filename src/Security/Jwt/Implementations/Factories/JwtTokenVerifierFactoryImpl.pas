{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JwtTokenVerifierFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    ListIntf,
    JwtAlgVerifierIntf;

type

    (*!------------------------------------------------
     * factory class for TJwtTokenVerifier
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TJwtTokenVerifierFactory = class(TFactory, IDependencyFactory)
    private
        fSecret : string;
        fIssuer : string;
        fMetadataList : IList;
        fAlgorithms : array of IJwtAlgVerifier;
    public
        constructor create();

        function secret(const asecret : string) : TJwtTokenVerifierFactory;
        function issuer(const aissuer : string) : TJwtTokenVerifierFactory;
        function metadata(const ametadata : IList) : TJwtTokenVerifierFactory;
        function algorithms(const algos : array of IJwtAlgVerifier) : TJwtTokenVerifierFactory;

        (*!---------------------------------------
         * build JWT token verifier instance
         *----------------------------------------
         * @param container dependency container
         * @return instance of middleware
         *----------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    HashListImpl,
    JwtTokenVerifierImpl,
    NoneJwtAlgImpl,
    HmacSha256JwtAlgImpl,
    HmacSha384JwtAlgImpl,
    HmacSha512JwtAlgImpl;

    constructor TJwtTokenVerifierFactory.create();
    begin
        fIssuer := '';
        fMetadataList := THashList.create();
        setLength(fAlgorithms, 4);
        fAlgorithms[0] := THmacSha256JwtAlg.create();
        fAlgorithms[1] := TNoneJwtAlg.create();
        fAlgorithms[2] := THmacSha384JwtAlg.create();
        fAlgorithms[3] := THmacSha512JwtAlg.create();
    end;

    function TJwtTokenVerifierFactory.secret(const asecret : string) : TJwtTokenVerifierFactory;
    begin
        fSecret := asecret;
        result := self;
    end;

    function TJwtTokenVerifierFactory.issuer(const aissuer : string) : TJwtTokenVerifierFactory;
    begin
        fIssuer := aissuer;
        result := self;
    end;

    function TJwtTokenVerifierFactory.metadata(const ametadata : IList) : TJwtTokenVerifierFactory;
    begin
        fMetadataList := ametadata;
        result := self;
    end;

    function TJwtTokenVerifierFactory.algorithms(const algos : array of IJwtAlgVerifier) : TJwtTokenVerifierFactory;
    var i : integer;
    begin
        setLength(fAlgorithms, length(algos));
        for i:= low(algos) to high(algos) do
        begin
            fAlgorithms[i] := algos[i];
        end;
        result := self;
    end;

    function TJwtTokenVerifierFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TJwtTokenVerifier.create(
            fMetadataList,
            fIssuer,
            fSecret,
            fAlgorithms
        );
    end;

end.
