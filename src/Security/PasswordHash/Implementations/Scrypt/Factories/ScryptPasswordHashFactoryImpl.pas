{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ScryptPasswordHashFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    RequestHandlerIntf;

type
    THashFunc = (hfSHA1,
        hfSHA2_256, hfSHA2_384, hfSHA2_512,
        hfSHA3_256, hfSHA3_384, hfSHA3_512
    );

    (*!------------------------------------------------
     * factory class for TPbkdf2PasswordHash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TScryptPasswordHashFactory = class(TFactory, IDependencyFactory)
    public

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

    function TScryptPasswordHashFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TScryptPasswordHash.create();
    end;

end.
