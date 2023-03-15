{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FileLoggerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type
    {------------------------------------------------
     factory class for TFileLogger

     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    TFileLoggerFactory = class(TFactory, IDependencyFactory)
    private
        logFile : string;
    public
        constructor create(const filename : string);
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses
    FileLoggerImpl;

    constructor TFileLoggerFactory.create(const filename : string);
    begin
        logFile := filename;
    end;

    function TFileLoggerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TFileLogger.create(logFile);
    end;

end.
