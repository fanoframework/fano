{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit FcgiRequestImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ReadOnlyListIntf,
    FcgiRequestIntf,
    EnvironmentIntf,
    UploadedFileIntf,
    UploadedFileCollectionIntf,
    UploadedFileCollectionWriterIntf,
    StdInIntf,
    ReadOnlyHeadersIntf,
    UriIntf;

type

    (*!-----------------------------------------------
     * FastCGI request that implements IRequest
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiRequest = class(TInterfacedObject, IFcgiRequest, IRequest)
    private
        fRequest : IRequest;
        fRequestId : word;
    public
        (*!-----------------------------------------------
         * constructor
         *------------------------------------------------
         * @param id, request id
         * @param request, IRequest implementation
         *-----------------------------------------------*)
        constructor create(const id : word; const request : IRequest);

        (*!-----------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
        * get current request id
        *-----------------------------------------------
        * @return id of current request
        *-----------------------------------------------*)
        function id() : word;

        (*!------------------------------------
         * get http headers instance
         *-------------------------------------
         * @return header instance
         *-------------------------------------*)
        function headers() : IReadOnlyHeaders;

        (*!------------------------------------------------
         * get request URI
         *-------------------------------------------------
         * @return IUri of current request
         *------------------------------------------------*)
        function uri() : IUri;

        (*!------------------------------------------------
         * get request method GET, POST, HEAD, etc
         *-------------------------------------------------
         * @return string request method
         *------------------------------------------------*)
        function getMethod() : string;

        (*!------------------------------------------------
         * get single query param value by its name
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getQueryParam(const key: string; const defValue : string = '') : string;

        (*!------------------------------------------------
         * get all query params
         *-------------------------------------------------
         * @return list of query string params
         *------------------------------------------------*)
        function getQueryParams() : IReadOnlyList;

        (*!------------------------------------------------
         * get single cookie param value by its name
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getCookieParam(const key: string; const defValue : string = '') : string;

        (*!------------------------------------------------
         * get all cookies params
         *-------------------------------------------------
         * @return list of cookie params
         *------------------------------------------------*)
        function getCookieParams() : IReadOnlyList;

        (*!------------------------------------------------
         * get request body data
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getParsedBodyParam(const key: string; const defValue : string = '') : string;

        (*!------------------------------------------------
         * get all request body data
         *-------------------------------------------------
         * @return array of parsed body params
         *------------------------------------------------*)
        function getParsedBodyParams() : IReadOnlyList;

        (*!------------------------------------------------
         * get request uploaded file by name
         *-------------------------------------------------
         * @param string key name of key
         * @return instance of IUploadedFileArray or nil if is not
         *         exists
         *------------------------------------------------*)
        function getUploadedFile(const key: string) : IUploadedFileArray;

        (*!------------------------------------------------
         * get all uploaded files
         *-------------------------------------------------
         * @return IUploadedFileCollection or nil if no file
         *         upload
         *------------------------------------------------*)
        function getUploadedFiles() : IUploadedFileCollection;

        (*!------------------------------------------------
         * get CGI environment
         *-------------------------------------------------
         * @return ICGIEnvironment
         *------------------------------------------------*)
        function getEnvironment() : ICGIEnvironment;

        (*!------------------------------------------------
         * get request query string or body data
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getParam(const key: string; const defValue : string = '') : string;

        (*!------------------------------------------------
         * get all request query string body data
         *-------------------------------------------------
         * @return array of query string and parsed body params
         *------------------------------------------------*)
        function getParams() : IReadOnlyList;

        (*!------------------------------------------------
         * test if current request is coming from AJAX request
         *-------------------------------------------------
         * @return true if ajax request
         *------------------------------------------------*)
        function isXhr() : boolean;
    end;

implementation

    (*!-----------------------------------------------
     * constructor
     *------------------------------------------------
     * @param parser FastCGI frame parser
     *-----------------------------------------------*)
    constructor TFcgiRequest.create(const id : word; const request : IRequest);
    begin
        inherited create();
        fRequestId := id;
        fRequest := request;
    end;

    destructor TFcgiRequest.destroy();
    begin
        fRequest := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
    * get current request id
    *-----------------------------------------------
    * @return id of current request
    *-----------------------------------------------*)
    function TFcgiRequest.id() : word;
    begin
        result := fRequestId;
    end;

    (*!------------------------------------
     * get http headers instance
     *-------------------------------------
     * @return header instance
     *-------------------------------------*)
    function TFcgiRequest.headers() : IReadOnlyHeaders;
    begin
        result := fRequest.headers();
    end;

    (*!------------------------------------------------
     * get request URI
     *-------------------------------------------------
     * @return IUri of current request
     *------------------------------------------------*)
    function TFcgiRequest.uri() : IUri;
    begin
        result := fRequest.uri();
    end;

    (*!------------------------------------------------
     * get request method GET, POST, HEAD, etc
     *-------------------------------------------------
     * @return string request method
     *------------------------------------------------*)
    function TFcgiRequest.getMethod() : string;
    begin
        result := fRequest.getMethod();
    end;

    (*!------------------------------------------------
     * get single query param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TFcgiRequest.getQueryParam(const key: string; const defValue : string = '') : string;
    begin
        result := fRequest.getQueryParam(key, defValue);
    end;

    (*!------------------------------------------------
     * get all query params
     *-------------------------------------------------
     * @return list of query string params
     *------------------------------------------------*)
    function TFcgiRequest.getQueryParams() : IReadOnlyList;
    begin
        result := fRequest.getQueryParams();
    end;

    (*!------------------------------------------------
     * get single cookie param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TFcgiRequest.getCookieParam(const key: string; const defValue : string = '') : string;
    begin
        result := fRequest.getCookieParam(key, defValue);
    end;

    (*!------------------------------------------------
     * get all cookies params
     *-------------------------------------------------
     * @return list of cookie params
     *------------------------------------------------*)
    function TFcgiRequest.getCookieParams() : IReadOnlyList;
    begin
        result := fRequest.getCookieParams();
    end;

    (*!------------------------------------------------
     * get request body data
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TFcgiRequest.getParsedBodyParam(const key: string; const defValue : string = '') : string;
    begin
        result := fRequest.getParsedBodyParam(key, defValue);
    end;

    (*!------------------------------------------------
     * get all request body data
     *-------------------------------------------------
     * @return array of parsed body params
     *------------------------------------------------*)
    function TFcgiRequest.getParsedBodyParams() : IReadOnlyList;
    begin
        result := fRequest.getParsedBodyParams();
    end;

    (*!------------------------------------------------
     * get request uploaded file by name
     *-------------------------------------------------
     * @param string key name of key
     * @return instance of IUploadedFileArray or nil if is not
     *         exists
     *------------------------------------------------*)
    function TFcgiRequest.getUploadedFile(const key: string) : IUploadedFileArray;
    begin
        result := fRequest.getUploadedFile(key);
    end;

    (*!------------------------------------------------
     * get all uploaded files
     *-------------------------------------------------
     * @return IUploadedFileCollection or nil if no file
     *         upload
     *------------------------------------------------*)
    function TFcgiRequest.getUploadedFiles() : IUploadedFileCollection;
    begin
        result := fRequest.getUploadedFiles();
    end;

    (*!------------------------------------------------
     * get CGI environment
     *-------------------------------------------------
     * @return ICGIEnvironment
     *------------------------------------------------*)
    function TFcgiRequest.getEnvironment() : ICGIEnvironment;
    begin
        result := fRequest.getEnvironment();
    end;

    (*!------------------------------------------------
     * get single query param or body param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TFcgiRequest.getParam(const key: string; const defValue : string = '') : string;
    begin
        result := fRequest.getParam(key, defValue);
    end;

    (*!------------------------------------------------
     * get all request query strings or body data
     *-------------------------------------------------
     * @return list of request query string parameters
     *------------------------------------------------*)
    function TFcgiRequest.getParams() : IReadOnlyList;
    begin
        result := fRequest.getParams();
    end;

    (*!------------------------------------------------
     * test if current request is coming from AJAX request
     *-------------------------------------------------
     * @return true if ajax request false otherwise
     *------------------------------------------------*)
    function TFcgiRequest.isXhr() : boolean;
    begin
        result := fRequest.isXhr();
    end;

end.
