{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BinaryResponseImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    ResponseIntf,
    ResponseStreamIntf,
    HeadersIntf,
    CloneableIntf,
    BaseResponseImpl;

type
    (*!------------------------------------------------
     * base binary response class such image
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TBinaryResponse = class(TBaseResponse)
    private
        contentType : string;
    public
        constructor create(
            const hdrs : IHeaders;
            const strContentType : string;
            const respBody : IResponseStream
        );

        (*!------------------------------------
         * output http response to STDOUT
         *-------------------------------------
         * @return current instance
         *-------------------------------------*)
        function write() : IResponse; override;

        function clone() : ICloneable; override;

    end;

implementation

uses

    classes,
    sysutils;

    constructor TBinaryResponse.create(
        const hdrs : IHeaders;
        const strContentType : string;
        const respBody : IResponseStream
    );
    begin
        inherited create(hdrs, respBody);
        contentType := strContentType;
    end;

    function TBinaryResponse.write() : IResponse;
    var hdrs : IHeaders;
    begin
        hdrs := headers();
        hdrs.setHeader('Content-Type', contentType);
        hdrs.setHeader('Content-Length', intToStr(body().size()));
        result := inherited write();
    end;

    function TBinaryResponse.clone() : ICloneable;
    begin
        result := TBinaryResponse.create(
            headers().clone() as IHeaders,
            contentType,
            //not clone response body as they may be big in size
            body()
        );
    end;

end.
