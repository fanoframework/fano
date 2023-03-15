{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RdbmsPoolFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    RdbmsPoolIntf,
    RdbmsFactoryIntf,
    FactoryImpl;


type

    (*!------------------------------------------------
     * Factory class for TRdbmsPool class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TRdbmsPoolFactory = class(TFactory)
    private
        fDbFactory : IRdbmsFactory;
        fPoolSize : integer;
    public

        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param rdbmsFactory factory class responsible to create IRdbms instance
         * @param poolSize number of IRdbms instnce in pool
         *-------------------------------------------------*)
        constructor create(
            const rdbmsFactory : IRdbmsFactory;
            const poolSize : integer
        );
        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *---------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;

    end;

implementation

uses

    RdbmsPoolImpl;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param rdbmsFactory factory class responsible to create IRdbms instance
     * @param poolSize number of IRdbms instnce in pool
     *-------------------------------------------------*)
    constructor TRdbmsPoolFactory.create(
        const rdbmsFactory : IRdbmsFactory;
        const poolSize : integer
    );
    begin
        fDbFactory := rdbmsFactory;
        fPoolSize := poolSize;
    end;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TRdbmsPoolFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TRdbmsPool.create(fDbFactory, fPoolSize) as IDependency;
    end;

end.
