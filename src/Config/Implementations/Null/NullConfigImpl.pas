{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullConfigImpl;

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
     * Dummy application configuration
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TNullConfig = class(TInterfacedObject, IAppConfiguration, IDependency)
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

    function TNullConfig.getString(const configName : string; const defaultValue : string = '') : string;
    begin
        //intentionally always use default value
        result := defaultValue;
    end;

    function TNullConfig.getInt(const configName : string; const defaultValue : integer = 0) : integer;
    begin
        //intentionally always use default value
        result := defaultValue;
    end;

    function TNullConfig.getBool(const configName : string; const defaultValue : boolean = false) : boolean;
    begin
        //intentionally always use default value
        result := defaultValue;
    end;

    function TNullConfig.getFloat(const configName : string; const defaultValue : double = 0.0) : double;
    begin
        //intentionally always use default value
        result := defaultValue;
    end;

    (*!------------------------------------------------
     * test if config name is exists in configuration
     *-------------------------------------------------
     * @param configName name of config to check
     * @return true if configName is exists otherwise false
     *-------------------------------------------------*)
    function TNullConfig.has(const configName : string) : boolean;
    begin
        //intentionally always not found
        result := false;
    end;
end.
