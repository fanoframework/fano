{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonConfigImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    fpjson,
    jsonparser,
    DependencyIntf,
    ConfigIntf;

type

    (*!------------------------------------------------------------
     * Application configuration base class that load data from JSON
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TJsonConfig = class(TInterfacedObject, IAppConfiguration, IDependency)
    protected
        json :TJSONData;
        function buildJsonData() : TJSONData; virtual; abstract;
    public
        constructor create();
        destructor destroy(); override;
        function getString(const configName : string; const defaultValue : string = '') : string;
        function getInt(const configName : string; const defaultValue : integer = 0) : integer;
        function getBool(const configName : string; const defaultValue : boolean = false) : boolean;
        function getFloat(const configName : string; const defaultValue : double = 0.0) : double;

        (*!------------------------------------------------
         * test if config name is exists in configuration
         *-------------------------------------------------
         * @param configName name of config to check
         * @return true if configName is exists otherwise false
         *-------------------------------------------------*)
        function has(const configName : string) : boolean;
    end;

implementation

uses
    sysutils,
    classes;

    constructor TJsonConfig.create();
    begin
        json := buildJsonData();
    end;

    destructor TJsonConfig.destroy();
    begin
        json.free();
        inherited destroy();
    end;

    function TJsonConfig.getString(const configName : string; const defaultValue : string = '') : string;
    var jsonData : TJSONData;
    begin
        jsonData := json.findPath(configName);
        if (jsonData = nil) then
        begin
            result := defaultValue;
        end else
        begin
            result := jsonData.asString;
        end;
    end;

    function TJsonConfig.getInt(const configName : string; const defaultValue : integer = 0) : integer;
    var jsonData : TJSONData;
    begin
        jsonData := json.findPath(configName);
        if (jsonData = nil) then
        begin
            result := defaultValue;
        end else
        begin
            result := jsonData.asInteger;
        end;
    end;

    function TJsonConfig.getBool(const configName : string; const defaultValue : boolean = false) : boolean;
    var jsonData : TJSONData;
    begin
        jsonData := json.findPath(configName);
        if (jsonData = nil) then
        begin
            result := defaultValue;
        end else
        begin
            result := jsonData.asBoolean;
        end;
    end;

    function TJsonConfig.getFloat(const configName : string; const defaultValue : double = 0.0) : double;
    var jsonData : TJSONData;
    begin
        jsonData := json.findPath(configName);
        if (jsonData = nil) then
        begin
            result := defaultValue;
        end else
        begin
            result := jsonData.asFloat;
        end;
    end;

    (*!------------------------------------------------
     * test if config name is exists in configuration
     *-------------------------------------------------
     * @param configName name of config to check
     * @return true if configName is exists otherwise false
     *-------------------------------------------------*)
    function TJsonConfig.has(const configName : string) : boolean;
    begin
        result := json.findPath(configName) <> nil;
    end;

end.
