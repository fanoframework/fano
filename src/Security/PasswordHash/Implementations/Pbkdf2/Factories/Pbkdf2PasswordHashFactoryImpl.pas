{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Pbkdf2PasswordHashFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    THashFunc = (
        hfSHA1,
        hfSHA2_256,
        hfSHA2_384,
        hfSHA2_512,
        hfSHA3_256,
        hfSHA3_384,
        hfSHA3_512
    );

    (*!------------------------------------------------
     * factory class for TPbkdf2PasswordHash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TPbkdf2PasswordHashFactory = class(TFactory, IDependencyFactory)
    private
        fHashFunc : THashFunc;
        fSalt : string;
        fCost : integer;
        fLen : integer;
    public
        constructor create(const hf : THashFunc = hfSHA1);
        function withHash(const hf : THashFunc) : TPbkdf2PasswordHashFactory;

        function salt(const asalt : string) : TPbkdf2PasswordHashFactory;
        function cost(const acost : integer) : TPbkdf2PasswordHashFactory;
        function len(const alen : integer) : TPbkdf2PasswordHashFactory;

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

    HlpIHash,
    HlpHashFactory,
    Pbkdf2PasswordHashImpl,
    EPasswordHashImpl;

    constructor TPbkdf2PasswordHashFactory.create(const hf : THashFunc = hfSHA1);
    begin
        //set default values
        fHashFunc := hf;
        fSalt := '';
        fCost := 1000;
        fLen := 64;
    end;

    function TPbkdf2PasswordHashFactory.withHash(const hf : THashFunc) : TPbkdf2PasswordHashFactory;
    begin
        fHashFunc := hf;
        result := self;
    end;

    function buildHash(const hf : THashFunc) : IHash;
    begin
        case hf of
            hfSHA1 : result := THashFactory.TCrypto.CreateSHA1();
            hfSHA2_256 : result:= THashFactory.TCrypto.CreateSHA2_256();
            hfSHA2_384 : result:= THashFactory.TCrypto.CreateSHA2_384();
            hfSHA2_512 : result:= THashFactory.TCrypto.CreateSHA2_512();
            hfSHA3_256 : result:= THashFactory.TCrypto.CreateSHA3_256();
            hfSHA3_384 : result:= THashFactory.TCrypto.CreateSHA3_384();
            hfSHA3_512 : result:= THashFactory.TCrypto.CreateSHA3_512();
        else
            raise EPasswordHash.create('Unknown hash function');
        end;
    end;

    function TPbkdf2PasswordHashFactory.salt(const asalt : string) : TPbkdf2PasswordHashFactory;
    begin
        fSalt := asalt;
        result := self;
    end;

    function TPbkdf2PasswordHashFactory.cost(const acost : integer) : TPbkdf2PasswordHashFactory;
    begin
        fCost := acost;
        result := self;
    end;

    function TPbkdf2PasswordHashFactory.len(const alen : integer) : TPbkdf2PasswordHashFactory;
    begin
        fLen := alen;
        result := self;
    end;

    function TPbkdf2PasswordHashFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TPbkdf2PasswordHash.create(buildHash(fHashFunc));
    end;

end.
