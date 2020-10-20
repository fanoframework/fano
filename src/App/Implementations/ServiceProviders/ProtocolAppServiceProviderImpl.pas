{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit ProtocolAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ProtocolProcessorIntf,
    StdOutIntf,
    DecoratorDaemonAppServiceProviderImpl;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories for FastCGI
     * application
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TProtocolAppServiceProvider = class (TDecoratorDaemonAppServiceProvider)
    protected
        fStdOut : IStdOut;
        fProtocol : IProtocolProcessor;
    public
        destructor destroy(); override;
        function getProtocol() : IProtocolProcessor; override;
        function getStdOut() : IStdOut; override;
    end;

implementation

    destructor TProtocolAppServiceProvider.destroy();
    begin
        fProtocol := nil;
        fStdOut := nil;
        inherited destroy();
    end;

    function TProtocolAppServiceProvider.getProtocol() : IProtocolProcessor;
    begin
        result := fProtocol;
    end;

    function TProtocolAppServiceProvider.getStdOut() : IStdOut;
    begin
        result := fStdOut;
    end;
end.
