{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
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
     * Application configuration null class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TNullConfig = class(TInterfacedObject, IAppConfiguration, IDependency)
    public
        function getString(const configName : string; const defaultValue : string = '') : string;
        function getInt(const configName : string; const defaultValue : integer = 0) : integer;
        function getBool(const configName : string; const defaultValue : boolean = false) : boolean;
    end;

implementation

    function TNullConfig.getString(const configName : string; const defaultValue : string = '') : string;
    begin
        result := defaultValue;
    end;

    function TNullConfig.getInt(const configName : string; const defaultValue : integer = 0) : integer;
    begin
        result := defaultValue;
    end;

    function TNullConfig.getBool(const configName : string; const defaultValue : boolean = false) : boolean;
    begin
        result := defaultValue;
    end;

end.
