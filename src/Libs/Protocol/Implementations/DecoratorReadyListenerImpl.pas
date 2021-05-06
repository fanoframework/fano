{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorReadyListenerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EnvironmentIntf,
    StreamAdapterIntf,
    ReadyListenerIntf;

type

    (*!-----------------------------------------------
     * decorator class having capability to be notified
     * when request is complete and ready to be served
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDecoratorReadyListener = class (TInterfacedObject, IReadyListener)
    protected
        fActualListener : IReadyListener;
    public
        constructor create(const actualListener : IReadyListener);

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
        ) : boolean; virtual;

    end;

implementation

    constructor TDecoratorReadyListener.create(const actualListener : IReadyListener);
    begin
        fActualListener := actualListener;
    end;

    (*!------------------------------------------------
     * request is ready
     *-----------------------------------------------
     * @param socketStream, original socket stream
     * @param env, CGI environment
     * @param stdInStream, stream contains parsed POST-ed data
     * @return true request is handled
     *-----------------------------------------------*)
    function TDecoratorReadyListener.ready(
        const socketStream : IStreamAdapter;
        const env : ICGIEnvironment;
        const stdInStream : IStreamAdapter
    ) : boolean;
    begin
        result := fActualListener.ready(socketStream, env, stdInStream);
    end;
end.
