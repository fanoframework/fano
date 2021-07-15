{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit StdOutLoggerFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type
    {------------------------------------------------
     factory class for TStdOutLogger

     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    TStdOutLoggerFactory = class(TFactory, IDependencyFactory)
    private
        fStdOut : text;
    public
        constructor create(var aStdout : text); overload;
        constructor create(); overload;
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    StdOutLoggerImpl;

    constructor TStdOutLoggerFactory.create(var aStdout : text);
    begin
        fStdOut := aStdout;
    end;

    constructor TStdOutLoggerFactory.create();
    begin
        create(StdOut);
    end;

    function TStdOutLoggerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TStdOutLogger.create(fStdOut);
    end;

end.
