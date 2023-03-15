{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit OutputBufferStreamImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    classes,
    OutputBufferStreamIntf;

type

    (*!------------------------------------------------
     * base class for adapter class so TStream-based class
     * can be used for store output buffering content
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TOutputBufferStreamAdapter = class(TInterfacedObject, IOutputBufferStream)
    protected
        fstream : TStream;
        function createStream() : TStream; virtual; abstract;
    public
        constructor create(); virtual;
        destructor destroy(); override;
        function assignToFile(var f : TextFile) : IOutputBufferStream;
        function clear() : IOutputBufferStream;
        function seek(const streamPos : integer) : IOutputBufferStream;
        function getContent() : string; virtual; abstract;
    end;

implementation

uses
    streamIO;

    constructor TOutputBufferStreamAdapter.create();
    begin
        fstream := createStream();
    end;

    destructor TOutputBufferStreamAdapter.destroy();
    begin
        inherited destroy();
        fstream.free();
    end;

    function TOutputBufferStreamAdapter.assignToFile(var f : TextFile) : IOutputBufferStream;
    begin
        assignStream(f, fstream);
        result := self;
    end;

    function TOutputBufferStreamAdapter.clear() : IOutputBufferStream;
    begin
        fstream.size := 0;
        result := self;
    end;

    function TOutputBufferStreamAdapter.seek(const streamPos : integer) : IOutputBufferStream;
    begin
        fstream.position := 0;
        result := self;
    end;

end.
