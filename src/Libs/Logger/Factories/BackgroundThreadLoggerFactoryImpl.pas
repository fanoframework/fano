{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit BackgroundThreadLoggerFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    LoggerIntf,
    DecoratorFactoryImpl;

type

    (*!------------------------------------------------
     * Factory for TBackgroundThreadLogger
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TBackgroundThreadLoggerFactory = class(TDecoratorFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    BackgroundThreadLoggerImpl;

    function TBackgroundThreadLoggerFactory.build(const container : IDependencyContainer) : IDependency;
    var actualLogger : ILogger;
    begin
        actualLogger := inherited build(container) as ILogger;
        result := TBackgroundThreadLogger.create(actualLogger);
    end;

end.
