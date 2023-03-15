{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpwebParamKeyValuePairImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    KeyValuePairImpl,
    fphttpserver,
    FpwebSvrConfigTypes;

type

    TFpwebData = record
        //this will be provided by TFPHttpServer
        request : TFPHTTPConnectionRequest;

        //this will be set by application
        serverConfig : TFpwebSvrConfig;
    end;

    (*!------------------------------------------------
     * key value pair class having capability
     * to retrieve CGI environment variable from TFpHttpServer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TFpwebParamKeyValuePair = class(TKeyValuePair)
    private
        procedure initEnvVars(const fpwebData : TFpwebData);
    public
        constructor create(const fpwebData : TFpwebData);
    end;

implementation

uses

    SysUtils;

    constructor TFpwebParamKeyValuePair.create(const fpwebData : TFpwebData);
    begin
        inherited create();
        initEnvVars(fpwebData);
    end;

    procedure TFpwebParamKeyValuePair.initEnvVars(const fpwebData : TFpwebData);
    begin
        setValue('GATEWAY_INTERFACE', 'CGI/1.1');
        setValue('SERVER_ADMIN', fpwebData.serverConfig.serverAdmin);
        setValue('SERVER_NAME', fpwebData.serverConfig.serverName);
        setValue('SERVER_ADDR', fpwebData.serverConfig.host);
        setValue('SERVER_PORT', intToStr(fpwebData.serverConfig.port));
        setValue('SERVER_SOFTWARE', fpwebData.serverConfig.serverSoftware);
        setValue('DOCUMENT_ROOT', fpwebData.serverConfig.documentRoot);
        setValue('SERVER_PROTOCOL', fpwebData.request.protocolVersion);

        setValue('REQUEST_METHOD', fpwebData.request.method);
        setValue('PATH_INFO', fpwebData.request.pathInfo);
        setValue('PATH_TRANSLATED', fpwebData.request.pathTranslated);
        setValue('PATH', GetEnvironmentVariable('PATH'));

        setValue('REMOTE_ADDR', fpwebData.request.remoteAddress);
        setValue('REMOTE_PORT', '');
        setValue('REMOTE_HOST', fpwebData.request.remoteAddress);
        setValue('REMOTE_USER', '');
        setValue('AUTH_TYPE', '');
        setValue('REMOTE_IDENT', '');
        setValue('QUERY_STRING', fpwebData.request.querystring);
        setValue('REQUEST_URI', fpwebData.request.uri);
    end;

end.
