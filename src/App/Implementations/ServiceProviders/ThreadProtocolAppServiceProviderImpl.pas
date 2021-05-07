{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit ThreadProtocolAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ProtocolProcessorIntf,
    StdOutIntf,
    DaemonAppServiceProviderIntf,
    ProtocolAppServiceProviderImpl;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories for FastCGI
     * application
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TThreadProtocolAppServiceProvider = class (TProtocolAppServiceProvider)
    private
        fThreadProtocol : IProtocolProcessor;
    public
        constructor create(const actualSvc : IDaemonAppServiceProvider);
        destructor destroy(); override;
        function getProtocol() : IProtocolProcessor; override;
        function getStdOut() : IStdOut; override;
    end;

implementation

uses

    ThreadProtocolProcessorImpl;

    constructor TThreadProtocolAppServiceProvider.create(
        const actualSvc : IDaemonAppServiceProvider
    );
    begin
        inherited create(actualSvc);
        fThreadProtocol := TThreadProtocolProcessor.create(
            fDaemonSvc.getProtocol()
        );
    end;

    destructor TThreadProtocolAppServiceProvider.destroy();
    begin
        fThreadProtocol := nil;
        inherited destroy();
    end;

    function TThreadProtocolAppServiceProvider.getProtocol() : IProtocolProcessor;
    begin
        result := fThreadProtocol;
    end;

    function TThreadProtocolAppServiceProvider.getStdOut() : IStdOut;
    begin
        result := fDaemonSvc.getStdOut();
    end;
end.
