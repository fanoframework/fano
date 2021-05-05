{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StaticFilesMiddlewareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    MiddlewareIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    ReadOnlyKeyValuePairIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * middleware class that serves static files from
     * a base directory.
     *-------------------------------------------------
     * Content type of response will be determined
     * using file extension that is stored in fMimeTypes
     * if not set then 'application/octet-stream' is assumed
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStaticFilesMiddleware = class(TInjectableObject, IMiddleware)
    protected
        fBaseDirectory : string;
        fMimeTypes : IReadOnlyKeyValuePair;
        function getContentTypeFromFilename(const filename : string) : string;
    public
        constructor create(
            const baseDir : string;
            const mimeTypes : IReadOnlyKeyValuePair
        );

        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const nextMdlwr : IRequestHandler
        ) : IResponse; virtual;
    end;

implementation

uses

    SysUtils,
    FileResponseImpl;

    constructor TStaticFilesMiddleware.create(
        const baseDir : string;
        const mimeTypes : IReadOnlyKeyValuePair
    );
    begin
        fBaseDirectory := baseDir;
        fMimeTypes := mimeTypes;
    end;

    function TStaticFilesMiddleware.getContentTypeFromFilename(
        const filename : string
    ) : string;
    var ext : string;
    begin
        ext := ExtractFileExt(filename);
        //remove dot from ext
        ext := copy(ext, 2, length(ext)-1);
        if (fMimeTypes.has(ext)) then
        begin
            result := fMimeTypes.getValue(ext);
        end else
        begin
            //set default
            result := 'application/octet-stream';
        end;
    end;

    function TStaticFilesMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const nextMdlwr : IRequestHandler
    ) : IResponse;
    var filename : string;
    begin
        filename := fBaseDirectory + request.uri().getPath();
        if fileExists(filename) then
        begin
            //serve file
            result := TFileResponse.create(
                response.headers(),
                getContentTypeFromFilename(filename),
                filename
            );
        end else
        begin
            //file not found, just pass to next middleware
            result := nextMdlwr.handleRequest(request, response, args);
        end;
    end;
end.
