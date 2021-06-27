{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit TemplateErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    sysutils,
    ErrorHandlerIntf,
    EnvironmentEnumeratorIntf,
    BaseErrorHandlerImpl;

type

    (*!------------------------------------------------
     * default error handler that display error message
     * using HTML template file
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TTemplateErrorHandler = class(TBaseErrorHandler)
    private
        templateStr : string;
    public
        constructor create(const templateFile : string);
        function handleError(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer = 500;
            const msg : string  = 'Internal Server Error'
        ) : IErrorHandler; override;
    end;

implementation

uses

    classes;

    constructor TTemplateErrorHandler.create(const templateFile : string);
    var fstream : TFileStream;
        len : longint;
    begin
        fstream := TFileStream.create(templateFile, fmOpenRead or fmShareDenyWrite);
        try
            len := fstream.size;
            setLength(templateStr, len);
            fstream.read(templateStr[1], len);
        finally
            fstream.free();
        end;
    end;

    function TTemplateErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    begin
        writeln('Content-Type: text/html');
        writeln('Status: ', intToStr(status), ' ', msg);
        writeHeaders(exc);
        writeln();
        writeln(templateStr);
        result := self;
    end;
end.
