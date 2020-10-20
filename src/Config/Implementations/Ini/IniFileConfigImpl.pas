{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IniFileConfigImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    IniFiles,
    DependencyIntf,
    ConfigIntf,
    IniConfigImpl;

type

    (*!------------------------------------------------------------
     * Application configuration class that load data from INI file
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TIniFileConfig = class(TIniConfig, IAppConfiguration, IDependency)
    private
        iniConfigFile : string;
    protected
        function buildIniData() : TIniFile; override;
    public
        constructor create(const configFile : string; const defaultSection : string);
    end;

implementation

uses

    sysutils,
    classes;

    function TIniFileConfig.buildIniData() : TIniFile;
    begin
        result := TIniFile.create(iniConfigFile);
    end;

    constructor TIniFileConfig.create(
        const configFile : string;
        const defaultSection : string
    );
    begin
        iniConfigFile := configFile;
        //must be called after we set iniConfigFile
        inherited create(defaultSection);
    end;

end.
