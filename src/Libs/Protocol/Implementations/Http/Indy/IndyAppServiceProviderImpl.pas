{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit IndyAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    RunnableWithDataNotifIntf,
    DaemonAppServiceProviderIntf,
    RequestResponseFactoryIntf,
    ProtocolAppServiceProviderImpl,
    FpwebSvrConfigTypes;

type

    {*------------------------------------------------
     * class having capability to
     * register one or more service factories that use
     * TIdHTTPServer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TIndyAppServiceProvider = class (TProtocolAppServiceProvider)
    private
        fLock : TCriticalSection;
        fServer : IRunnableWithDataNotif;
    public
        constructor create(
            const actualSvc : IDaemonAppServiceProvider;
            const svrConfig : TFpwebSvrConfig
        );
        destructor destroy(); override;
        function getServer() : IRunnableWithDataNotif; override;
    end;

implementation

uses

    StdOutIntf,
    ProtocolProcessorIntf,
    RunnableIntf,
    IndyProcessorImpl,
    IndyStdOutWriterImpl,
    ThreadSafeIndyResponseAwareImpl,
    IndyResponseAwareIntf;

    constructor TIndyAppServiceProvider.create(
        const actualSvc : IDaemonAppServiceProvider;
        const svrConfig : TFpwebSvrConfig
    );
    begin
        inherited create(actualSvc);
        fLock := TCriticalSection.create();

        fStdOut := TIndyStdOutWriter.create();
        if svrConfig.threaded then
        begin
            fStdOut := TThreadSafeIndyResponseAware.create(
                fLock,
                fStdOut,
                fStdOut as IIndyResponseAware
            );
        end;

        fProtocol := TIndyProcessor.create(
            fLock,
            fStdOut as IIndyResponseAware,
            svrConfig
        );

        //TIndyProcessor also act as server
        fServer := fProtocol as IRunnableWithDataNotif;
    end;

    destructor TIndyAppServiceProvider.destroy();
    begin
        fServer := nil;
        fStdOut := nil;
        fProtocol := nil;
        fLock.free();
        inherited destroy();
    end;

    function TIndyAppServiceProvider.getServer() : IRunnableWithDataNotif;
    begin
        result := fServer;
    end;

end.
