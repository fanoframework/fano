{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ScryptPasswordHashFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TScryptPasswordHash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TScryptPasswordHashFactory = class(TFactory, IDependencyFactory)
    private
        fSalt : string;
        fCost : integer;
        fLen : integer;
        fBlockSize : integer;
        fParallel : integer;
    public
        constructor create();
        function salt(const asalt : string) : TScryptPasswordHashFactory;
        function cost(const acost : integer) : TScryptPasswordHashFactory;
        function len(const alen : integer) : TScryptPasswordHashFactory;
        function block(const ablock : integer) : TScryptPasswordHashFactory;
        function paralleism(const aparallel : integer) : TScryptPasswordHashFactory;

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

    ScryptPasswordHashImpl;

    constructor TScryptPasswordHashFactory.create();
    begin
        //set default values
        fSalt := '';
        fCost := 1024;
        fLen := 64;
        fBlockSize := 8;
        fParallel := 1;
    end;

    function TScryptPasswordHashFactory.salt(const asalt : string) : TScryptPasswordHashFactory;
    begin
        fSalt := asalt;
        result := self;
    end;

    function TScryptPasswordHashFactory.cost(const acost : integer) : TScryptPasswordHashFactory;
    begin
        fCost := acost;
        result := self;
    end;

    function TScryptPasswordHashFactory.len(const alen : integer) : TScryptPasswordHashFactory;
    begin
        fLen := alen;
        result := self;
    end;

    function TScryptPasswordHashFactory.block(const ablock : integer) : TScryptPasswordHashFactory;
    begin
        fBlockSize := ablock;
        result := self;
    end;

    function TScryptPasswordHashFactory.paralleism(const aparallel : integer) : TScryptPasswordHashFactory;
    begin
        fParallel := aparallel;
        result := self;
    end;

    function TScryptPasswordHashFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TScryptPasswordHash.create(
            fSalt,
            fCost,
            fLen,
            fBlockSize,
            fParallel
        );
    end;

end.
