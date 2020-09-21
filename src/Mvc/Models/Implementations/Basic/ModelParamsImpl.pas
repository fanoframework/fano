{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ModelParamsImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ModelParamsIntf,
    InjectableObjectImpl,
    KeyValueMapImpl,
    KeyIntValueMapImpl;

type

    (*!------------------------------------------------
     * store model parameter data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TModelParams = class (TInjectableObject, IModelParams)
    private
        fKeyValue : TKeyValueMap;
        fKeyIntValue : TKeyIntValueMap;
        function serializeKeyValue(const akeyValue : TKeyValueMap) : string;
        function serializeKeyIntValue(const akeyValue : TKeyIntValueMap) : string;
    public
        constructor create();
        destructor destroy(); override;

        function writeString(const key : shortstring; const value : string) : IModelParams;
        function writeInteger(const key : shortstring; const value : integer) : IModelParams;

        function readString(const key : shortstring) : string;
        function readInteger(const key : shortstring) : integer;

        function serialize() : string;
    end;

implementation

uses

    SysUtils;

    constructor TModelParams.create();
    begin
        fKeyValue := TKeyValueMap.create();
        fKeyIntValue := TKeyIntValueMap.create();
    end;

    destructor TModelParams.destroy();
    begin
        fKeyValue.free();
        fKeyIntValue.free();
        inherited destroy();
    end;

    function TModelParams.writeString(const key : shortstring; const value : string) : IModelParams;
    begin
        fKeyValue[key] := value;
        result := self;
    end;

    function TModelParams.writeInteger(const key : shortstring; const value : integer) : IModelParams;
    begin
        fKeyIntValue[key] := value;
        result := self;
    end;

    function TModelParams.readString(const key : shortstring) : string;
    begin
        result := fKeyValue[key];
    end;

    function TModelParams.readInteger(const key : shortstring) : integer;
    begin
        result := fKeyIntValue[key];
    end;

    function TModelParams.serializeKeyValue(const akeyValue : TKeyValueMap) : string;
    var i, totKeyVal : integer;
    begin
        result := '';
        totKeyVal := aKeyValue.count;
        if (totKeyVal = 0) then
        begin
            exit();
        end;

        for i := 0 to totKeyVal - 2 do
        begin
            result := result +
                '"' + aKeyValue.keys[i] + '" : "' +
                aKeyValue.data[i] + '",';
        end;
        result := result +
            '"' + aKeyValue.keys[totKeyVal - 1] + '" : "' +
            aKeyValue.data[totKeyVal - 1] + '"';
    end;

    function TModelParams.serializeKeyIntValue(const akeyValue : TKeyIntValueMap) : string;
    var i, totKeyVal : integer;
    begin
        result := '';
        totKeyVal := aKeyValue.count;
        if (totKeyVal = 0) then
        begin
            exit();
        end;

        for i := 0 to totKeyVal - 2 do
        begin
            result := result +
                '"' + aKeyValue.keys[i] + '" : "' +
                inttoStr(aKeyValue.data[i]) + '",';
        end;
        result := result +
            '"' + aKeyValue.keys[totKeyVal - 1] + '" : "' +
            intToStr(aKeyValue.data[totKeyVal - 1]) + '"';
    end;

    function TModelParams.serialize() : string;
    begin
        if (fKeyValue.count > 0) or (fKeyIntValue.count > 0) then
        begin
            //serialize as JSON string
            result := '{' +
                serializeKeyValue(fKeyValue) +
                serializeKeyIntValue(fKeyIntValue) +
            '}';
        end else
        begin
            result := '';
        end;;
    end;
end.
