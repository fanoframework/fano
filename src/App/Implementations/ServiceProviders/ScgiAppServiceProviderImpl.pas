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
    DaemonAppServiceProviderIntf,
    ProtocolAppServiceProviderImpl;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TScgiAppServiceProvider = class (TProtocolAppServiceProvider)
    protected
        function buildStdOut(const ctnr : IDependencyContainer) : IStdOut; override;
    public
        constructor create(const actualSvc : IDaemonAppServiceProvider);
    end;

implementation

uses

    ScgiProcessorImpl,
    ScgiParserImpl,
    ScgiStdOutWriterImpl,
    NonBlockingProtocolProcessorImpl,
    HashListImpl;

    constructor TScgiAppServiceProvider.create(const actualSvc : IDaemonAppServiceProvider);
    begin
        inherited create(actualSvc);
        fProtocol := TNonBlockingProtocolProcessor.create(
            TScgiProcessor.create(TScgiParser.create()),
            THashList.create()
        );
    end;

    function TScgiAppServiceProvider.buildStdOut(const ctnr : IDependencyContainer) : IStdOut;
    begin
        result := TScgiStdOutWriter.create();
    end;

end.
