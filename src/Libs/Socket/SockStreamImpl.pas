{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SockStreamImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes;

type

    (*!-----------------------------------------------
     * stream implementation that read/write socket
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSockStream = class(THandleStream)
    private
        procedure raiseExceptionIfAny(const msgFormat : string);
    public
        function read(var buffer; count: longint): longint; override;
        function write(const buffer; count: longint): longint; override;
    end;

implementation

uses

    sockets,
    BaseUnix,
    errors,
    ESockStreamImpl,
    ESockWouldBlockImpl,
    SocketConsts;

    procedure TSockStream.raiseExceptionIfAny(const msgFormat : string);
    var errCode : longint;
    begin
        errCode := socketError();
        if (errCode = ESysEWOULDBLOCK) or (errCode = ESysEAGAIN) then
        begin
            //not ready for I/O without blocking,
            raise ESockWouldBlock.createFmt(msgFormat, errCode, strError(errCode));
        end else
        begin
            raise ESockStream.createFmt(msgFormat, errCode, strError(errCode));
        end;
    end;

    function TSockStream.read(var buffer; count: longint): longint;
    begin
        //disable signal such as SIGPIPE, we will handle error ourselves
        result := fpRecv(Handle, @buffer, count, MSG_NOSIGNAL);
        if result < 0 then
        begin
            raiseExceptionIfAny(rsSocketReadFailed);
        end;
    end;

    function TSockStream.write(const buffer; count: longint): longint;
    begin
        //disable signal such as SIGPIPE, we will handle error ourselves
        result := fpSend(Handle, @buffer, count, MSG_NOSIGNAL);
        if result < 0 then
        begin
            raiseExceptionIfAny(rsSocketWriteFailed);
        end;
    end;

end.
