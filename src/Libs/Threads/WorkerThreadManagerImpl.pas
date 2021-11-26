{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit WorkerThreadManagerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    SyncObjs,
    fgl,
    RunnableIntf,
    TaskQueueIntf,
    DaemonAppServiceProviderIntf,
    WorkerThreadImpl;

type

    TWorkerThreadList = specialize TFPGObjectList<TWorkerThread>;

    (*!------------------------------------------------
     * class that manage one or more worker thread
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TWorkerThreadManager = class(TInterfacedObject, IRunnable)
    private
        fList : TWorkerThreadList;
        fTaskQueue : ITaskQueue;
        fSvcProviders : array of IDaemonAppServiceProvider;

        procedure terminateThreads();
        procedure waitThreads();
        procedure cleanupThreads();
    public
        constructor create(
            const taskQueue : ITaskQueue;
            const svcProviders : array of IDaemonAppServiceProvider
        );
        destructor destroy(); override;
        function run() : IRunnable;
    end;

implementation

    constructor TWorkerThreadManager.create(
        const taskQueue : ITaskQueue;
        const svcProviders : array of IDaemonAppServiceProvider
    );
    var i : integer;
    begin
        fList := TWorkerThreadList.create();
        fTaskQueue := taskQueue;
        setLength(fSvcProviders, length(svcProviders));
        for i:= low(svcProviders) to high(svcProviders) do
        begin
            fSvcProviders[i] := svcProviders[i];
        end;
    end;

    destructor TWorkerThreadManager.destroy();
    begin
        terminateThreads();
        waitThreads();
        cleanupThreads();
        fTaskQueue := nil;
        inherited destroy();
    end;

    procedure TWorkerThreadManager.waitThreads();
    var threadIdx : integer;
    begin
        for threadIdx := 0 to fList.count-1 do
        begin
            fList[threadIdx].waitFor();
        end;
    end;

    procedure TWorkerThreadManager.cleanupThreads();
    var threadIdx : integer;
    begin
        for threadIdx := fList.count-1 downto 0 do
        begin
            fList[threadIdx].free();
            fList.delete(threadIdx);
        end;
    end;

    procedure TWorkerThreadManager.terminateThreads();
    var threadIdx : integer;
    begin
        for threadIdx := 0 to fList.count-1 do
        begin
            fList[threadIdx].terminate();
        end;
    end;

    function TWorkerThreadManager.run() : IRunnable;
    var threadIdx : integer;
    begin
        for threadIdx := 0 to length(fSvcProviders) - 1 do
        begin
            fList.add(TWorkerThread.create(fTaskQueue, fSvcProviders[threadIdx].protocol));
        end;
        result := self;
    end;
end.
