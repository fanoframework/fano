{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
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

        procedure getSectionIdentFromConfigName(
            const configName : string;
            var section : string;
            var ident : string
        );
    protected
        FIniConfig :TIniFile;
        function buildIniData() : TIniFile; virtual; abstract;
    public
        constructor create(const defaultSection : string);
        destructor destroy(); override;
        function getString(const configName : string; const defaultValue : string = '') : string;
        function getInt(const configName : string; const defaultValue : integer = 0) : integer;
        function getBool(const configName : string; const defaultValue : boolean = false) : boolean;
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

    procedure TIniConfig.getSectionIdentFromConfigName(
        const configName : string;
        var section : string;
        var ident : string
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

    function TIniConfig.getString(const configName : string; const defaultValue : string = '') : string;
    var section, ident : string;
    begin
        getSectionIdentFromConfigName(configName, section, ident);
        result := fIniConfig.readString(section, ident, defaultValue);
    end;

    function TIniConfig.getInt(const configName : string; const defaultValue : integer = 0) : integer;
    var section, ident : string;
    begin
        getSectionIdentFromConfigName(configName, section, ident);
        result := fIniConfig.readInteger(section, ident, defaultValue);
    end;

    function TIniConfig.getBool(const configName : string; const defaultValue : boolean = false) : boolean;
    var section, ident : string;
    begin
        getSectionIdentFromConfigName(configName, section, ident);
        result := fIniConfig.readBool(section, ident, defaultValue);
    end;

end.
