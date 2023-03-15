{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit UwsgiAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DaemonAppServiceProviderIntf,
    ProtocolAppServiceProviderImpl;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TUwsgiAppServiceProvider = class (TProtocolAppServiceProvider)
    public
        constructor create(const actualSvc : IDaemonAppServiceProvider);
    end;

implementation

uses

    UwsgiProcessorImpl,
    UwsgiParserImpl,
    UwsgiStdOutWriterImpl,
    NonBlockingProtocolProcessorImpl,
    HashListImpl;

    constructor TUwsgiAppServiceProvider.create(const actualSvc : IDaemonAppServiceProvider);
    begin
        inherited create(actualSvc);
        fProtocol := TNonBlockingProtocolProcessor.create(
            TUwsgiProcessor.create(TUwsgiParser.create()),
            THashList.create()
        );
        fStdOut := TUwsgiStdOutWriter.create();
    end;

end.
