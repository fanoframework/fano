{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeFpWebResponseAwareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    fphttpserver,
    SyncObjs,
    StdOutIntf,
    FpwebResponseAwareIntf,
    ThreadSafeStdOutImpl,
    StreamAdapterIntf;

type

    (*!------------------------------------------------
     * IStdOut implementation class TFpHttpServer response
     * instance in thread-safe way
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeFpwebResponseAware = class(TThreadSafeStdOut, IFpwebResponseAware)
    private
        fActualResponseAware : IFpwebResponseAware;
    public
        constructor create(
            const lock : TCriticalSection;
            const actualStdOut : IStdOut;
            const actualResponseAware : IFpwebResponseAware
        );

        (*!------------------------------------------------
         * get TFpHttpServer response connection
         *-----------------------------------------------
         * @return connection
         *-----------------------------------------------*)
        function getResponse() : TFPHTTPConnectionResponse;

        (*!------------------------------------------------
         * set TFpHttpServer response connection
         *-----------------------------------------------*)
        procedure setResponse(aresponse : TFPHTTPConnectionResponse);

    end;

implementation

    constructor TThreadSafeFpwebResponseAware.create(
        const lock : TCriticalSection;
        const actualStdOut : IStdOut;
        const actualResponseAware : IFpwebResponseAware
    );
    begin
        inherited create(lock, actualStdOut);
        fActualResponseAware := actualResponseAware;
    end;

    (*!------------------------------------------------
     * get TFpHttpServer response connection
     *-----------------------------------------------
     * @return connection
     *-----------------------------------------------*)
    function TThreadSafeFpwebResponseAware.getResponse() : TFPHTTPConnectionResponse;
    begin
        fLock.acquire();
        try
            result := fActualResponseAware.getResponse();
        finally
            fLock.release();
        end;
    end;

    (*!------------------------------------------------
     * set TFpHttpServer response connection
     *-----------------------------------------------*)
    procedure TThreadSafeFpwebResponseAware.setResponse(aresponse : TFPHTTPConnectionResponse);
    begin
        fLock.acquire();
        try
            fActualResponseAware.setResponse(aresponse);
        finally
            fLock.release();
        end;
    end;

end.
