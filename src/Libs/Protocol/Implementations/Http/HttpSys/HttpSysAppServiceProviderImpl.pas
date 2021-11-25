{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit HttpSysAppServiceProviderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    RunnableWithDataNotifIntf,
    DaemonAppServiceProviderIntf,
    ProtocolAppServiceProviderImpl,
    HttpSysSvrConfigTypes;

type

    {*------------------------------------------------
     * class having capability to
     * register one or more service factories that use
     * libmicrohttpd
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    THttpSysAppServiceProvider = class (TProtocolAppServiceProvider)
    private
        fServer : IRunnableWithDataNotif;
        fLock : TCriticalSection;
    public
        constructor create(
            const actualSvc : IDaemonAppServiceProvider;
            const svrConfig : THttpSysSvrConfig
        );
        destructor destroy(); override;
        function getServer() : IRunnableWithDataNotif; override;
    end;

implementation

uses

    StdOutIntf,
    ProtocolProcessorIntf,
    RunnableIntf,
    HttpSysConnectionAwareIntf,
    HttpSysProcessorImpl,
    HttpSysStdOutWriterImpl,
    ThreadSafeHttpSysConnectionAwareImpl,
    ThreadSafeProtocolProcessorImpl;

    constructor THttpSysAppServiceProvider.create(
        const actualSvc : IDaemonAppServiceProvider;
        const svrConfig : THttpSysSvrConfig
    );
    var astdout : IStdOut;
        aConnAware : IHttpSysConnectionAware;
    begin
        //create lock before anything
        fLock := TCriticalSection.create();
        inherited create(actualSvc);
        aStdOut := THttpSysStdOutWriter.create();
        aConnAware := aStdOut as IHttpSysConnectionAware;
        fStdOut := TThreadSafeHttpSysConnectionAware.create(
            fLock,
            aStdOut,
            aConnAware
        );
        fProtocol := THttpSysProcessor.create(
            fLock,
            fStdOut as IHttpSysConnectionAware,
            svrConfig
        );
        //THttpSysProcessor also act as server
        fServer := fProtocol as IRunnableWithDataNotif;
    end;

    destructor THttpSysAppServiceProvider.destroy();
    begin
        fServer := nil;
        inherited destroy();
        //destroy lock after anything
        fLock.free();
    end;

    function THttpSysAppServiceProvider.getServer() : IRunnableWithDataNotif;
    begin
        result := fServer;
    end;

end.
