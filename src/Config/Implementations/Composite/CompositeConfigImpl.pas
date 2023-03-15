{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompositeConfigImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    IniFiles,
    DependencyIntf,
    ConfigIntf;

type

    (*!------------------------------------------------------------
     * Composite application configuration that load data from
     * two external IAppConfiguration instances
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TCompositeConfig = class(TInterfacedObject, IAppConfiguration, IDependency)
    private
        fFirstCfg : IAppConfiguration;
        fSecondCfg : IAppConfiguration;
    public
        constructor create(
            const firstCfg : IAppConfiguration;
            const secondCfg : IAppConfiguration
        );

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

    constructor TCompositeConfig.create(
        const firstCfg : IAppConfiguration;
        const secondCfg : IAppConfiguration
    );
    begin
        fFirstCfg := firstCfg;
        fSecondCfg := secondCfg;
    end;

    function TCompositeConfig.getString(const configName : string; const defaultValue : string = '') : string;
    begin
        if fFirstCfg.has(configName) then
        begin
            result := fFirstCfg.getString(configName, defaultValue);
        end else
        begin
            //not found. Try in second config
            result := fSecondCfg.getString(configName, defaultValue);
        end;
    end;

    function TCompositeConfig.getInt(const configName : string; const defaultValue : integer = 0) : integer;
    begin
        if fFirstCfg.has(configName) then
        begin
            result := fFirstCfg.getInt(configName, defaultValue);
        end else
        begin
            //not found. Try in second config
            result := fSecondCfg.getInt(configName, defaultValue);
        end;
    end;

    function TCompositeConfig.getBool(const configName : string; const defaultValue : boolean = false) : boolean;
    begin
        if fFirstCfg.has(configName) then
        begin
            result := fFirstCfg.getBool(configName, defaultValue);
        end else
        begin
            //not found. Try in second config
            result := fSecondCfg.getBool(configName, defaultValue);
        end;
    end;

    function TCompositeConfig.getFloat(const configName : string; const defaultValue : double = 0.0) : double;
    begin
        if fFirstCfg.has(configName) then
        begin
            result := fFirstCfg.getFloat(configName, defaultValue);
        end else
        begin
            //not found. Try in second config
            result := fSecondCfg.getFloat(configName, defaultValue);
        end;
    end;

    function TCompositeConfig.has(const configName : string) : boolean;
    begin
        result := fFirstCfg.has(configName);
        if not result then
        begin
            //not found. Try in second config
            result := fSecondCfg.has(configName);
        end;
    end;
end.
