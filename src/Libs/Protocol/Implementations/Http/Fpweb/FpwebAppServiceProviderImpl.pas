{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit FpwebAppServiceProviderImpl;

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
     * TFPHttpServer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TFpwebAppServiceProvider = class (TProtocolAppServiceProvider)
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
    FpwebProcessorImpl,
    FpwebStdOutWriterImpl,
    ThreadSafeFpwebResponseAwareImpl,
    FpwebResponseAwareIntf;

    constructor TFpwebAppServiceProvider.create(
        const actualSvc : IDaemonAppServiceProvider;
        const svrConfig : TFpwebSvrConfig
    );
    begin
        inherited create(actualSvc);
        fLock := TCriticalSection.create();

        fStdOut := TFpwebStdOutWriter.create();
        if svrConfig.threaded then
        begin
            fStdOut := TThreadSafeFpWebResponseAware.create(
                fLock,
                fStdOut,
                fStdOut as IFpwebResponseAware
            );
        end;

        fProtocol := TFpwebProcessor.create(
            fLock,
            fStdOut as IFpwebResponseAware,
            svrConfig
        );

        //TFpwebProcessor also act as server
        fServer := fProtocol as IRunnableWithDataNotif;
    end;

    destructor TFpwebAppServiceProvider.destroy();
    begin
        fServer := nil;
        fStdOut := nil;
        fProtocol := nil;
        fLock.free();
        inherited destroy();
    end;

    function TFpwebAppServiceProvider.getServer() : IRunnableWithDataNotif;
    begin
        result := fServer;
    end;

end.
