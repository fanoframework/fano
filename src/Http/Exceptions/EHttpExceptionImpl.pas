{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EHttpExceptionImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    sysutils;

type

    (*!------------------------------------------------
     * Exception that is related to HTTP error.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    EHttpException = class(Exception)
    private
        //http code
        fCode : word;

        //http satus string
        fHttpMessage : string;

        //http header lines separated by CRLF, for example:
        //Retry-After: 10#13#10
        //X-RateLimit-Limit: 1#13#10
        fHeaders : string;
    public

        constructor create(
            const ahttpCode :word;
            const ahttpMessage : string;
            const aErrorMsg : string;
            const respHeaders : string = ''
        );

        constructor createFmt(
            const ahttpCode :word;
            const ahttpMessage : string;
            const aErrorMsg : string;
            const args: array of const;
            const respHeaders : string = ''
        );

        property httpCode : word read fCode write fCode;
        property httpMessage : string read fHttpMessage write fHttpMessage;
        property headers : string read fHeaders write fHeaders;
    end;

implementation

    constructor EHttpException.create(
        const ahttpCode :word;
        const ahttpMessage : string;
        const aErrorMsg : string;
        const respHeaders : string = ''
    );
    begin
        inherited create(aErrorMsg);
        fCode := ahttpCode;
        fHttpMessage := ahttpMessage;
        fHeaders := respHeaders;
    end;

    constructor EHttpException.createFmt(
        const ahttpCode :word;
        const ahttpMessage : string;
        const aErrorMsg : string;
        const args: array of const;
        const respHeaders : string = ''
    );
    begin
        inherited createFmt(aErrorMsg, args);
        fCode := ahttpCode;
        fHttpMessage := ahttpMessage;
        fHeaders := respHeaders;
    end;

end.
