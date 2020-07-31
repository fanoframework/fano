{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RedirectResponseImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    CloneableIntf,
    ResponseIntf,
    ResponseStreamIntf,
    HeadersIntf;

type
    (*!------------------------------------------------
     * redirect response class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TRedirectResponse = class(TInterfacedObject, IResponse)
    private
        httpHeaders : IHeaders;
        fStatus : word;
        fUrl : string;
        fStream : IResponseStream;

        function redirectCodeMessage(const code : word) : string;
    public
        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param hdrs header conllection instance
         * @param url target url to redirect
         * @param status, optional HTTP redirection status, default is 302
         *-------------------------------------*)
        constructor create(const hdrs : IHeaders; const url : string; const status : word = 302);
        destructor destroy(); override;

        (*!------------------------------------
         * get http headers instance
         *-------------------------------------
         * @return header instance
         *-------------------------------------*)
        function headers() : IHeaders;

        function write() : IResponse;

        (*!------------------------------------
         * get response body
         *-------------------------------------
         * @return response body
         *-------------------------------------*)
        function body() : IResponseStream;

        (*!------------------------------------
         * set new response body
         *-------------------------------------
         * @return response body
         *-------------------------------------*)
        function setBody(const newBody : IResponseStream) : IResponse;

        function clone() : ICloneable;
    end;

implementation

uses

    sysutils,
    NullResponseStreamImpl;

    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param hdrs header conllection instance
     * @param url target url to redirect
     * @param status, optional HTTP redirection status, default is 302
     *-------------------------------------*)
    constructor TRedirectResponse.create(
        const hdrs : IHeaders;
        const url : string;
        const status : word = 302
    );
    begin
        inherited create();
        //redirect response does not need body, so we just use null stream
        fStream := TNullResponseStream.create();
        httpHeaders := hdrs;
        fStatus := status;
        fUrl := url;
    end;

    destructor TRedirectResponse.destroy();
    begin
        fStream := nil;
        httpHeaders := nil;
        inherited destroy();
    end;

    function TRedirectResponse.redirectCodeMessage(const code : word) : string;
    begin
        case code of
            300 : result := 'Multiple Choice';
            301 : result := 'Moved Permanently';
            302 : result := 'Found';
            303 : result := 'See Other';
            304 : result := 'Not Modified';
            305 : result := 'Use Proxy';
            306 : result := 'Switch Proxy';
            307 : result := 'Temporary Redirect';
            308 : result := 'Permanent Redirect';
            else
            begin
                result := 'Unknown redirect code';
            end;
        end;
    end;

    (*!------------------------------------
     * get http headers instance
     *-------------------------------------
     * @return header instance
     *-------------------------------------*)
    function TRedirectResponse.headers() : IHeaders;
    begin
        result := httpHeaders;
    end;

    function TRedirectResponse.write() : IResponse;
    begin
        httpHeaders.setHeader('Status', intToStr(fStatus) + ' ' + redirectCodeMessage(fStatus));
        httpHeaders.setHeader('Location', fUrl);
        httpHeaders.writeHeaders();
        result := self;
    end;

    (*!------------------------------------
     * get response body
     *-------------------------------------
     * @return response body
     *-------------------------------------*)
    function TRedirectResponse.body() : IResponseStream;
    begin
        result := fStream;
    end;

    (*!------------------------------------
     * set new response body
     *-------------------------------------
     * @return response body
     *-------------------------------------*)
    function TRedirectResponse.setBody(const newBody : IResponseStream) : IResponse;
    begin
        //intentionally does nothing as redirect response do not need body
        result := self;
    end;

    function TRedirectResponse.clone() : ICloneable;
    var clonedObj : IResponse;
    begin
        clonedObj := TRedirectResponse.create(
            httpHeaders.clone() as IHeaders,
            fUrl,
            fStatus
        );
        result := clonedObj;
    end;

end.
