{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit FastCgiAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyContainerIntf,
    StdOutIntf,
    DaemonAppServiceProviderIntf,
    DaemonAppServiceProviderImpl;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories for FastCGI
     * application
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TFastCgiAppServiceProvider = class (TDaemonAppServiceProvider)
    protected
        function buildStdOut(const ctnr : IDependencyContainer) : IStdOut; override;
        function buildProtocol() : IProtocolProcessor; override;
    end;

implementation

uses

    FcgiRequestIdAwareIntf,
    FcgiFrameParserFactoryIntf,
    FcgiFrameParserFactoryImpl,
    FcgiProcessorImpl,
    FcgiFrameParserImpl,
    FcgiRequestManagerImpl,
    StreamAdapterCollectionFactoryImpl,
    FcgiStdOutWriterImpl;

    function TFastCgiAppServiceProvider.buildProtocol() : IProtocolProcessor; override;
    var
        aParserFactory : IFcgiFrameParserFactory;
    begin
        aParserFactory := TFcgiFrameParserFactory.create();
        result := TFcgiProcessor.create(
            aParserFactory.build(),
            TFcgiRequestManager.create(TStreamAdapterCollectionFactory.create())
        );
    end;

    function TFastCgiAppServiceProvider.buildStdOut(const ctnr : IDependencyContainer) : IStdOut;
    begin
        result := TFcgiStdOutWriter.create(fProtocol as IFcgiRequestIdAware);
    end;

end.
