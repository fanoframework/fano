{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StringOutputBufferStreamImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    classes,
    OutputBufferStreamIntf,
    OutputBufferStreamImpl;

type

    (*!------------------------------------------------
     * IOutputBufferStream implementation using
     * TStringStream for store output buffering content
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TStringOutputBufferStream = class (TOutputBufferStreamAdapter, IOutputBufferStream)
    protected
        function createStream() : TStream; override;
    public
        function getContent() : string; override;
    end;

implementation

    function TStringOutputBufferStream.createStream() : TStream;
    begin
        result := TStringStream.create('');
    end;

    function TStringOutputBufferStream.getContent() : string;
    begin
        //fstream always TStringStream, so this is safe typecast
        result := TStringStream(fstream).dataString;
    end;

end.
