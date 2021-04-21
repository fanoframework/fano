{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit ThreadSafeMhdAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    RunnableWithDataNotifIntf,
    DaemonAppServiceProviderIntf,
    ProtocolAppServiceProviderImpl,
    MhdSvrConfigTypes;

type

    {*------------------------------------------------
     * class having capability to
     * register one or more service factories that use
     * libmicrohttpd
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    TThreadSafeMhdAppServiceProvider = class (TProtocolAppServiceProvider)
    private
        fServer : IRunnableWithDataNotif;
        fLock : TCriticalSection;
    public
        constructor create(
            const actualSvc : IDaemonAppServiceProvider;
            const svrConfig : TMhdSvrConfig
        );
        destructor destroy(); override;
        function getServer() : IRunnableWithDataNotif; override;
    end;

implementation

uses

    StdOutIntf,
    ProtocolProcessorIntf,
    RunnableIntf,
    MhdConnectionAwareIntf,
    MhdProcessorImpl,
    MhdStdOutWriterImpl,
    ThreadSafeMhdConnectionAwareImpl,
    ThreadSafeProtocolProcessorImpl;

    constructor TThreadSafeMhdAppServiceProvider.create(
        const actualSvc : IDaemonAppServiceProvider;
        const svrConfig : TMhdSvrConfig
    );
    var astdout : IStdOut;
        aConnAware : IMhdConnectionAware;
        aProtocol : IProtocolProcessor;
        aServer : IRunnableWithDataNotif;
    begin
        //create lock before anything
        fLock := TCriticalSection.create();
        inherited create(actualSvc);
        aStdOut := TMhdStdOutWriter.create();
        aConnAware := aStdOut as IMhdConnectionAware;
        fStdOut := TThreadSafeMhdConnectionAware.create(
            fLock,
            aStdOut,
            aConnAware
        );
        aProtocol := TMhdProcessor.create(fStdOut as IMhdConnectionAware, svrConfig);
        //TMhdProcessor also act as server
        aServer := aProtocol as IRunnableWithDataNotif;
        fProtocol := TThreadSafeProtocolProcessor.create(
            fLock,
            aProtocol,
            aServer,
            aServer
        );
        fServer := fProtocol as IRunnableWithDataNotif;
    end;

    destructor TThreadSafeMhdAppServiceProvider.destroy();
    begin
        fServer := nil;
        inherited destroy();
        //destroy lock after anything
        fLock.free();
    end;

    function TThreadSafeMhdAppServiceProvider.getServer() : IRunnableWithDataNotif;
    begin
        result := fServer;
    end;

end.
