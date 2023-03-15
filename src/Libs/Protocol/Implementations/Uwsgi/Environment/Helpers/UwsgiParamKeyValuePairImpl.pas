{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UwsgiParamKeyValuePairImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    KeyValuePairImpl;

type
    (*!------------------------------------------------
     * key value pair class having capability
     * to retrieve environment variable from uwsgi data
     *
     * @link https://uwsgi-docs.readthedocs.io/en/latest/Protocol.html
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TUwsgiParamKeyValuePair = class(TKeyValuePair)
    private
        procedure readKeyValueFromBuffer(const stream : IStreamAdapter);
        procedure extractKeyValue(
            const stream : IStreamAdapter;
            var akey : string;
            var avalue : string;
            var totalRead : integer
        );
    public
        constructor create(stream : IStreamAdapter);
    end;

implementation

    constructor TUwsgiParamKeyValuePair.create(stream : IStreamAdapter);
    begin
        inherited create();
        readKeyValueFromBuffer(stream);
    end;

    procedure TUwsgiParamKeyValuePair.extractKeyValue(
        const stream : IStreamAdapter;
        var akey : string;
        var avalue : string;
        var totalRead : integer
    );
    var keyLen, valueLen : word;
    begin
        //environment variable will be pass in tmp as
        //[keyLen][key][valueLen][value] ....
        stream.readBuffer(keyLen, 2);
        if (keyLen > 0) then
        begin
            setLength(akey, keyLen);
            stream.readBuffer(akey[1], keyLen);
        end else
        begin
            akey := '';
        end;

        stream.readBuffer(valueLen, 2);
        if valueLen > 0 then
        begin
            setLength(avalue, valueLen);
            stream.readBuffer(avalue[1], valueLen);
        end else
        begin
            avalue := '';
        end;

        totalRead := 4 + keyLen + valueLen;
    end;

    procedure TUwsgiParamKeyValuePair.readKeyValueFromBuffer(
        const stream : IStreamAdapter
    );
    var akey, avalue : string;
        streamSize, accuRead, totalRead : integer;
    begin
        streamSize := stream.size();
        accuRead := 0;
        while (accuRead < streamSize) do
        begin
            extractKeyValue(stream, akey, avalue, totalRead);
            setValue(akey, avalue);
            inc(accuRead, totalRead);
        end;
    end;

end.
