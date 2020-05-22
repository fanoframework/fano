{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit ScgiAppServiceProviderImpl;

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
    TScgiAppServiceProvider = class (TDaemonAppServiceProvider)
    protected
        function buildStdOut(const ctnr : IDependencyContainer) : IStdOut; override;
        function buildProtocol() : IProtocolProcessor; override;
    end;

implementation

uses

    ScgiProcessorImpl,
    ScgiParserImpl,
    ScgiStdOutWriterImpl,
    NonBlockingProtocolProcessorImpl,
    HashListImpl;

    function TScgiAppServiceProvider.buildProtocol() : IProtocolProcessor; override;
    begin
        result := TNonBlockingProtocolProcessor.create(
            TScgiProcessor.create(TScgiParser.create()),
            THashList.create()
        );
    end;

    function TScgiAppServiceProvider.buildStdOut(const ctnr : IDependencyContainer) : IStdOut;
    begin
        result := TScgiStdOutWriter.create();
    end;

end.
