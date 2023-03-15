{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiData;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    FcgiRecord;

type

    (*!-----------------------------------------------
     * data binary stream record (FCGI_DATA)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiData = class(TFcgiRecord)
    public
        constructor create(const dataStream : IStreamAdapter; const requestId : word);
    end;

implementation

uses

    fastcgi;

    constructor TFcgiData.create(const dataStream : IStreamAdapter; const requestId : word);
    begin
        inherited create(FCGI_VERSION_1, FCGI_DATA, requestId, dataStream);
    end;

end.
