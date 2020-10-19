{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JwtTokenGeneratorFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    JwtAlgSignerIntf;

type

    (*!------------------------------------------------
     * factory class for TJwtTokenGenerator
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TJwtTokenGeneratorFactory = class(TFactory, IDependencyFactory)
    private
        fSecret : string;
        fAlgorithm : IJwtAlgSigner;
    public
        constructor create();

        function secret(const asecret : string) : TJwtTokenGeneratorFactory;
        function algorithm(const algo : IJwtAlgSigner) : TJwtTokenGeneratorFactory;

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

    JwtTokenGeneratorImpl;

    constructor TJwtTokenGeneratorFactory.create();
    begin
        fSecret := '';
        fAlgorithm := nil;
    end;

    function TJwtTokenGeneratorFactory.secret(const asecret : string) : TJwtTokenGeneratorFactory;
    begin
        fSecret := asecret;
        result := self;
    end;

    function TJwtTokenGeneratorFactory.algorithm(const algo : IJwtAlgSigner) : TJwtTokenGeneratorFactory;
    begin
        fAlgorithm := algo;
        result := self;
    end;

    function TJwtTokenGeneratorFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TJwtTokenGenerator.create(
            fSecret,
            fAlgorithm
        );
    end;

end.
