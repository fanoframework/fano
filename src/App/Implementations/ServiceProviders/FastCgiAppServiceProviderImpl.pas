{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit FastCgiAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

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
    TFastCgiAppServiceProvider = class (TProtocolAppServiceProvider)
    public
        constructor create(const actualSvc : IDaemonAppServiceProvider);
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

    constructor TFastCgiAppServiceProvider.create(const actualSvc : IDaemonAppServiceProvider);
    var
        aParserFactory : IFcgiFrameParserFactory;
    begin
        inherited create(actualSvc);
        aParserFactory := TFcgiFrameParserFactory.create();
        fProtocol := TFcgiProcessor.create(
            aParserFactory.build(),
            TFcgiRequestManager.create(TStreamAdapterCollectionFactory.create())
        );
        fStdOut := TFcgiStdOutWriter.create(fProtocol as IFcgiRequestIdAware);
    end;

end.
