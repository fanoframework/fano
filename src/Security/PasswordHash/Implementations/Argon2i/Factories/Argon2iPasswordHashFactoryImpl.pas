{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Argon2iPasswordHashFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TArgon2iPasswordHash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TArgon2iPasswordHashFactory = class(TFactory, IDependencyFactory)
    private
        fSecret : string;
        fSalt : string;
        fCost : integer;
        fLen : integer;
        fMemAsKb : integer;
        fParallel : integer;
    public

        constructor create();
        function secret(const asecret : string) : TArgon2iPasswordHashFactory;
        function salt(const asalt : string) : TArgon2iPasswordHashFactory;
        function cost(const acost : integer) : TArgon2iPasswordHashFactory;
        function len(const alen : integer) : TArgon2iPasswordHashFactory;
        function memory(const amem : integer) : TArgon2iPasswordHashFactory;
        function paralleism(const aparallel : integer) : TArgon2iPasswordHashFactory;

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

    Argon2iPasswordHashImpl;

    constructor TArgon2iPasswordHashFactory.create();
    begin
        //set default values
        fSecret := '';
        fSalt := '';
        fCost := 10;
        fLen := 64;
        fMemAsKb := 32;
        fParallel := 4;
    end;

    function TArgon2iPasswordHashFactory.secret(const asecret : string) : TArgon2iPasswordHashFactory;
    begin
        fSecret := asecret;
        result := self;
    end;

    function TArgon2iPasswordHashFactory.salt(const asalt : string) : TArgon2iPasswordHashFactory;
    begin
        fSalt := asalt;
        result := self;
    end;

    function TArgon2iPasswordHashFactory.cost(const acost : integer) : TArgon2iPasswordHashFactory;
    begin
        fCost := acost;
        result := self;
    end;

    function TArgon2iPasswordHashFactory.len(const alen : integer) : TArgon2iPasswordHashFactory;
    begin
        fLen := alen;
        result := self;
    end;

    function TArgon2iPasswordHashFactory.memory(const amem : integer) : TArgon2iPasswordHashFactory;
    begin
        fMemAsKb := amem;
        result := self;
    end;

    function TArgon2iPasswordHashFactory.paralleism(const aparallel : integer) : TArgon2iPasswordHashFactory;
    begin
        fParallel := aparallel;
        result := self;
    end;

    function TArgon2iPasswordHashFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TArgon2iPasswordHash.create(
            fSecret,
            fSalt,
            fCost,
            fLen,
            fMemAsKb,
            fParallel
        );
    end;

end.
