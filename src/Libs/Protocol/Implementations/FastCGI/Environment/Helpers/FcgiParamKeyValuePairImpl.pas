{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiParamKeyValuePairImpl;

interface

{$MODE OBJFPC}

uses

    StreamAdapterIntf,
    KeyValuePairImpl;

type
    (*!------------------------------------------------
     * key value pair class having capability
     * to retrieve FastCGI environment variable
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TFcgiParamKeyValuePair = class(TKeyValuePair)
    private
        function readLength(const astream : IStreamAdapter; var bytesToRead : int64) : integer;
        function readValue(const astream : IStreamAdapter; const len : integer; var bytesToRead : int64) : string;
        procedure readKeyValueFromStream(const aStream : IStreamAdapter);
    public
        constructor create(const paramStream : IStreamAdapter);
    end;

implementation

    constructor TFcgiParamKeyValuePair.create(const paramStream : IStreamAdapter);
    begin
        inherited create();
        readKeyValueFromStream(paramStream);
    end;

    function TFcgiParamKeyValuePair.readLength(const astream : IStreamAdapter; var bytesToRead : int64) : integer;
    var lenByte : byte;
        b3, b2, b1, b0 : byte;
    begin
        //read key length
        aStream.read(lenByte, 1);
        if (lenByte and $80 = $80) then
        begin
            //4 byte encoding
            b3 := lenByte;
            astream.read(b2, 1);
            astream.read(b1, 1);
            astream.read(b0, 1);
            result := ((b3 and $7F) shl 24) + (b2 shl 16) + (b1 shl 8) + b0;
            dec(bytesToRead, 4);
        end else
        begin
            //1 byte encoding
            result := lenByte;
            dec(bytesToRead);
        end;
    end;

    function TFcgiParamKeyValuePair.readValue(
        const astream : IStreamAdapter;
        const len : integer;
        var bytesToRead : int64
    ) : string;
    begin
        setLength(result, len);
        astream.readBuffer(result[1], len);
        dec(bytesToRead, len);
    end;

    procedure TFcgiParamKeyValuePair.readKeyValueFromStream(const aStream : IStreamAdapter);
    var bytesToRead : int64;
        lenKey, lenValue : integer;
        akey, avalue : string;
    begin
        bytesToRead := aStream.size();
        while (bytesToRead > 0) do
        begin
            //read key length
            lenKey := readLength(aStream, bytesToRead);
            //read value length
            lenValue := readLength(aStream, bytesToRead);

            //read key
            akey := readValue(aStream, lenKey, bytesToRead);
            //read value
            avalue := readValue(aStream, lenValue, bytesToRead);

            setValue(akey, avalue);
        end;
    end;

end.
