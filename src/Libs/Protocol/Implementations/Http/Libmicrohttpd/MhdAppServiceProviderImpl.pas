{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit MhdAppServiceProviderImpl;

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
    TMhdAppServiceProvider = class (TProtocolAppServiceProvider)
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

    constructor TMhdAppServiceProvider.create(
        const actualSvc : IDaemonAppServiceProvider;
        const svrConfig : TMhdSvrConfig
    );
    var astdout : IStdOut;
        aConnAware : IMhdConnectionAware;
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
        fProtocol := TMhdProcessor.create(
            fLock,
            fStdOut as IMhdConnectionAware,
            svrConfig
        );
        //TMhdProcessor also act as server
        fServer := fProtocol as IRunnableWithDataNotif;
    end;

    destructor TMhdAppServiceProvider.destroy();
    begin
        fServer := nil;
        inherited destroy();
        //destroy lock after anything
        fLock.free();
    end;

    function TMhdAppServiceProvider.getServer() : IRunnableWithDataNotif;
    begin
        result := fServer;
    end;

end.
