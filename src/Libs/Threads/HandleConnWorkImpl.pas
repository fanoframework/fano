{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HandleConnWorkImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    CloseableIntf,
    StreamAdapterIntf,
    StreamIdIntf,
    RunnableIntf,
    ProtocolAwareIntf,
    ProtocolProcessorIntf;

type

    (*!------------------------------------------------
     * IRunnable implementation which handle socket connection
     * and delegate reading and parsing to protocol processor
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THandleConnWork = class(TInterfacedObject, IRunnable, IProtocolAware)
    private
        fProtocol : IProtocolProcessor;
        fstream : IStreamAdapter;
        fstreamCloser : ICloseable;
        fstreamId : IStreamId;
    public
        constructor create(
            const stream : IStreamAdapter;
            const streamCloser : ICloseable;
            const streamId : IStreamId
        );
        destructor destroy(); override;
        function run() : IRunnable;

        (*!------------------------------------------------
         * set protocol processor
         *-----------------------------------------------
         * @param protocol protocol processor
         *-----------------------------------------------*)
        procedure setProtocol(const protocol : IProtocolProcessor);
    end;


implementation

    constructor THandleConnWork.create(
        const stream : IStreamAdapter;
        const streamCloser : ICloseable;
        const streamId : IStreamId
    );
    begin
        fProtocol := nil;
        fstream := stream;
        fstreamCloser := streamCloser;
        fstreamId := streamId;
    end;

    destructor THandleConnWork.destroy();
    begin
        fProtocol := nil;
        fstream := nil;
        fstreamCloser := nil;
        fstreamId := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * set protocol processor
     *-----------------------------------------------
     * @param protocol protocol processor
     *-----------------------------------------------*)
    procedure THandleConnWork.setProtocol(const protocol : IProtocolProcessor);
    begin
        fProtocol := protocol;
    end;

    function THandleConnWork.run() : IRunnable;
    begin
        fProtocol.process(fstream, fstreamCloser, fStreamId);
        result := self;
    end;


end.
