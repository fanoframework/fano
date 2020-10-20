{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EnvConfigImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    IniFiles,
    DependencyIntf,
    ConfigIntf;

type

    (*!------------------------------------------------------------
     * Application configuration base class that load data from
     * environment variables
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TEnvConfig = class(TInterfacedObject, IAppConfiguration, IDependency)
    public
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

    sysutils;

    function TEnvConfig.getString(const configName : string; const defaultValue : string = '') : string;
    begin
        result := GetEnvironmentVariable(configName);
        if (result = '') then
        begin
            result := defaultValue;
        end;
    end;

    function TEnvConfig.getInt(const configName : string; const defaultValue : integer = 0) : integer;
    var envValue : string;
    begin
        envValue := GetEnvironmentVariable(configName);
        if (envValue = '') then
        begin
            result := defaultValue;
        end else
        begin
            result := StrToInt(envValue);
        end;
    end;

    function TEnvConfig.getBool(const configName : string; const defaultValue : boolean = false) : boolean;
    var envValue : string;
    begin
        envValue := GetEnvironmentVariable(configName);
        if (envValue = '') then
        begin
            result := defaultValue;
        end else
        begin
            result := StrToBool(envValue);
        end;
    end;

    function TEnvConfig.getFloat(const configName : string; const defaultValue : double = 0.0) : double;
    var envValue : string;
    begin
        envValue := GetEnvironmentVariable(configName);
        if (envValue = '') then
        begin
            result := defaultValue;
        end else
        begin
            result := StrToFloat(envValue);
        end;
    end;

    (*!------------------------------------------------
     * test if config name is exists in configuration
     *-------------------------------------------------
     * @param configName name of config to check
     * @return true if configName is exists otherwise false
     *-------------------------------------------------*)
    function TEnvConfig.has(const configName : string) : boolean;
    begin
        result := GetEnvironmentVariable(configName) <> '';
    end;

end.
