{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BcryptPasswordHashFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    BCryptTypes,
    BCryptConsts;

type

    (*!------------------------------------------------
     * factory class for TBcryptPasswordHash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TBcryptPasswordHashFactory = class(TFactory, IDependencyFactory)
    private
        fCost : byte;
        fHashType : THashType;
    public
        constructor create();
        function cost(aCost : byte) : TBcryptPasswordHashFactory;

        function hashType(aType : THashType) : TBcryptPasswordHashFactory;

        (*!---------------------------------------
         * build password hash instance
         *----------------------------------------
         * @param container dependency container
         * @return instance of middleware
         *----------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    BcryptPasswordHashImpl;

    constructor TBcryptPasswordHashFactory.create();
    begin
        fHashType := BSD;
        fCost := BCRYPT_DEFAULT_COST;
    end;

    function TBcryptPasswordHashFactory.cost(aCost : byte) : TBcryptPasswordHashFactory;
    begin
        fCost := aCost;
        result := self;
    end;

    function TBcryptPasswordHashFactory.hashType(aType : THashType) : TBcryptPasswordHashFactory;
    begin
        fHashType := aType;
        result := self;
    end;

    function TBcryptPasswordHashFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TBcryptPasswordHash.create(fHashType, fCost);
    end;

end.
