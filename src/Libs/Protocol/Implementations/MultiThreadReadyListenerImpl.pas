{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MultiThreadReadyListenerIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    EnvironmentIntf,
    StreamAdapterIntf,
    DecoratorReadyListenerImpl;

type

    (*!-----------------------------------------------
     * decorator class having capability to be notified
     * when request is complete and ready to be served
     * it then calls actual listener inside background
     * thread
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMultiThreadReadyListener = class (TDecoratorReadyListener)
    public
        (*!------------------------------------------------
         * request is ready
         *-----------------------------------------------
         * @param socketStream, original socket stream
         * @param env, CGI environment
         * @param stdInStream, stream contains parsed POST-ed data
         * @return true request is handled
         *-----------------------------------------------*)
        function ready(
            const socketStream : IStreamAdapter;
            const env : ICGIEnvironment;
            const stdInStream : IStreamAdapter
        ) : boolean; override;

    end;

implementation

uses

    Classes;

type

     (*!-----------------------------------------------
     * internal thread that calls actual listener
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TReadyThread = class (TThread)
    private
        fSocketStream : IStreamAdapter;
        fEnv : ICGIEnvironment;
        fStdInStream : IStreamAdapter;
        fActualListener : IReadyListener;
    public
        constructor create(
            const socketStream : IStreamAdapter;
            const env : ICGIEnvironment;
            const stdInStream : IStreamAdapter;
            const actualListener : IReadyListener
        );
        destructor destroy(); override;
        procedure execute();
    end;

    constructor TReadyThread.create(
        const socketStream : IStreamAdapter;
        const env : ICGIEnvironment;
        const stdInStream : IStreamAdapter;
        const actualListener : IReadyListener
    );
    const SUSPENDED_THREAD = true;
    begin
        inherited create(SUSPENDED_THREAD);
        fSocketStream := socketStream;
        fEnv := env;
        fStdInStream := stdInStream;
        fActualListener := actualListener;
        //let thread clean up itself
        FreeOnTerminate := true;
    end;

    destructor TReadyThread.destroy();
    begin
        fSocketStream := nil;
        fEnv := nil;
        fStdInStream := nil;
        fActualListener := nil;
        inherited destroy();
    end;

    procedure TReadyThread.execute();
    begin
        result := fActualListener.ready(fSocketStream, fEnv, fStdInStream);
    end;

    (*!------------------------------------------------
     * request is ready
     *-----------------------------------------------
     * @param socketStream, original socket stream
     * @param env, CGI environment
     * @param stdInStream, stream contains parsed POST-ed data
     * @return true request is handled
     *-----------------------------------------------*)
    function TMultiThreadReadyListener.ready(
        const socketStream : IStreamAdapter;
        const env : ICGIEnvironment;
        const stdInStream : IStreamAdapter
    ) : boolean;
    var executorThread : TReadyThread;
    begin
        executorThread := TReadyThread.create(
            socketStream,
            env,
            stdInStream,
            fActualListener
        );
        executorThread.start();
    end;

end.
