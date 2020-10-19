{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Sha2PasswordHashFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    TSha2Type = (st256, st512);

    (*!------------------------------------------------
     * factory class for TArgon2iPasswordHash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TSha2PasswordHashFactory = class(TFactory, IDependencyFactory)
    private
        fSha2Type : TSha2Type;
    public
        constructor create();

        function use256() : TSha2PasswordHashFactory;
        function use512() : TSha2PasswordHashFactory;

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

    Sha2_256PasswordHashImpl,
    Sha2_512PasswordHashImpl;

    constructor TSha2PasswordHashFactory.create();
    begin
        fSha2Type := st256;
    end;

    function TSha2PasswordHashFactory.use256() : TSha2PasswordHashFactory;
    begin
        fSha2Type := st256;
        result := self;
    end;

    function TSha2PasswordHashFactory.use512() : TSha2PasswordHashFactory;
    begin
        fSha2Type := st512;
        result := self;
    end;

    function TSha2PasswordHashFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        case fSha2Type of
            st256 : result := TSha2_256PasswordHash.create();
            st512 : result := TSha2_512PasswordHash.create();
            else
                result := TSha2_256PasswordHash.create();
        end;
    end;

end.
