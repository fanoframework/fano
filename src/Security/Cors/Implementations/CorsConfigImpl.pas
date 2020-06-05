{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CorsConfigImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    CorsConfigIntf;

type

    (*!------------------------------------------------
     * basic class having capability to
     * get CORS settings
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCorsConfig = class(TInterfacedObject, ICorsConfig)
    private
        fAllowedOrigins : TStringArray;
        fAllowedOriginsPatterns : TStringArray;
        fAllowedMethods : TStringArray;
        fAllowedHeaders : TStringArray;
        fExposedHeaders : TStringArray;
        fSupportsCredentials : boolean;
        fMaxAge : integer;
    public
        constructor create(
            const allowedOrigins : TStringArray;
            const allowedOriginsPatterns : TStringArray;
            const allowedMethods : TStringArray;
            const allowedHeaders : TStringArray;
            const exposedHeaders : TStringArray;
            const supportsCredentials : boolean;
            const maxAge : integer
        );
        destructor destroy(); override;

        function getAllowedOrigins() : TStringArray;
        function getAllowedOriginsPatterns() : TStringArray;
        function getAllowedMethods() : TStringArray;
        function getAllowedHeaders() : TStringArray;
        function getExposedHeaders() : TStringArray;
        function getSupportsCredentials() : boolean;
        function getMaxAge() : integer;
    end;

implementation

uses

    StrUtils;

    function handleWildCard(const arr : TStringArray) : TStringArray;
    begin
        if (ansiMatchStr('*', arr)) then
        begin
            //wildcard means all
            setLength(result, 1);
            result[0] := '*';
        end else
        begin
            result := arr;
        end;
    end;

    function makeUpperCase(const arr : TStringArray) : TStringArray;
    var i, len : integer;
    begin
        len := length(arr);
        setLength(result, len);
        for i:= 0 to len-1 do
        begin
            result[i] := uppercase(arr[i]);
        end;
    end;

    function makeLowerCase(const arr : TStringArray) : TStringArray;
    var i, len : integer;
    begin
        len := length(arr);
        setLength(result, len);
        for i:= 0 to len-1 do
        begin
            result[i] := lowercase(arr[i]);
        end;
    end;

    constructor TCorsConfig.create(
        const allowedOrigins : TStringArray;
        const allowedOriginsPatterns : TStringArray;
        const allowedMethods : TStringArray;
        const allowedHeaders : TStringArray;
        const exposedHeaders : TStringArray;
        const supportsCredentials : boolean;
        const maxAge : integer
    );
    begin
        fAllowedOrigins := allowedOrigins;
        fAllowedOriginsPatterns := allowedOriginsPatterns;
        fAllowedMethods := makeUpperCase(handleWildCard(allowedMethods));
        fAllowedHeaders := makeLowerCase(handleWildCard(allowedHeaders));
        fExposedHeaders := makeUpperCase(handleWildCard(exposedHeaders));
        fSupportsCredentials := supportsCredentials;
        fMaxAge := maxAge;
    end;

    destructor TCorsConfig.destroy();
    begin
        setLength(fAllowedOrigins, 0);
        setLength(fAllowedOriginsPatterns, 0);
        setLength(fAllowedMethods, 0);
        setLength(fAllowedHeaders, 0);
        setLength(fExposedHeaders, 0);
        fAllowedOrigins := nil;
        fAllowedOriginsPatterns := nil;
        fAllowedMethods := nil;
        fAllowedHeaders := nil;
        fExposedHeaders := nil;
        inherited destroy();
    end;

    function TCorsConfig.getAllowedOrigins() : TStringArray;
    begin
        result := fAllowedOrigins;
    end;

    function TCorsConfig.getAllowedOriginsPatterns() : TStringArray;
    begin
        result := fAllowedOriginsPatterns;
    end;

    function TCorsConfig.getAllowedMethods() : TStringArray;
    begin
        result := fAllowedMethods;
    end;

    function TCorsConfig.getAllowedHeaders() : TStringArray;
    begin
        result := fAllowedHeaders;
    end;

    function TCorsConfig.getExposedHeaders() : TStringArray;
    begin
        result := fExposedHeaders;
    end;

    function TCorsConfig.getSupportsCredentials() : boolean;
    begin
        result := fSupportsCredentials;
    end;

    function TCorsConfig.getMaxAge() : integer;
    begin
        result := fMaxAge;
    end;
end.
