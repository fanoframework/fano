{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RequestFactoryImpl;

interface

{$MODE OBJFPC}

uses
    EnvironmentIntf,
    StdInIntf,
    RequestIntf,
    RequestFactoryIntf;

type
    (*!------------------------------------------------
     * factory class for TRequest
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TRequestFactory = class(TInterfacedObject, IRequestFactory)
    public
        function build(const env : ICGIEnvironment; const stdIn : IStdIn) : IRequest;
    end;

implementation

uses

    RequestImpl,
    RequestHeadersImpl,
    HashListImpl,
    MultipartFormDataParserImpl,
    UploadedFileCollectionFactoryImpl,
    UploadedFileCollectionWriterFactoryImpl,
    StdInReaderImpl,
    SimpleStdInReaderImpl,
    UriImpl;

    function TRequestFactory.build(
        const env : ICGIEnvironment;
        const stdIn : IStdIn
    ) : IRequest;
    begin
        result := TRequest.create(
            TUri.create(env),
            TRequestHeaders.create(env),
            env,
            THashList.create(),
            THashList.create(),
            THashList.create(),
            TMultipartFormDataParser.create(
                TUploadedFileCollectionWriterFactory.create()
            ),
            stdIn
        );
    end;
end.
