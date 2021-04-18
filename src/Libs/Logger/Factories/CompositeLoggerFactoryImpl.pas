{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit CompositeLoggerFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type
    {------------------------------------------------
     factory class for TCompositeLogger

     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    TCompositeLoggerFactory = class(TFactory, IDependencyFactory)
    private
        firstFactory : IDependencyFactory;
        secondFactory : IDependencyFactory;
    public
        constructor create(
            const logger1Factory : IDependencyFactory;
            const logger2Factory : IDependencyFactory
        );
        destructor destroy(); override;

        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    LoggerIntf,
    CompositeLoggerImpl;

    constructor TCompositeLoggerFactory.create(
        const logger1Factory : IDependencyFactory;
        const logger2Factory : IDependencyFactory
    );
    begin
        firstFactory := logger1Factory;
        secondFactory := logger2Factory;
    end;

    destructor TCompositeLoggerFactory.destroy();
    begin
        inherited destroy();
        firstFactory := nil;
        secondFactory := nil;
    end;

    function TCompositeLoggerFactory.build(const container : IDependencyContainer) : IDependency;
    var logger1, logger2 : ILogger;
    begin
        logger1 := firstFactory.build(container) as ILogger;
        logger2 := secondFactory.build(container) as ILogger;
        result := TCompositeLogger.create([logger1, logger2]);
    end;

end.
