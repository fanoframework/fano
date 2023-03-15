{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiGetValuesResult;

interface

{$MODE OBJFPC}
{$H+}

uses

    FcgiRecord,
    StreamAdapterIntf;

type

    (*!-----------------------------------------------
     * Get Values Result record (FCGI_GET_VALUES_RESULT)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiGetValuesResult = class(TFcgiRecord)
    public
        constructor create(const dataStream : IStreamAdapter; const requestId : word);
    end;

implementation

uses

    fastcgi;

    constructor TFcgiGetValuesResult.create(const dataStream : IStreamAdapter; const requestId : word);
    begin
        inherited create(FCGI_VERSION_1, FCGI_GET_VALUES_RESULT, requestId, dataStream);
    end;
end.
