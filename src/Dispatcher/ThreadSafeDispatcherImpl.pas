{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeDispatcherImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    EnvironmentIntf,
    StdInIntf,
    ResponseIntf,
    DispatcherIntf,
    DecoratorDispatcherImpl;

type

    (*!---------------------------------------------------
     * Decorator dispatcher class having capability dispatch
     * request using external dispatcher
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TThreadSafeDispatcher = class (TDecoratorDispatcher)
    private
        fCriticalSection : TCriticalSection;
    public
        constructor create(const actualDispatcher : IDispatcher);
        destructor destroy(); override;

        (*!-------------------------------------------
         * dispatch request
         *--------------------------------------------
         * @param env CGI environment
         * @param stdIn STDIN reader
         * @return response
         *--------------------------------------------*)
        function dispatchRequest(
            const env: ICGIEnvironment;
            const stdIn : IStdIn
        ) : IResponse; override;
    end;

implementation

uses

    ThreadSafeEnvironmentImpl,
    ThreadSafeStdInImpl;

    constructor TThreadSafeDispatcher.create(const actualDispatcher : IDispatcher);
    begin
        inherited create(actualDispatcher);
        fCriticalSection := TCriticalSection.create();
    end;

    destructor TThreadSafeDispatcher.destroy();
    begin
        fCriticalSection.free();
        inherited destroy();
    end;

    (*!-------------------------------------------
     * dispatch request
     *--------------------------------------------
     * @param env CGI environment
     * @param stdIn STDIN reader
     * @return response
     *--------------------------------------------*)
    function TThreadSafeDispatcher.dispatchRequest(
        const env: ICGIEnvironment;
        const stdIn : IStdIn
    ) : IResponse;
    var threadSafeEnv : ICGIEnvironment;
        threadSafeStdIn : IStdIn;
    begin
        fCriticalSection.acquire();
        try
            threadSafeEnv := TThreadSafeEnvironment.create(env);
            try
                threadSafeStdIn := TThreadSafeStdIn.create(stdIn);
                try
                    result := inherited dispatchRequest(
                        threadSafeEnv,
                        threadSafeStdIn
                    );
                finally
                    threadSafeStdIn := nil;
                end;
            finally
                threadSafeEnv := nil;
            end;
        finally
            fCriticalSection.release();
        end;
    end;
end.
