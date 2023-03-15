{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiParams;

interface

{$MODE OBJFPC}
{$H+}

uses

    KeyValuePairIntf,
    StreamAdapterIntf,
    FcgiRecord;

type

    (*!-----------------------------------------------
     * Params record (FCGI_PARAMS)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiParams = class(TFcgiRecord, IKeyValuePair)
    private
        fKeyValues : IKeyValuePair;

        (*!------------------------------------------------
        * build key value data and write it to destination stream
        *-----------------------------------------------
        * @param dstStream, stream instance where to write
        *-----------------------------------------------*)
        procedure buildKeyValueStream(const dstStream : IStreamAdapter);

    public
        constructor create(
            const aVersion : byte;
            const aType : byte;
            const aRequestId : word;
            const dataStream : IStreamAdapter;
            const aKeyValues : IKeyValuePair
        );

        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param requestId, id of request
         * @return aKeyValues, instance IKeyValuePair which will store key value
         *-----------------------------------------------*)
        constructor create(
            const dataStream : IStreamAdapter;
            const requestId : word;
            const aKeyValues : IKeyValuePair
        );

        (*!------------------------------------------------
         * constructor that initialize key values from source stream
         *-----------------------------------------------
         * @param srcStream, source stream
         * @param dataStream, data stream
         * @return aKeyValues, instance IKeyValuePair which will store key value
         *-----------------------------------------------*)
        constructor createFromStream(
            const srcStream : IStreamAdapter;
            const dataStream : IStreamAdapter;
            const aKeyValues : IKeyValuePair
        );

        (*!------------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
        * write record data to destination stream
        *-----------------------------------------------
        * @param stream, stream instance where to write
        * @return number of bytes actually written
        *-----------------------------------------------*)
        function write(const dstStream : IStreamAdapter) : integer; override;

        property keyValues : IKeyValuePair read fKeyValues implements IKeyValuePair;
    end;

implementation

uses

    fastcgi,
    classes;

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------
     * @param requestId, id of request
     * @return aKeyValues, instance IKeyValuePair which will store key value
     *-----------------------------------------------*)
    constructor TFcgiParams.create(
        const aVersion : byte;
        const aType : byte;
        const aRequestId : word;
        const dataStream : IStreamAdapter;
        const aKeyValues : IKeyValuePair
    );
    begin
        inherited create(aVersion, aType, aRequestId, dataStream);
        fKeyValues := aKeyValues;
    end;

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------
     * @param requestId, id of request
     * @return aKeyValues, instance IKeyValuePair which will store key value
     *-----------------------------------------------*)
    constructor TFcgiParams.create(
        const dataStream : IStreamAdapter;
        const requestId : word;
        const aKeyValues : IKeyValuePair
    );
    begin
        create(FCGI_VERSION_1, FCGI_PARAMS, requestId, dataStream, aKeyValues);
    end;

    constructor TFcgiParams.createFromStream(
        const srcStream : IStreamAdapter;
        const dataStream : IStreamAdapter;
        const aKeyValues : IKeyValuePair
    );
    begin
        inherited createFromStream(srcStream, dataStream);
        fKeyValues := aKeyValues;
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TFcgiParams.destroy();
    begin
        fKeyValues := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
    * write record data to destination stream
    *-----------------------------------------------
    * @param dstStream, stream instance where to write
    * @return number of bytes actually written
    *-----------------------------------------------*)
    function TFcgiParams.write(const dstStream : IStreamAdapter) : integer;
    begin
        buildKeyValueStream(fContentData);
        result := inherited write(dstStream);
    end;

    (*!------------------------------------------------
    * build key value data and write it to destination stream
    *-----------------------------------------------
    * @param dstStream, stream instance where to write
    * @return number of bytes actually written
    *-----------------------------------------------*)
    procedure TFcgiParams.buildKeyValueStream(const dstStream : IStreamAdapter);
    var i, totalKeys : integer;
        akey : shortstring;
        avalue : string;
        lenKey : integer;
        lenValue : integer;
    begin
        dstStream.reset();
        totalKeys := keyValues.count();
        for i := 0 to totalKeys - 1 do
        begin
            akey := keyValues.getKey(i);
            lenKey := length(akey);
            avalue := keyValues.getValue(akey);
            lenValue := length(avalue);
            if (lenKey > 127) then
            begin
                //encode length as four byte data
                //with high-order bit = 1 to mark 4 bytes encoding
                lenKey := lenKey or $80000000;
                dstStream.writeBuffer(lenKey, 4);
            end else
            begin
                //encode length as one byte data
                dstStream.writeBuffer(lenKey, 1);
            end;

            if (lenValue > 127) then
            begin
                //encode length as four byte data
                //with high-order bit = 1 to mark 4 bytes encoding
                lenValue := lenValue or $80000000;
                dstStream.writeBuffer(lenValue, 4);
            end else
            begin
                //encode length as four byte data
                dstStream.writeBuffer(lenValue, 4);
            end;

            dstStream.writeBuffer(akey[1], length(akey));
            dstStream.writeBuffer(avalue[1], length(avalue));
        end;
    end;
end.
