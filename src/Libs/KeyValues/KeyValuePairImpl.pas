{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit KeyValuePairImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    KeyValueMapImpl,
    KeyValuePairIntf,
    ReadOnlyKeyValuePairIntf,
    SerializeableIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * basic class having capability to store key value
     * pair that implements IKeyValuePair
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TKeyValuePair = class(TinjectableObject, IReadOnlyKeyValuePair, IKeyValuePair, ISerializeable)
    private
        keyValueMap : TKeyValueMap;

        (*!------------------------------------------------
         * serialize key value if not empty
         *-----------------------------------------------
         * Note :
         * This turn key0=value0, key1=value=1,.. into
         * string `key0=value0&key1=value=1&..`
         *-----------------------------------------------
         * @return serialized string
         *-----------------------------------------------*)
        function serializeIfNotEmpty(const itemSize : integer) : string;
    public

        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------*)
        constructor create();

        (*!------------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * set key value pair
         *-----------------------------------------------
         * @param key name to use
         * @param val value to use
         * @return current instance
         *-----------------------------------------------*)
        function setValue(const keyName : shortstring; const val : string) : IKeyValuePair;

        (*!------------------------------------------------
         * get value by key
         *-----------------------------------------------
         * @param key name to use
         * @return value
         *-----------------------------------------------*)
        function getValue(const keyName : shortstring) : string;

        (*!------------------------------------------------
         * test if key is set
         *-----------------------------------------------
         * @param key name to use
         * @return boolean true if key is set otherwise false
         *-----------------------------------------------*)
        function has(const keyName : shortstring) : boolean;

        (*!------------------------------------------------
         * unset key
         *-----------------------------------------------
         * @param key name to use
         * @return current instance
         * @throws EKeyNotFound exception if not set
         *-----------------------------------------------*)
        function unset(const keyName : shortstring) : IKeyValuePair;

        (*!------------------------------------------------
         * get number of keys
         *-----------------------------------------------
         * @return number of keys
         *-----------------------------------------------*)
        function count() : integer;

        (*!------------------------------------------------
         * get key by index
         *-----------------------------------------------
         * @param index index to use
         * @return key name
         * @throws EKeyNotFound exception if not set
         *-----------------------------------------------*)
        function getKey(const indx : integer) : shortstring;

        (*!------------------------------------------------
         * serialize key value
         *-----------------------------------------------
         * Note :
         * This turn key0=value0, key1=value=1,.. into
         * string `key0=value0&key1=value=1&..`
         *-----------------------------------------------
         * @return serialized string
         *-----------------------------------------------*)
        function serialize() : string;
    end;

implementation

uses

    UrlHelpersImpl;

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------*)
    constructor TKeyValuePair.create();
    begin
        keyValueMap := TKeyValueMap.create();
        keyValueMap.sorted := true;
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TKeyValuePair.destroy();
    begin
        inherited destroy();
        keyValueMap.free();
    end;

    (*!------------------------------------------------
     * set key value pair
     *-----------------------------------------------
     * @param key name to use
     * @param val value to use
     * @return current instance
     *-----------------------------------------------*)
    function TKeyValuePair.setValue(const keyName : shortstring; const val : string) : IKeyValuePair;
    begin
        keyValueMap.addOrSetData(keyName, val);
        result := self;
    end;

    (*!------------------------------------------------
     * get value by key
     *-----------------------------------------------
     * @param key name to use
     * @return value
     * @throws EKeyNotFound exception if not set
     *-----------------------------------------------*)
    function TKeyValuePair.getValue(const keyName : shortstring) : string;
    begin
        result := keyValueMap[keyName];
    end;

    (*!------------------------------------------------
     * test if key is set
     *-----------------------------------------------
     * @param key name to use
     * @return boolean true if key is set otherwise false
     *-----------------------------------------------*)
    function TKeyValuePair.has(const keyName : shortstring) : boolean;
    var foundIndex : integer;
    begin
        result := keyValueMap.find(keyName, foundIndex);
    end;

    (*!------------------------------------------------
     * unset key
     *-----------------------------------------------
     * @param key name to use
     * @return current instance
     * @throws EKeyNotFound exception if not set
     *-----------------------------------------------*)
    function TKeyValuePair.unset(const keyName : shortstring) : IKeyValuePair;
    begin
        keyValueMap.remove(keyName);
        result := self;
    end;

    (*!------------------------------------------------
     * get number of keys
     *-----------------------------------------------
     * @return number of keys
     *-----------------------------------------------*)
    function TKeyValuePair.count() : integer;
    begin
        result := keyValueMap.count;
    end;

    (*!------------------------------------------------
     * get key by index
     *-----------------------------------------------
     * @param index index to use
     * @return key name
     * @throws EKeyNotFound exception if not set
     *-----------------------------------------------*)
    function TKeyValuePair.getKey(const indx : integer) : shortstring;
    begin
        result := keyValueMap.keys[indx];
    end;

    (*!------------------------------------------------
     * serialize key value if not empty
     *-----------------------------------------------
     * Note :
     * This turn key0=value0, key1=value=1,.. into
     * string `key0=value0&key1=value=1&..`
     *-----------------------------------------------
     * @return serialized string
     *-----------------------------------------------*)
    function TKeyValuePair.serializeIfNotEmpty(const itemSize : integer) : string;
    var indx : integer;
        urlEncodeKey, urlEncodeVal : string;
    begin
        result := '';
        for indx := 0 to itemSize-2 do
        begin
            urlEncodeKey := keyValueMap.keys[indx];
            urlEncodeKey := urlEncodeKey.urlEncode();
            urlEncodeVal := keyValueMap.data[indx];
            urlEncodeVal := urlEncodeVal.urlEncode();
            result := result + urlEncodeKey + '=' + urlEncodeVal + '&';
        end;
        urlEncodeKey := keyValueMap.keys[itemSize-1];
        urlEncodeKey := urlEncodeKey.urlEncode();
        urlEncodeVal := keyValueMap.data[itemSize-1];
        urlEncodeVal := urlEncodeVal.urlEncode();
        result := result + urlEncodeKey + '=' + urlEncodeVal;
    end;

    (*!------------------------------------------------
     * serialize key value
     *-----------------------------------------------
     * Note :
     * This turn key0=value0, key1=value=1,.. into
     * string `key0=value0&key1=value=1&..`
     *-----------------------------------------------
     * @return serialized string
     *-----------------------------------------------*)
    function TKeyValuePair.serialize() : string;
    var itemSize : integer;
    begin
        result := '';
        itemSize := keyValueMap.ItemSize;
        if (itemSize > 0) then
        begin
            result := serializeIfNotEmpty(itemSize);
        end;
    end;
end.
