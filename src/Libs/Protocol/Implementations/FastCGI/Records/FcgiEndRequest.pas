{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiEndRequest;

interface

{$MODE OBJFPC}
{$H+}

uses

    fastcgi,
    StreamAdapterIntf,
    FcgiRecord;

type

    (*!-----------------------------------------------
     * End Request record (FCGI_END_REQUEST)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiEndRequest = class(TFcgiRecord)
    public
        constructor create(
            const aVersion : byte;
            const aType : byte;
            const aRequestId : word;
            const dataStream : IStreamAdapter;
            const protocolStatus : byte;
            const appStatus : cardinal
        );

        constructor create(
            const dataStream : IStreamAdapter;
            const requestId : word;
            const protocolStatus : byte = FCGI_REQUEST_COMPLETE;
            const appStatus : cardinal = 0
        );
    end;

implementation

    constructor TFcgiEndRequest.create(
        const aVersion : byte;
        const aType : byte;
        const aRequestId : word;
        const dataStream : IStreamAdapter;
        const protocolStatus : byte;
        const appStatus : cardinal
    );
    var endRequestRec : FCGI_EndRequestBody;
        bytesToWrite : integer;
    begin
        inherited create(aVersion, aType, aRequestId, dataStream);
        bytesToWrite := sizeOf(FCGI_EndRequestBody);
        endRequestRec.protocolStatus := protocolStatus;
        endRequestRec.appStatusB0 := appStatus and $ff;
        endRequestRec.appStatusB1 := (appStatus shr 8) and $ff;
        endRequestRec.appStatusB2 := (appStatus shr 16) and $ff;
        endRequestRec.appStatusB3 := (appStatus shr 24) and $ff;
        endRequestRec.reserved[0] := 0;
        endRequestRec.reserved[1] := 0;
        endRequestRec.reserved[2] := 0;
        fContentData.writeBuffer(endRequestRec, bytesToWrite);
        fContentData.seek(0);
    end;

    constructor TFcgiEndRequest.create(
        const dataStream : IStreamAdapter;
        const requestId : word;
        const protocolStatus : byte = FCGI_REQUEST_COMPLETE;
        const appStatus : cardinal = 0
    );
    begin
        create(FCGI_VERSION_1, FCGI_END_REQUEST, requestId, dataStream, protocolStatus, appStatus);
    end;
end.
