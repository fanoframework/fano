{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ResponseStreamLogImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    DependencyIntf,
    ResponseStreamIntf,
    LoggerIntf,
    StreamAdapterLogImpl;

type

    (*!----------------------------------------------
     * adapter class having capability as
     * HTTP response body and also log easch call
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TResponseStreamLog = class(TStreamAdapterLog, IResponseStream, IDependency)
    private
        actualStream : IResponseStream;
    public
        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param stream instance of actual IStreamAdapter interface
         * @param logger instance of ILogger interface
         *-------------------------------------*)
        constructor create(const stream : IResponseStream; const logger : ILogger);

        (*!------------------------------------
         * destructor
         *-------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------
         * write string to stream
         *-------------------------------------
         * @param buffer string to write
         * @return number of bytes actually written
         *-------------------------------------*)
        function write(const buffer : string) : int64; overload;

        (*!------------------------------------
         * read stream to string
         *-------------------------------------
         * @return string
         *-------------------------------------*)
        function read() : string; overload;
    end;

implementation

uses

    SysUtils,
    StringSerializeableImpl;

    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param stream instance of actual IStreamAdapter interface
     * @param logger instance of ILogger interface
     *-------------------------------------*)
    constructor TResponseStreamLog.create(const stream : IResponseStream; const logger : ILogger);
    begin
        inherited create(stream, logger);
        actualStream := stream;
    end;

    (*!------------------------------------
     * destructor
     *-------------------------------------*)
    destructor TResponseStreamLog.destroy();
    begin
        inherited destroy();
        actualStream := nil;
    end;

    (*!------------------------------------
     * write string to stream
     *-------------------------------------
     * @param buffer string to write
     * @return number of bytes actually written
     *-------------------------------------*)
    function TResponseStreamLog.write(const buffer : string) : int64;
    begin
        result := actualStream.write(buffer);
        actualLogger.debug(
            'ResponseStreamLog write string ' + intToStr(result) + ' bytes',
            TStringSerializeable.create(buffer)
        );
    end;

    (*!------------------------------------
     * read stream to string
     *-------------------------------------
     * @return string
     *-------------------------------------*)
    function TResponseStreamLog.read() : string;
    begin
        result := actualStream.read();
        actualLogger.debug('ResponseStreamLog read string', TStringSerializeable.create(result));
    end;

end.
