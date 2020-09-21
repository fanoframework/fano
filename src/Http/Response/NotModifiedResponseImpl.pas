{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NotModifiedResponseImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    CloneableIntf,
    ResponseIntf,
    ResponseStreamIntf,
    HeadersIntf,
    HttpCodeResponseImpl;

type
    (*!------------------------------------------------
     * not modified response class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNotModifiedResponse = class(THttpCodeResponse)
    private
        procedure excludeHeaders();
    public
        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param hdrs header conllection instance
         *-------------------------------------*)
        constructor create(const hdrs : IHeaders);

        function write() : IResponse; override;

        function clone() : ICloneable; override;
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
    constructor TNotModifiedResponse.create(const hdrs : IHeaders);
    begin
        //304 response does not need body, so we just use null stream
        inherited create(304, 'Not Modified', hdrs);
        excludeHeaders();
    end;

    procedure TNotModifiedResponse.excludeHeaders();
    begin
        //remove headers that MUST NOT be included with 304 Not Modified responses
        headers().removeHeaders([
            'Allow',
            'Content-Encoding',
            'Content-Language',
            'Content-Length',
            'Content-Type',
            'Content-MD5',
            'Last-Modified'
        ]);
    end;

    function TNotModifiedResponse.write() : IResponse;
    begin
        excludeHeaders();
        inherited write();
        result := self;
    end;

    function TNotModifiedResponse.clone() : ICloneable;
    var clonedObj : IResponse;
    begin
        clonedObj := TNotModifiedResponse.create(
            headers().clone() as IHeaders
        );
        result := clonedObj;
    end;

end.
