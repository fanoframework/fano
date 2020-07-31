{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiStdErr;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    FcgiRecord;

type

    (*!-----------------------------------------------
     * Standard error binary stream (FCGI_STDERR)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiStdErr = class(TFcgiRecord)
    public
        constructor create(const dataStream : IStreamAdapter; const requestId : word);
    end;

implementation

uses

    fastcgi;

    constructor TFcgiStdErr.create(const dataStream : IStreamAdapter; const requestId : word);
    begin
        inherited create(FCGI_VERSION_1, FCGI_STDERR, requestId, dataStream);
    end;
end.
