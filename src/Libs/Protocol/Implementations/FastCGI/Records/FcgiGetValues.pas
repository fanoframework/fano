{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiGetValues;

interface

{$MODE OBJFPC}
{$H+}

uses

    FcgiRecord,
    StreamAdapterIntf;

type

    (*!-----------------------------------------------
     * Get Values Record (FCGI_GET_VALUES)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiGetValues = class(TFcgiRecord)
    public
        constructor create(const dataStream : IStreamAdapter; const requestId : word);
    end;

implementation

uses

    fastcgi;

    constructor TFcgiGetValues.create(const dataStream : IStreamAdapter; const requestId : word);
    begin
        inherited create(FCGI_VERSION_1, FCGI_GET_VALUES, requestId, dataStream);
    end;
end.
