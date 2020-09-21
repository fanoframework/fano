{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UserAgentIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ClientBrowserIntf,
    ClientDeviceIntf,
    ClientOsIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to get
     * client user agent string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IUserAgent = interface
        ['{0875AFD8-D2C2-4ED6-9AB7-9BF1FBA17D6D}']

        procedure setUserAgent(const ua : string);
        function getUserAgent() : string;

        function getBrowser() : IClientBrowser;
        function getOS() : IClientOS;
        function getDevice() : IClientDevice;

        property userAgent : string read getUserAgent write setUserAgent;
    end;

implementation
end.
