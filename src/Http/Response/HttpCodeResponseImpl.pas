{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpCodeResponseImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    ResponseIntf,
    HeadersIntf,
    ResponseStreamIntf,
    CloneableIntf,
    ResponseImpl;

type
    (*!------------------------------------------------
     * base Http response class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpCodeResponse = class(TResponse)
    private
        fHttpStatus : string;
    public
        constructor create(
            const httpCode : word;
            const httpMsg : string;
            const hdrs : IHeaders;
            const bodyStrs : IResponseStream = nil
        );

        (*!------------------------------------
         * output http response to STDOUT
         *-------------------------------------
         * @return current instance
         *-------------------------------------*)
        function write() : IResponse; override;

    end;

implementation

uses

    SysUtils,
    NullResponseStreamImpl;

    constructor THttpCodeResponse.create(
        const httpCode : word;
        const httpMsg : string;
        const hdrs : IHeaders;
        const bodyStrs : IResponseStream = nil
    );
    begin
        if bodyStrs = nil then
        begin
            //if we get here then this response is without body
            inherited create(hdrs, TNullResponseStream.create());
        end else
        begin
            inherited create(hdrs, bodyStrs);
        end;

        fHttpStatus := inttostr(httpCode) + ' ' + httpMsg;
    end;

    (*!------------------------------------
     * output http response to STDOUT
     *-------------------------------------
     * @return current instance
     *-------------------------------------*)
    function THttpCodeResponse.write() : IResponse;
    begin
        headers().setHeader('Status', fHttpStatus);
        inherited write();
        result := self;
    end;
end.
