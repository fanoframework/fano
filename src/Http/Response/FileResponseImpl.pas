{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FileResponseImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    ResponseIntf,
    ResponseStreamIntf,
    HeadersIntf,
    CloneableIntf,
    BinaryResponseImpl;

type
    (*!------------------------------------------------
     * response class that retrieve its body from file
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFileResponse = class(TBinaryResponse)
    private
        fFilename : string;
    public
        constructor create(
            const hdrs : IHeaders;
            const strContentType : string;
            const filename : string
        );

        function clone() : ICloneable; override;
    end;

implementation

uses

    FileResponseStreamImpl;

    constructor TFileResponse.create(
        const hdrs : IHeaders;
        const strContentType : string;
        const filename : string
    );
    var respBody : IResponseStream;
    begin
        fFilename := filename;
        respBody := TFileResponseStream.create(fFilename);
        inherited create(hdrs, strContentType, respBody);
    end;

    function TFileResponse.clone() : ICloneable;
    begin
        result := TFileResponse.create(
            headers().clone() as IHeaders,
            fContentType,
            fFilename
        );
    end;

end.
