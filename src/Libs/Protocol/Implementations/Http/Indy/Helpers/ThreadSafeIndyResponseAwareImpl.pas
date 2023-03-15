{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeIndyResponseAwareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    fphttpserver,
    SyncObjs,
    StdOutIntf,
    IndyResponseAwareIntf,
    ThreadSafeStdOutImpl,
    StreamAdapterIntf,

    IdCustomHTTPServer;

type

    (*!------------------------------------------------
     * IStdOut implementation class TFpHttpServer response
     * instance in thread-safe way
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeIndyResponseAware = class(TThreadSafeStdOut, IIndyResponseAware)
    private
        fActualResponseAware : IIndyResponseAware;
    public
        constructor create(
            const lock : TCriticalSection;
            const actualStdOut : IStdOut;
            const actualResponseAware : IIndyResponseAware
        );

        (*!------------------------------------------------
         * get TFpHttpServer response connection
         *-----------------------------------------------
         * @return connection
         *-----------------------------------------------*)
        function getResponse() : TIdHTTPResponseInfo;

        (*!------------------------------------------------
         * set TFpHttpServer response connection
         *-----------------------------------------------*)
        procedure setResponse(aresponse : TIdHTTPResponseInfo);

        property response : TIdHTTPResponseInfo read getResponse write setResponse;
    end;

implementation

    constructor TThreadSafeIndyResponseAware.create(
        const lock : TCriticalSection;
        const actualStdOut : IStdOut;
        const actualResponseAware : IIndyResponseAware
    );
    begin
        inherited create(lock, actualStdOut);
        fActualResponseAware := actualResponseAware;
    end;

    (*!------------------------------------------------
     * get TIdHTTPServer response connection
     *-----------------------------------------------
     * @return connection
     *-----------------------------------------------*)
    function TThreadSafeIndyResponseAware.getResponse() : TIdHTTPResponseInfo;
    begin
        fLock.acquire();
        try
            result := fActualResponseAware.getResponse();
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * set TIdHTTPServer response connection
     *-----------------------------------------------*)
    procedure TThreadSafeIndyResponseAware.setResponse(aresponse : TIdHTTPResponseInfo);
    begin
        fLock.acquire();
        try
            fActualResponseAware.setResponse(aresponse);
        finally
            fLock.release();
        end;
    end;

end.
