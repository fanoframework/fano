{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Argon2iPasswordHashFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    RequestHandlerIntf;

type

    (*!------------------------------------------------
     * factory class for TArgon2iPasswordHash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TArgon2iPasswordHashFactory = class(TFactory, IDependencyFactory)
    private
        fSecret : string;
    public
        function secret(const asecret : string) : TArgon2iPasswordHashFactory;
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

    function TArgon2iPasswordHashFactory.secret(const asecret : string) : TArgon2iPasswordHashFactory;
    begin
        fSecret := asecret;
        result := self;
    end;

    function TArgon2iPasswordHashFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TArgon2iPasswordHash.create(fSecret);
    end;

end.
