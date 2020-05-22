{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit UwsgiAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyContainerIntf,
    StdOutIntf,
    ProtocolProcessorIntf,
    DaemonAppServiceProviderIntf,
    DaemonAppServiceProviderImpl;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TUwsgiAppServiceProvider = class (TProtocolAppServiceProvider)
    protected
        function buildStdOut(const ctnr : IDependencyContainer) : IStdOut; override;
        function buildProtocol() : IProtocolProcessor; override;
    end;

implementation

uses

    UwsgiProcessorImpl,
    UwsgiParserImpl,
    UwsgiStdOutWriterImpl,
    NonBlockingProtocolProcessorImpl,
    HashListImpl;

    function TUwsgiAppServiceProvider.buildProtocol() : IProtocolProcessor; override;
    begin
        result := TNonBlockingProtocolProcessor.create(
            TUwsgiProcessor.create(TUwsgiParser.create()),
            THashList.create()
        );
    end;

    function TUwsgiAppServiceProvider.buildStdOut(const ctnr : IDependencyContainer) : IStdOut;
    begin
        result := TUwsgiStdOutWriter.create();
    end;

end.
