{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ConfigIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------------------
     * interface for any class having capability to get config
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    IAppConfiguration = interface
        ['{054EE7FE-20CF-4E46-A9B2-37921D890E33}']

        (*!------------------------------------------------
         * retrieve string value by name
         *-------------------------------------------------
         * @param configName name of config to retrieve
         * @return value of key
         *-------------------------------------------------*)
        function getString(const configName : string; const defaultValue : string = '') : string;

        (*!------------------------------------------------
         * retrieve integer value by name
         *-------------------------------------------------
         * @param configName name of config to retrieve
         * @return value of key
         *-------------------------------------------------*)
        function getInt(const configName : string; const defaultValue : integer = 0) : integer;

        (*!------------------------------------------------
         * retrieve double value by name
         *-------------------------------------------------
         * @param configName name of config to retrieve
         * @return value of key
         *-------------------------------------------------*)
        function getBool(const configName : string; const defaultValue : boolean = false) : boolean;

        (*!------------------------------------------------
         * retrieve double value by name
         *-------------------------------------------------
         * @param configName name of config to retrieve
         * @return value of key
         *-------------------------------------------------*)
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
end.
