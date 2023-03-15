{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpwebRequestFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EnvironmentIntf,
    StdInIntf,
    RequestIntf,
    RequestFactoryIntf,
    FpwebRequestAwareIntf,
    fphttpserver;

type
    (*!------------------------------------------------
     * factory class for TRequest
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFpwebRequestFactory = class(TInterfacedObject, IRequestFactory, IFpwebRequestAware)
    private
        fRequest : TFPHTTPConnectionRequest;
    public
        (*!------------------------------------------------
         * get TFpHttpServer request
         *-----------------------------------------------
         * @return request
         *-----------------------------------------------*)
        function getRequest() : TFPHTTPConnectionRequest;

        (*!------------------------------------------------
         * set TFpHttpServer request
         *-----------------------------------------------*)
        procedure setRequest(arequest : TFPHTTPConnectionRequest);

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
    UriImpl,
    FpwebRequestImpl;

    (*!------------------------------------------------
     * get TFpHttpServer request
     *-----------------------------------------------
     * @return request
     *-----------------------------------------------*)
    function TFpwebRequestFactory.getRequest() : TFPHTTPConnectionRequest;
    begin
        result := fRequest;
    end;

    (*!------------------------------------------------
     * set TFpHttpServer request
     *-----------------------------------------------*)
    procedure TFpwebRequestFactory.setRequest(arequest : TFPHTTPConnectionRequest);
    begin
        fRequest := arequest;
    end;

    function TFpwebRequestFactory.build(
        const env : ICGIEnvironment;
        const stdIn : IStdIn
    ) : IRequest;
    begin
        //stdin not used here as POST data already parsed by TFPHttpServer
        result := TFpWebRequest.create(fRequest, env);
    end;
end.
