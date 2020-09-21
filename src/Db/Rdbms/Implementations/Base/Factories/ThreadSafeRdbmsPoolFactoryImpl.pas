{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeRdbmsPoolFactoryImpl;

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
     * Factory class for ThreadSafeRdbmsPool class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TThreadSafeRdbmsPoolFactory = class(TFactory)
    private
        fDbPoolFactory : IDependencyFactory;
    public

        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param poolFactory factory class responsible to create actual pool
         *-------------------------------------------------*)
        constructor create(const poolFactory : IDependencyFactory);

        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *---------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;

    end;

implementation

uses

    ThreadSafeRdbmsPoolImpl;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param poolFactory factory class responsible to create actual pool
     *-------------------------------------------------*)
    constructor TThreadSafeRdbmsPoolFactory.create(
        const poolFactory : IDependencyFactory
    );
    begin
        fDbPoolFactory := poolFactory;
    end;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TThreadSafeRdbmsPoolFactory.build(const container : IDependencyContainer) : IDependency;
    var pool : IRdbmsPool;
    begin
        pool := fDbPoolFactory.build(container) as IRdbmsPool;
        result := TThreadSafeRdbmsPool.create(pool) as IDependency;
    end;

end.
