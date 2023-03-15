{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiRequestFactoryImpl;

interface

{$MODE OBJFPC}

uses

    EnvironmentIntf,
    RequestIntf,
    RequestFactoryIntf,
    StdInIntf,
    FcgiRequestIdAwareIntf;

type
    (*!------------------------------------------------
     * factory class for FastCGI Request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiRequestFactory = class(TInterfacedObject, IRequestFactory)
    private
        fRequestIdAware : IFcgiRequestIdAware;
    public
        constructor create(const requestIdAware : IFcgiRequestIdAware);
        destructor destroy; override;
        function build(const env : ICGIEnvironment; const stdIn  : IStdIn) : IRequest;
    end;

implementation

uses

    RequestImpl,
    RequestHeadersImpl,
    FcgiRequestImpl,
    HashListImpl,
    MultipartFormDataParserImpl,
    UploadedFileCollectionFactoryImpl,
    UploadedFileCollectionWriterFactoryImpl,
    UriImpl;

    constructor TFcgiRequestFactory.create(
        const requestIdAware : IFcgiRequestIdAware
    );
    begin
        inherited create();
        fRequestIdAware := requestIdAware;
    end;

    destructor TFcgiRequestFactory.destroy();
    begin
        fRequestIdAware := nil;
        inherited destroy();
    end;

    function TFcgiRequestFactory.build(const env : ICGIEnvironment; const stdIn : IStdIn) : IRequest;
    var arequest : IRequest;
    begin
        arequest := TRequest.create(
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
        result := TFcgiRequest.create(fRequestIdAware.getRequestId(), arequest);
    end;
end.
