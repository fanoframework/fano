{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IniStringConfigImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    IniFiles,
    DependencyIntf,
    ConfigIntf,
    IniConfigImpl;

type

    (*!------------------------------------------------------------
     * Application configuration class that load data from INI string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    TIniStringConfig = class(TIniConfig, IAppConfiguration, IDependency)
    private
        fIniStream : TStream;
    protected
        function buildIniData() : TIniFile; override;
    public
        constructor create(const configStr : string; const defaultSection : string);
        destructor destroy(); override;
    end;

implementation

uses

    SysUtils;

    function TIniStringConfig.buildIniData() : TIniFile;
    begin
        result := TIniFile.create(fIniStream);
    end;

    constructor TIniStringConfig.create(const configStr : string; const defaultSection : string);
    begin
        fIniStream := TStringStream.create(configStr);
        //must be called after we set jsonConfigStr
        inherited create(defaultSection);
    end;

    destructor TIniStringConfig.destroy();
    begin
        fIniStream.free();
        inherited destroy();
    end;

end.
