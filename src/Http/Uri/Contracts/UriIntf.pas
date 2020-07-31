{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UriIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability as
     * manage URL (RFC 3986)
     *
     * @link https://tools.ietf.org/html/rfc3986
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IUri = interface (ISerializeable)
        ['{05C9EA76-E834-4E3F-9C23-4337CA2D2491}']

        function getScheme() : string;
        property scheme : string read getScheme;

        function getAuthority() : string;
        property authority : string read getAuthority;

        function getSchemeAuthority() : string;
        property schemeAuthority : string read getSchemeAuthority;

        function getUserInfo() : string;
        property userInfo : string read getUserInfo;

        function getHost() : string;
        property host : string read getHost;

        function getPort() : string;
        property port : string read getPort;

        function getPath() : string;
        property path : string read getPath;

        function getQuery() : string;
        property query : string read getQuery;

        function getFragment() : string;
        property fragment : string read getFragment;
    end;

implementation
end.
