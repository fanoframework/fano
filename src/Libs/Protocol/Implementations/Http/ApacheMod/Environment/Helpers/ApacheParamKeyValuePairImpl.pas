{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ApacheParamKeyValuePairImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    StreamAdapterIntf,
    KeyValuePairImpl,
    httpd24,
    apr24;

type

    (*!------------------------------------------------
     * key value pair class having capability
     * to retrieve CGI environment variable from Apache
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TApacheParamKeyValuePair = class(TKeyValuePair)
    private
        procedure buildHttpEnv(req: prequest_rec);
        procedure initEnvVars(req : prequest_rec);
    public
        constructor create(const request_rec : prequest_rec);
    end;

implementation

uses

    SysUtils;

    constructor TApacheKeyValuePair.create(const request_rec : prequest_rec);
    begin
        inherited create();
        initEnvVars(request_rec);
    end;

    procedure TApacheKeyValuePair.buildHttpEnv(req: prequest_rec);
    var
        headers : papr_array_header_t;
        headersEntry : papr_table_entry_t;
        headerEnv, key : string;
        i : integer;
    begin
        headers := apr_table_elts(req^.headers_in);
        headersEntry := papr_table_entry_t(headers^.elts);
        for i := 0 to headers^.nelts - 1 do
        begin
            key := asString(headersEntry^.key);
            //skip Content-Type and Content-Length as this will be set in CGI Environment
            if not (SameText(key, 'Content-Type') or SameText(key, 'Content-Length')) then
            begin
                //transform for example Content-Encoding into HTTP_CONTENT_ENCODING
                headerEnv := 'HTTP_' + upperCase(stringReplace(key, '-', '_', [rfReplaceAll]));
                setValue(headerEnv, asString(headersEntry^.val));
            end;
            inc(headersEntry);
        end;

    end;

    function asString(avalue : pchar) : string;
    begin
        if avalue <> nil then
        begin
            result := strpas(avalue);
        end else
        begin
            result := '';
        end;
    end;

    procedure TApacheKeyValuePair.initEnvVars(req: prequest_rec);
    var headerValue : string;
        isStrIp : integer;
    begin
        setValue('PATH', GetEnvironmentVariable('PATH'));
        setValue('GATEWAY_INTERFACE', 'CGI/1.1');

        //read Content-Type header if any
        headerValue := asString(apr_table_get(req^.headers_in, 'Content-Type'));
        if (headerValue = '') then
        begin
            headerValue := asString(req^.content_type);
        end;
        setValue('CONTENT_TYPE', headerValue);

        //read Content-Length header if any
        headerValue := asString(apr_table_get(req^.headers_in, 'Content-Length'));
        if headerValue = '' then
        begin
            headerValue := '0';
        end;
        setValue('CONTENT_LENGTH', headerValue);

        setValue('SERVER_PROTOCOL', asString(req^.protocol));
        setValue('SERVER_PORT', IntToStr(ap_get_server_port(req)));
        setValue('SERVER_NAME', asString(ap_get_server_name_for_url(req)));

        //ap_get_server_banner() returns gibberish data. not sure why. Encoding?
        //cgienv.add('SERVER_SOFTWARE=' + asString(ap_get_server_banner()));
        setValue('SERVER_SOFTWARE', 'Apache');

        setValue('PATH_INFO', asString(req^.path_info));
        setValue('REQUEST_URI', asString(req^.uri));
        setValue('REQUEST_METHOD', asString(req^.method));
        setValue('QUERY_STRING', asString(req^.args));
        setValue('SCRIPT_NAME', asString(req^.filename));
        setValue('PATH_TRANSLATED', asString(req^.filename));
        setValue('REMOTE_ADDR', asString(req^.useragent_ip));

        setValue('REMOTE_HOST', asString(
            ap_get_remote_host(
                req^.connection,
                req^.per_dir_config,
                REMOTE_HOST,
                @isStrIp
            )
        ));

        //HTTP protocol specific environment
        buildHttpEnv(req);
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
