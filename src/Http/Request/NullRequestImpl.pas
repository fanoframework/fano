{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullRequestImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    AjaxAwareIntf,
    ReadOnlyListIntf,
    UploadedFileIntf,
    UploadedFileCollectionIntf,
    ReadonlyHeadersIntf,
    EnvironmentIntf,
    UriIntf;

type

    (*!------------------------------------------------
     * null class having capability as
     * HTTP request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullRequest = class(TInterfacedObject, IRequest)
    private
        fRequestHeaders : IReadOnlyHeaders;
        fUri : IUri;
        fQueryParam : IReadOnlyList;
        fCookieParam : IReadOnlyList;
        fParsedBody : IReadOnlyList;
        fEnv : ICGIEnvironment;
        fUploadedFile: IUploadedFileCollection;
    public
        constructor create();
        destructor destroy(); override;

        (*!------------------------------------------------
         * test if current request is coming from AJAX request
         *-------------------------------------------------
         * @return true if ajax request false otherwise
         *------------------------------------------------*)
        function isXhr() : boolean;

        (*!------------------------------------
         * get http headers instance
         *-------------------------------------
         * @return header instance
         *-------------------------------------*)
        function headers() : IReadOnlyHeaders; virtual;

        (*!------------------------------------------------
         * get request URI
         *-------------------------------------------------
         * @return IUri of current request
         *------------------------------------------------*)
        function uri() : IUri; virtual;

        (*!------------------------------------------------
         * get request method GET, POST, HEAD, etc
         *-------------------------------------------------
         * @return string request method
         *------------------------------------------------*)
        function getMethod() : string; virtual;

        (*!------------------------------------------------
         * get single query param value by its name
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getQueryParam(
            const key: string;
            const defValue : string = ''
        ) : string; virtual;

        (*!------------------------------------------------
         * get all query params
         *-------------------------------------------------
         * @return list of query string params
         *------------------------------------------------*)
        function getQueryParams() : IReadOnlyList; virtual;

        (*!------------------------------------------------
         * get single cookie param value by its name
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getCookieParam(
            const key: string;
            const defValue : string = ''
        ) : string; virtual;

        (*!------------------------------------------------
         * get all cookies params
         *-------------------------------------------------
         * @return list of cookie params
         *------------------------------------------------*)
        function getCookieParams() : IReadOnlyList; virtual;

        (*!------------------------------------------------
         * get request body data
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getParsedBodyParam(
            const key: string;
            const defValue : string = ''
        ) : string; virtual;

        (*!------------------------------------------------
         * get all request body data
         *-------------------------------------------------
         * @return array of parsed body params
         *------------------------------------------------*)
        function getParsedBodyParams() : IReadOnlyList; virtual;

        (*!------------------------------------------------
         * get request uploaded file by name
         *-------------------------------------------------
         * @param string key name of key
         * @return instance of IUploadedFileArray or nil if is not
         *         exists
         *------------------------------------------------*)
        function getUploadedFile(const key: string) : IUploadedFileArray; virtual;

        (*!------------------------------------------------
         * get all uploaded files
         *-------------------------------------------------
         * @return IUploadedFileCollection or nil if no file
         *         upload
         *------------------------------------------------*)
        function getUploadedFiles() : IUploadedFileCollection; virtual;

        (*!------------------------------------------------
         * get CGI environment
         *-------------------------------------------------
         * @return ICGIEnvironment
         *------------------------------------------------*)
        function getEnvironment() : ICGIEnvironment; virtual;

        (*!------------------------------------------------
         * get request query string or body data
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getParam(
            const key: string;
            const defValue : string = ''
        ) : string; virtual;

        (*!------------------------------------------------
         * get all request query string body data
         *-------------------------------------------------
         * @return array of query string and parsed body params
         *------------------------------------------------*)
        function getParams() : IReadOnlyList; virtual;

    end;

implementation

uses

    RequestHeadersImpl,
    NullEnvironmentImpl,
    HashListImpl,
    UriImpl,
    NullUploadedFileCollectionImpl;

    constructor TNullRequest.create();
    begin
        fEnv := TNullCGIEnvironment.create();
        fRequestHeaders := TRequestHeaders.create(fEnv);
        fUri := TUri.create(fEnv);
        fQueryParam := THashList.create();
        fCookieParam := THashList.create();
        fUploadedFile := TNullUploadedFileCollection.create();
    end;

    destructor TNullRequest.destroy();
    begin
        fRequestHeaders := nil;
        fUri := nil;
        fEnv := nil;
        fQueryParam := nil;
        fCookieParam := nil;
        fUploadedFile := nil;
        inherited destroy();
    end;

    (*!------------------------------------
     * get http headers instance
     *-------------------------------------
     * @return header instance
     *-------------------------------------*)
    function TNullRequest.headers() : IReadOnlyHeaders;
    begin
        result := fRequestHeaders;
    end;

    (*!------------------------------------------------
     * get request URI
     *-------------------------------------------------
     * @return IUri of current request
     *------------------------------------------------*)
    function TNullRequest.uri() : IUri;
    begin
        result := fUri;
    end;

    (*!------------------------------------------------
     * get single query param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TNullRequest.getQueryParam(const key: string; const defValue : string = '') : string;
    begin
        result := '';
    end;

    (*!------------------------------------------------
     * get all request query strings data
     *-------------------------------------------------
     * @return list of request query string parameters
     *------------------------------------------------*)
    function TNullRequest.getQueryParams() : IReadOnlyList;
    begin
        result := fQueryParam;
    end;

    (*!------------------------------------------------
     * get single cookie param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TNullRequest.getCookieParam(const key: string; const defValue : string = '') : string;
    begin
        result := '';
    end;

    (*!------------------------------------------------
     * get all request cookie data
     *-------------------------------------------------
     * @return list of request cookies parameters
     *------------------------------------------------*)
    function TNullRequest.getCookieParams() : IReadOnlyList;
    begin
        result := fCookieParam;
    end;

    (*!------------------------------------------------
     * get request body data
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TNullRequest.getParsedBodyParam(const key: string; const defValue : string = '') : string;
    begin
        result := '';
    end;

    (*!------------------------------------------------
     * get all request body data
     *-------------------------------------------------
     * @return list of request body parameters
     *------------------------------------------------*)
    function TNullRequest.getParsedBodyParams() : IReadOnlyList;
    begin
        result := fParsedBody;
    end;

    (*!------------------------------------------------
     * get request uploaded file by name
     *-------------------------------------------------
     * @param string key name of key
     * @return instance of IUploadedFileArray or nil if is not
     *         exists
     *------------------------------------------------*)
    function TNullRequest.getUploadedFile(const key: string) : IUploadedFileArray;
    begin
        result := fUploadedFile.getUploadedFile(key);
    end;

    (*!------------------------------------------------
     * get all uploaded files
     *-------------------------------------------------
     * @return IUploadedFileCollection
     *------------------------------------------------*)
    function TNullRequest.getUploadedFiles() : IUploadedFileCollection;
    begin
        result := fUploadedFile;
    end;

    (*!------------------------------------------------
     * test if current request is coming from AJAX request
     *-------------------------------------------------
     * @return true if ajax request false otherwise
     *------------------------------------------------*)
    function TNullRequest.isXhr() : boolean;
    begin
        result := false;
    end;

    (*!------------------------------------------------
     * get request method GET, POST, HEAD, etc
     *-------------------------------------------------
     * @return string request method
     *------------------------------------------------*)
    function TNullRequest.getMethod() : string;
    begin
        result := 'GET';
    end;

    (*!------------------------------------------------
     * get CGI environment
     *-------------------------------------------------
     * @return ICGIEnvironment
     *------------------------------------------------*)
    function TNullRequest.getEnvironment() : ICGIEnvironment;
    begin
        result := fEnv;
    end;

    (*!------------------------------------------------
     * get single query param or body param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TNullRequest.getParam(const key: string; const defValue : string = '') : string;
    begin
        result := '';
    end;

    (*!------------------------------------------------
     * get all request query strings or body data
     *-------------------------------------------------
     * @return list of request query string parameters
     *------------------------------------------------*)
    function TNullRequest.getParams() : IReadOnlyList;
    begin
        result := fQueryParam;
    end;

end.
