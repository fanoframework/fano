{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/zamronypj/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/zamronypj/fano/blob/master/LICENSE (GPL 3.0)
 *}
unit NullLoggerFactoryImpl;

interface

{$MODE OBJFPC}

uses
    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type
    {------------------------------------------------
     factory class for TNullLogger

     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    TNullLoggerFactory = class(TFactory, IDependencyFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses
    NullLoggerImpl;

    function TNullLoggerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TNullLogger.create();
    end;

end.
