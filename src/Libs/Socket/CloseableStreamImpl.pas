{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CloseableStreamImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    StreamAdapterIntf,
    CloseableIntf,
    StreamIdIntf;

type

    (*!-----------------------------------------------
     * stream implementation that read/write socket and
     * can be close
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCloseableStream = class(TInterfacedObject, IStreamAdapter, ICloseable, IStreamId)
    private
        fHandle : THandle;
        fStream : IStreamAdapter;
    public
        constructor create(const ahandle: THandle; const aStream : IStreamAdapter);
        destructor destroy(); override;
        function close() : boolean;

        function getId() : shortstring;

        property stream : IStreamAdapter read fStream implements IStreamAdapter;
    end;

implementation

uses

    SysUtils,
    sockets;

    constructor TCloseableStream.create(const ahandle: THandle; const aStream : IStreamAdapter);
    begin
        fHandle := aHandle;
        fStream := aStream;
    end;

    destructor TCloseableStream.destroy();
    begin
        inherited destroy();
        //we do not call closeSocket(fHandle) here because we want
        //the listener decide if socket should be close or leave open.
        //So we can handle, for example, FastCGI protocol requirement that
        //sometime require that client socket connection keep open.
        fStream := nil;
    end;

    function TCloseableStream.close() : boolean;
    begin
        closeSocket(fHandle);
        result := true;
    end;

    function TCloseableStream.getId() : shortstring;
    begin
        result := intToHex(fHandle, 16);
    end;

end.
