{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpMethodImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    libcurl,
    InjectableObjectImpl,
    ResponseStreamIntf,
    HttpClientHeadersIntf,
    HttpClientHandleAwareIntf,
    QueryStrBuilderIntf;

type

    (*!------------------------------------------------
     * base class for HTTP operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpMethod = class(TInjectableObject, IHttpClientHeaders)
    private
        fHttpHeader : IHttpClientHeaders;

        (*!------------------------------------------------
         * raise exception if curl operation fail
         *-----------------------------------------------
         * @param errCode curl error code
         *-----------------------------------------------*)
        procedure raiseExceptionIfError(const errCode : CurlCode);

        (*!------------------------------------------------
         * initialize callback
         *-----------------------------------------------
         * @return curl handle
         *-----------------------------------------------*)
        procedure initCallback(const hndCurl : pCurl);
    protected
        fQueryStrBuilder : IQueryStrBuilder;

        (*!------------------------------------------------
         * internal variable that holds curl handle
         *-----------------------------------------------*)
        hCurl : pCurl;

        (*!------------------------------------------------
         * internal variable that holds stream of data coming
         * from server
         *-----------------------------------------------*)
        pStream : pointer;

        (*!------------------------------------------------
         * internal variable that holds stream of data coming
         * from server
         *-----------------------------------------------*)
        streamInst : IResponseStream;

        (*!------------------------------------------------
         * execute curl operation and raise exception if fail
         *-----------------------------------------------
         * @param hndCurl curl handle
         * @return errCode curl error code
         *-----------------------------------------------*)
        function executeCurl(const hndCurl : pCurl) : CurlCode;

        (*!------------------------------------------------
         * raise exception if curl not initialized
         *-----------------------------------------------*)
        procedure raiseExceptionIfCurlNotInitialized();
    public

        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param curlHandle instance class that can get handle
         * @param headersInst instance class that can set headers
         * @param fStream stream instance that will be used to
         *                store data coming from server
         *-----------------------------------------------*)
        constructor create(
            const curlHandle : IHttpClientHandleAware;
            const headersInst : IHttpClientHeaders;
            const fStream : IResponseStream;
            const queryStrBuilder : IQueryStrBuilder
        );

        (*!------------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         *  add header
         *-----------------------------------------------
         * @param aheader string contain header name
         * @param avalue string contain header value
         * @return current instance
         *-----------------------------------------------*)
        function add(const aheader : string; const avalue : string) : IHttpClientHeaders;

        (*!------------------------------------------------
         *  apply added header
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function apply() : IHttpClientHeaders;

        (*!------------------------------------------------
         *  interface delegation is turn off because
         *  some how method implementation is not accessible
         *  to descendant
         *  @link https://stackoverflow.com/questions/55160258/implementation-through-interface-delegation-not-pass-to-descendant
         *-----------------------------------------------*)
        //property headers : IHttpClientHeaders read httpHeader implements IHttpClientHeaders;
    end;

implementation

uses

    EHttpClientErrorImpl;

resourcestring

    sErrCurlNotInitialized = 'cURL not initialized.';


    (*!------------------------------------------------
     * internal callback that is called when libcurl needs to
     * write data coming from server
     *-----------------------------------------------
     * @param dataFromServer pointer to data from server
     * @param size Size in bytes of each element to be written
     * @param nmemb number of data items
     * @param ptrStream pointer to stream passed in CURLOPT_WRITEDATA
     * @return number of bytes actually process
     *------------------------------------------------
     * @link: https://ec.haxx.se/callback-write.html
     *-----------------------------------------------*)
    function writeToStream(
        dataFromServer : pointer;
        size : qword;
        nmemb: qword;
        ptrStream : pointer
    ) : qword; cdecl;
    begin
        result := IResponseStream(ptrStream).write(dataFromServer^, size * nmemb);
    end;

     (*!------------------------------------------------
     * initialize callback
     *-----------------------------------------------
     * @return curl handle
     *-----------------------------------------------*)
    procedure THttpMethod.initCallback(const hndCurl : pCurl);
    begin
        curl_easy_setopt(hndCurl, CURLOPT_WRITEFUNCTION, [ @writeToStream ]);
        curl_easy_setopt(hndCurl , CURLOPT_WRITEDATA, [ pStream ]);
    end;

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------
     * @param fStream stream instance that will be used to
     *                store data coming from server
     *-----------------------------------------------*)
    constructor THttpMethod.create(
        const curlHandle : IHttpClientHandleAware;
        const headersInst : IHttpClientHeaders;
        const fStream : IResponseStream;
        const queryStrBuilder : IQueryStrBuilder
    );
    begin
        //libcurl only knows raw pointer, so we use raw pointer to hold
        //instance of IResponseStream interface. But because typecast interface
        //to pointer does not do automatic reference counting,
        //we must add reference count manually by calling _AddRef() method
        pStream := pointer(fStream);
        fStream._addRef();

        streamInst := fStream;

        hCurl := curlHandle.handle();
        fHttpHeader := headersInst;
        fQueryStrBuilder := queryStrBuilder;
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor THttpMethod.destroy();
    begin

        //libcurl only knows raw pointer, so we use raw pointer to hold
        //instance of IResponseStream interface. But because typecast interface
        //to pointer does not do automatic reference counting,
        //we must decrement reference count manually by calling _Release() method
        IResponseStream(pStream)._release();
        pStream := nil;

        streamInst := nil;
        hCurl := nil;
        fHttpHeader := nil;
        fQueryStrBuilder := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     *  add header
     *-----------------------------------------------
     * @param aheader string contain header name
     * @param avalue string contain header value
     * @return current instance
     *-----------------------------------------------*)
    function THttpMethod.add(const aheader : string; const avalue : string) : IHttpClientHeaders;
    begin
        fHttpHeader.add(aheader, avalue);
        result := self;
    end;

    (*!------------------------------------------------
     *  apply added header
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function THttpMethod.apply() : IHttpClientHeaders;
    begin
        fHttpHeader.apply();
        result := self;
    end;

    (*!------------------------------------------------
     * raise exception if curl operation fail
     *-----------------------------------------------
     * @param errCode curl error code
     *-----------------------------------------------*)
    procedure THttpMethod.raiseExceptionIfError(const errCode : CurlCode);
    var errMsg : string;
    begin
        if (errCode <> CURLE_OK) then
        begin
            //operation fail, raise exception
            errMsg := curl_easy_strerror(errCode);
            raise EHttpClientError.create(errMsg);
        end;
    end;

    (*!------------------------------------------------
     * raise exception if curl not initialized
     *-----------------------------------------------*)
    procedure THttpMethod.raiseExceptionIfCurlNotInitialized();
    begin
        if (not assigned(hCurl)) then
        begin
            raise EHttpClientError.create(sErrCurlNotInitialized);
        end;
    end;

    (*!------------------------------------------------
     * execute curl operation and raise exception if fail
     *--------------------------------------------------
     * @param hndCurl curl handle
     * @return errCode curl error code
     *---------------------------------------------------*)
    function THttpMethod.executeCurl(const hndCurl : pCurl) : CurlCode;
    begin
        initCallback(hndCurl);
        result := curl_easy_perform(hndCurl);
        raiseExceptionIfError(result);
    end;
end.
