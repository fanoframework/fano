{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit UwsgiStdOutWriterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    StdOutIntf,
    StreamStdOutImpl;

type

    (*!-----------------------------------------------
     * IStdOut implementation having capability to write
     * uwsgi response to web server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUwsgiStdOutWriter = class(TStreamStdOut)
    protected

        (*!------------------------------------------------
         * write string to stream and
         *-----------------------------------------------
         * @param stream, stream to write
         * @param str, string to write
         * @param markEnd, if true, add FCGI_END_REQUEST
         * @return current instance
         *-----------------------------------------------*)
        function writeStream(const stream : IStreamAdapter; const str : string) : IStdOut; override;
    end;

implementation

uses

    SysUtils,
    RegExpr;

    function extractStatusLineHeaderIfAny(const str : string) : string;
    var regx : TRegExpr;
    begin
        regx := TRegExpr.create();
        try
            regx.expression := 'Status\s*\:\s*(\d+\s+[a-zA-Z\s]+)\x0d*\x0a';
            if regx.Exec(str) then
            begin
                result := trim(regx.match[1]);
            end else
            begin
                result := '';
            end;
        finally
            regx.free();
        end;
    end;

    (*!------------------------------------------------
     * write string to STDOUT stream
     *-----------------------------------------------
     * @param stream, stream to write
     * @param str, string to write
     * @return current instance
     *-----------------------------------------------*)
    function TUwsgiStdOutWriter.writeStream(const stream : IStreamAdapter; const str : string) : IStdOut;
    var tmpStr, statusLine : string;
    begin
        statusLine := extractStatusLineHeaderIfAny(str);
        if statusLine = '' then
        begin
            tmpStr := 'HTTP/1.1 200 OK' + LineEnding + str;
        end else
        begin
            tmpStr :=  'HTTP/1.1 ' + statusLine + LineEnding + str;
        end;
        stream.writeBuffer(tmpStr[1], length(tmpStr));
        result:= self;
    end;
end.
