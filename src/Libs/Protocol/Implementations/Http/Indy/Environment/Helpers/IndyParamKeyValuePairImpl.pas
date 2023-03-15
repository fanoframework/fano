{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IndyParamKeyValuePairImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    KeyValuePairImpl,
    HttpSvrConfigTypes,

    IdBaseComponent,
    IdComponent,
    IdTCPServer,
    IdCustomHTTPServer,
    IdContext,
    IdSchedulerOfThreadPool,
    IdHTTPServer;

type

    TIndyData = record
        //this will be provided by TIdHTTPServer
        request : TIdHTTPRequestInfo;

        //this will be set by application
        serverConfig : THttpSvrConfig;
    end;

    (*!------------------------------------------------
     * key value pair class having capability
     * to retrieve CGI environment variable from TIdHTTPServer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TIndyParamKeyValuePair = class(TKeyValuePair)
    private
        procedure initEnvVars(const indyData : TIndyData);
    public
        constructor create(const indyData : TIndyData);
    end;

implementation

uses

    SysUtils;

    constructor TIndyParamKeyValuePair.create(const indyData : TIndyData);
    begin
        inherited create();
        initEnvVars(indyData);
    end;

    procedure TIndyParamKeyValuePair.initEnvVars(const indyData : TIndyData);
    begin
        setValue('GATEWAY_INTERFACE', 'CGI/1.1');
        setValue('SERVER_ADMIN', indyData.serverConfig.serverAdmin);
        setValue('SERVER_NAME', indyData.serverConfig.serverName);
        setValue('SERVER_ADDR', indyData.serverConfig.host);
        setValue('SERVER_PORT', intToStr(indyData.serverConfig.port));
        setValue('SERVER_SOFTWARE', indyData.serverConfig.serverSoftware);
        setValue('DOCUMENT_ROOT', indyData.serverConfig.documentRoot);
        setValue('SERVER_PROTOCOL', indyData.request.version);

        setValue('REQUEST_METHOD', indyData.request.command);

        if (indyData.request.rawHeaders.indexOfName('PATH_INFO') <> -1) then
        begin
            setValue('PATH_INFO', indyData.request.rawHeaders.values['PATH_INFO']);
        end else
        begin
            setValue('PATH_INFO', '');
        end;

        if (indyData.request.rawHeaders.indexOfName('PATH_TRANSLATED') <> -1) then
        begin
            setValue('PATH_TRANSLATED', indyData.request.rawHeaders.values['PATH_TRANSLATED']);
        end else
        begin
            setValue('PATH_TRANSLATED', '');
        end;

        setValue('PATH', GetEnvironmentVariable('PATH'));

        setValue('REMOTE_ADDR', indyData.request.remoteIP);
        setValue('REMOTE_PORT', '');
        setValue('REMOTE_HOST', indyData.request.remoteIP);
        setValue('REMOTE_USER', '');
        setValue('AUTH_TYPE', '');
        setValue('REMOTE_IDENT', '');
        setValue('QUERY_STRING', indyData.request.queryParams);
        setValue('REQUEST_URI', indyData.request.document);
    end;

end.
