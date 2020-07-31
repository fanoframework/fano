{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CorsConfigIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * get CORS settings
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ICorsConfig = interface
        ['{B0A203BC-7A1F-49EA-A1DE-965E92A4DA9C}']

        function getAllowedOrigins() : TStringArray;
        property allowedOrigins : TStringArray read getAllowedOrigins;

        function getAllowedOriginsPatterns() : TStringArray;
        property allowedOriginsPatterns : TStringArray read getAllowedOriginsPatterns;

        function getAllowedMethods() : TStringArray;
        property allowedMethods : TStringArray read getAllowedMethods;

        function getAllowedHeaders() : TStringArray;
        property allowedHeaders : TStringArray read getAllowedHeaders;

        function getExposedHeaders() : TStringArray;
        property exposedHeaders : TStringArray read getExposedHeaders;

        function getSupportsCredentials() : boolean;
        property supportsCredentials : boolean read getSupportsCredentials;

        function getMaxAge() : integer;
        property maxAge : integer read getMaxAge;
    end;

implementation

end.
