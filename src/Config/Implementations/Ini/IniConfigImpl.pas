{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IniConfigImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    IniFiles,
    DependencyIntf,
    ConfigIntf;

type

    (*!------------------------------------------------------------
     * Application configuration base class that load data from INI
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TIniConfig = class(TInterfacedObject, IAppConfiguration, IDependency)
    private
        fDefaultSection : string;

        (*!------------------------------------------------
         * retrieve section name from config name or use
         * default section
         *-------------------------------------------------
         * @param configName name of config to retrieve
         * @return section name of section
         * @return ident name of key to retrieve
         *-------------------------------------------------
         * For configName = 'server.host', it returns
         * section = 'server' and ident = 'host'
         *
         * For configName = 'host', it returns
         * section = fDefaultSection and ident = 'host'
         *-------------------------------------------------*)
        procedure getSectionIdentFromConfigName(
            const configName : string;
            out section : string;
            out ident : string
        );
    protected
        FIniConfig :TIniFile;
        function buildIniData() : TIniFile; virtual; abstract;
    public
        constructor create(const defaultSection : string);
        destructor destroy(); override;

        (*!------------------------------------------------
         * retrieve string value by name
         *-------------------------------------------------
         * @param configName name of config to retrieve
         * @return value of key
         *-------------------------------------------------
         * For INI content
         *
         * [fano]
         * host=example.com
         * [server]
         * host=localhost
         *
         * where [fano] section is default section
         *
         * For configName = 'server.host', it returns 'localhost'
         * For configName = 'host', it returns 'example.com'
         *-------------------------------------------------*)
        function getString(const configName : string; const defaultValue : string = '') : string;

        (*!------------------------------------------------
         * retrieve integer value by name
         *-------------------------------------------------
         * @param configName name of config to retrieve
         * @return value of key
         *-------------------------------------------------
         * For INI content
         *
         * [fano]
         * port=8080
         * [server]
         * port=9000
         *
         * where [fano] section is default section
         *
         * For configName = 'server.port', it returns integer of 9000
         * For configName = 'port', it returns integer value of 8080
         *-------------------------------------------------*)
        function getInt(const configName : string; const defaultValue : integer = 0) : integer;

        (*!------------------------------------------------
         * retrieve boolean value by name
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

uses

    sysutils,
    classes;

    constructor TIniConfig.create(const defaultSection : string);
    begin
        fDefaultSection := defaultSection;
        fIniConfig := buildIniData();
    end;

    destructor TIniConfig.destroy();
    begin
        fIniConfig.free();
        inherited destroy();
    end;

    (*!------------------------------------------------
     * retrieve section and ident name from config name or use
     * default section
     *-------------------------------------------------
     * @param configName name of config to retrieve
     * @return section name of section
     * @return ident name of key to retrieve
     *-------------------------------------------------
     * For configName = 'server.host', it returns
     * section = 'server' and ident = 'host'
     *
     * For configName = 'host', it returns
     * section = fDefaultSection and ident = 'host'
     *-------------------------------------------------*)
    procedure TIniConfig.getSectionIdentFromConfigName(
        const configName : string;
        out section : string;
        out ident : string
    );
    var sectionPos : integer;
    begin
        sectionPos := pos('.', configName);
        if sectionPos = 0 then
        begin
            //no section found, use default section
            section := fDefaultSection;
            ident := configName;
        end else
        begin
            section := copy(configName, 1, sectionPos - 1);
            ident := copy(configName, sectionPos + 1, length(configName) - sectionPos);
        end;
    end;

    (*!------------------------------------------------
     * retrieve string value by name
     *-------------------------------------------------
     * @param configName name of config to retrieve
     * @return value of key
     *-------------------------------------------------
     * For INI content
     *
     * [fano]
     * host=example.com
     * [server]
     * host=localhost
     *
     * where [fano] section is default section
     *
     * For configName = 'server.host', it returns 'localhost'
     * For configName = 'host', it returns 'example.com'
     *-------------------------------------------------*)
    function TIniConfig.getString(
        const configName : string;
        const defaultValue : string = ''
    ) : string;
    var section, ident : string;
    begin
        getSectionIdentFromConfigName(configName, section, ident);
        result := fIniConfig.readString(section, ident, defaultValue);
    end;

    (*!------------------------------------------------
     * retrieve integer value by name
     *-------------------------------------------------
     * @param configName name of config to retrieve
     * @return value of key
     *-------------------------------------------------
     * For INI content
     *
     * [fano]
     * port=8080
     * [server]
     * port=9000
     *
     * where [fano] section is default section
     *
     * For configName = 'server.port', it returns integer of 9000
     * For configName = 'port', it returns integer value of 8080
     *-------------------------------------------------*)
    function TIniConfig.getInt(
        const configName : string;
        const defaultValue : integer = 0
    ) : integer;
    var section, ident : string;
    begin
        getSectionIdentFromConfigName(configName, section, ident);
        result := fIniConfig.readInteger(section, ident, defaultValue);
    end;

    (*!------------------------------------------------
     * retrieve boolean value by name
     *-------------------------------------------------
     * @param configName name of config to retrieve
     * @return value of key
     *-------------------------------------------------*)
    function TIniConfig.getBool(
        const configName : string;
        const defaultValue : boolean = false
    ) : boolean;
    var section, ident : string;
    begin
        getSectionIdentFromConfigName(configName, section, ident);
        result := fIniConfig.readBool(section, ident, defaultValue);
    end;

    (*!------------------------------------------------
     * retrieve double value by name
     *-------------------------------------------------
     * @param configName name of config to retrieve
     * @return value of key
     *-------------------------------------------------*)
    function TIniConfig.getFloat(
        const configName : string;
        const defaultValue : double = 0.0
    ) : double;
    var section, ident : string;
    begin
        getSectionIdentFromConfigName(configName, section, ident);
        result := fIniConfig.readFloat(section, ident, defaultValue);
    end;

    (*!------------------------------------------------
     * test if config name is exists in configuration
     *-------------------------------------------------
     * @param configName name of config to check
     * @return true if configName is exists otherwise false
     *-------------------------------------------------*)
    function TIniConfig.has(const configName : string) : boolean;
    var section, ident : string;
    begin
        getSectionIdentFromConfigName(configName, section, ident);
        result := fIniConfig.sectionExists(section) and
            fIniConfig.ValueExists(section, ident);
    end;

end.
