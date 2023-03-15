{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MhdParamKeyValuePairImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    libmicrohttpd,
    StreamAdapterIntf,
    KeyValuePairImpl,
    MhdSvrConfigTypes;

type

    TMhdData = record
        //this will be provided by libmicrohttpd
        connection : PMHD_Connection;
        url: Pcchar;
        method: Pcchar;
        version: Pcchar;

        //this will be set by application
        serverConfig : TMhdSvrConfig;
    end;

    (*!------------------------------------------------
     * key value pair class having capability
     * to retrieve CGI environment variable from libmicrohttpd
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TMhdParamKeyValuePair = class(TKeyValuePair)
    private
        procedure initEnvVars(const mhdData : TMhdData);
        procedure addRequestHeader(const key : string; const value : string);
        procedure addQueryString(const key : string; const value : string);
    public
        constructor create(const mhdData : TMhdData);
    end;

implementation

uses

    SysUtils,
    Sockets;

    function asString(p : pchar) : string;
    begin
        if assigned(p) then
        begin
            result := p
        end else
        begin
            result:='';
        end;
    end;

    (*!-----------------------------------
     * internal callback which we use to extract
     * request header
     *------------------------------------
     * @param cls user-defined data that is passed
     *        to MHD_get_connection_values()
     * @param kind type of data we are dealing
     * @param key name of data
     * @param value value of data
     * @return flag if we should continue or stop
     *--------------------------------------*)
    function extractRequestData (
        cls : pointer;
        kind : MHD_ValueKind;
        key : pcchar;
        value : pcchar
    ) : cint; cdecl;
    begin
        //cls = self
        if (kind = MHD_HEADER_KIND) then
        begin
            TMhdParamKeyValuePair(cls).addRequestHeader(asString(key), asString(value));
        end else
        if (kind = MHD_GET_ARGUMENT_KIND) then
        begin
            TMhdParamKeyValuePair(cls).addQueryString(asString(key), asString(value));
        end;

        //we will process all data so just return MHD_YES
        result := MHD_YES;
    end;

    constructor TMhdParamKeyValuePair.create(const mhdData : TMhdData);
    begin
        inherited create();
        initEnvVars(mhdData);
    end;

    procedure TMhdParamKeyValuePair.addRequestHeader(const key : string; const value : string);
    var strKey : string;
    begin
        //turn request header into format according to CGI Environment (RFC 3875)
        //'Host' ==> 'HTTP_HOST',
        //'User-Agent' ==> 'HTTP_USER_AGENT' .. etc,
        //except
        //'Content-Length' ==> 'CONTENT_LENGTH'
        //'Content-Type' ==> 'CONTENT_TYPE'
        strKey := uppercase(stringReplace(key, '-', '_', [rfReplaceAll]));
        if not ((key = MHD_HTTP_HEADER_CONTENT_LENGTH) or
            (key = MHD_HTTP_HEADER_CONTENT_TYPE)) then
        begin
            strKey := 'HTTP_' + strKey;
        end;
        setValue(strKey, value);
    end;

    procedure TMhdParamKeyValuePair.addQueryString(const key : string; const value : string);
    var queryStr : string;
    begin
        //TODO: this is little bit not optimized because query string
        //are already parsed by libmicrohttpd. We need to do this
        //so we do not need to change how everything works
        queryStr := getValue('QUERY_STRING');
        if (queryStr = '') then
        begin
            queryStr := key + '=' + value;
        end else
        begin
            queryStr := '&' + key + '=' + value;
        end;
        setValue('QUERY_STRING', queryStr);
    end;

    procedure TMhdParamKeyValuePair.initEnvVars(const mhdData : TMhdData);
    var connectionInfo : PMHD_ConnectionInfo;
        ipAddress, queryStr, reqUri : string;
    begin
        setValue('GATEWAY_INTERFACE', 'CGI/1.1');
        setValue('SERVER_ADMIN', mhdData.serverConfig.serverAdmin);
        setValue('SERVER_NAME', mhdData.serverConfig.serverName);
        setValue('SERVER_ADDR', mhdData.serverConfig.host);
        setValue('SERVER_PORT', intToStr(mhdData.serverConfig.port));
        setValue('SERVER_SOFTWARE', mhdData.serverConfig.serverSoftware);
        setValue('DOCUMENT_ROOT', mhdData.serverConfig.documentRoot);
        setValue('SERVER_PROTOCOL', PCHAR(mhdData.version));

        setValue('REQUEST_METHOD', PChar(mhdData.method));
        setValue('PATH_INFO', '');
        setValue('PATH_TRANSLATED', '');
        setValue('PATH', GetEnvironmentVariable('PATH'));

        //get client information
        connectionInfo := MHD_get_connection_info(
            mhdData.connection,
            MHD_CONNECTION_INFO_CLIENT_ADDRESS
        );

        ipAddress := NetAddrToStr(connectionInfo^.client_addr^.sin_addr);
        //get client IP
        setValue('REMOTE_ADDR', ipAddress);
        //get client port
        setValue('REMOTE_PORT', inttostr(connectionInfo^.client_addr^.sin_port));
        //this should be hostname of client but since reverse-name lookup
        //is expensive, just use IP address instead. This does not violates RFC 3875
        setValue('REMOTE_HOST', ipAddress);
        //assume not authorized, this will be handled by http authentication middleware
        setValue('REMOTE_USER', '');
        setValue('AUTH_TYPE', '');
        setValue('REMOTE_IDENT', '');

        //we will build HTTP header environment inside extractHeaders
        //note: while libmicrohttpd allows to get request header and query string
        //with same function callback using MHD_HEADER_KIND or MHD_GET_ARGUMENT_KIND,
        //there is no way to indicate if current data is header or query string,
        //so we need separate to calls
        MHD_get_connection_values (
            mhdData.connection,
            MHD_HEADER_KIND,
            @extractRequestData,
            //pass current class instance so we can retrieve it
            //from cls pointer of extractHeaders() function
            self
        );

        //we will build query string inside extractQueryStrs
        //initialize with empty string first
        setValue('QUERY_STRING', '');

        MHD_get_connection_values (
            mhdData.connection,
            MHD_GET_ARGUMENT_KIND,
            @extractRequestData,
            //pass current class instance so we can retrieve it
            //from cls pointer of extractQueryStrs() function
            self
        );

        queryStr := getValue('QUERY_STRING');

        if (queryStr <> '') then
        begin
            reqUri := PChar(mhdData.url) + '?' + queryStr;
        end else
        begin
            reqUri := PChar(mhdData.url);
        end;
        setValue('REQUEST_URI', reqUri);
    end;

end.
