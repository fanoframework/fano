{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
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
        lenInt : integer;
    begin
        //read key length
        aStream.read(lenByte, 1);
        if (lenByte and $80 = $80) then
        begin
            //4 byte encoding
            astream.seek(-1, FROM_CURRENT);
            astream.read(lenInt, 4);
            result := lenInt and $7FFFFFFF;
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
