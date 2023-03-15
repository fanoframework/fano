{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpwebRequestImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    RequestIntf,
    ListIntf,
    ReadOnlyListIntf,
    UploadedFileIntf,
    UploadedFileCollectionIntf,
    ReadonlyHeadersIntf,
    EnvironmentIntf,
    UriIntf,
    httpdefs,
    fphttpserver;

type

    (*!------------------------------------------------
     * fcl-web TRequest adapter class implement IRequest
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFpwebRequest = class(TInterfacedObject, IRequest)
    private
        fEnv : ICGIEnvironment;
        fRequest : TFPHttpConnectionRequest;
        fHeaders : IReadOnlyHeaders;
        fQueryParams : IList;
        fCookieParams : IList;
        fBodyParams : IList;
        fQueryAndBodyParams : IList;
        fUploadedFiles : IUploadedFileCollection;
        fUri : IUri;

        function freeParams(const aParams : IList) : IList;

        function initParams(
            const aFields : TStrings;
            const aParams : IList
        ) : IList;

        function initHeaders(
            const request : TFPHttpConnectionRequest;
            const aheaders : IReadOnlyHeaders
        ) : IReadOnlyHeaders;

        function getSingleParam(
            const src : IReadOnlyList;
            const key: string;
            const defValue : string = ''
        ) : string;

    public
        constructor create(
            const request : TFPHttpConnectionRequest;
            const aEnv : ICGIEnvironment
        );
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

    HeadersImpl,
    HashListImpl,
    UriImpl,
    KeyValueTypes,
    CompositeListImpl,
    UploadedFileCollectionAdapterImpl;

    constructor TFpwebRequest.create(
        const request : TFPHttpConnectionRequest;
        const aEnv : ICGIEnvironment
    );
    begin
        fEnv := aEnv;
        fRequest := request;
        fHeaders := initHeaders(fRequest, THeaders.create(THashList.create()));
        fQueryParams := initParams(fRequest.QueryFields, THashList.create());
        fCookieParams := initParams(fRequest.CookieFields, THashList.create());
        fBodyParams := initParams(fRequest.ContentFields, THashList.create());

        //make parameters in body take more precedence over query string
        //to reduce risk of HTTP parameters pollution with cross-channel pollution
        //see http://www.madlab.it/slides/BHEU2011/whitepaper-bhEU2011.pdf
        fQueryAndBodyParams := TCompositeList.create(fBodyParams, fQueryParams);

        fUri := TUri.create(request.url);
        fUploadedFiles := TUploadedFileCollectionAdapter.create(request.files);
    end;

    destructor TFpwebRequest.destroy();
    begin
        freeParams(fQueryParams);
        freeParams(fCookieParams);
        freeParams(fBodyParams);
        fRequest := nil;
        fHeaders := nil;
        fQueryParams := nil;
        fCookieParams := nil;
        fBodyParams := nil;
        fUri := nil;
        inherited destroy();
    end;

    function TFpwebRequest.freeParams(const aParams : IList) : IList;
    var i : integer;
        keyval : PKeyValue;
    begin
        for i:= aParams.count() -1 downto 0 do
        begin
            keyval := aParams.get(i);
            dispose(keyval);
        end;
        result := aParams;
    end;

    function TFpwebRequest.initParams(
        const aFields : TStrings;
        const aParams : IList
    ) : IList;
    var i : integer;
        aname : string;
        avalue : string;
        keyval : PKeyValue;
    begin
        for i:= 0 to aFields.count -1 do
        begin
            aname := aFields.names[i];
            avalue := aFields.values[aname];
            new(keyval);
            keyval^.key := aname;
            keyval^.value := avalue;
            aParams.add(aname, keyval);
        end;
        result := aParams;
    end;

    function TFpwebRequest.initHeaders(
        const request : TFPHttpConnectionRequest;
        const aheaders : IReadOnlyHeaders
    ) : IReadOnlyHeaders;
    begin
        result := aheaders;
        //TODO: build header key/value pair
    end;

    (*!------------------------------------
     * get http headers instance
     *-------------------------------------
     * @return header instance
     *-------------------------------------*)
    function TFpwebRequest.headers() : IReadOnlyHeaders;
    begin
        result := fheaders;
    end;

    (*!------------------------------------------------
     * get request URI
     *-------------------------------------------------
     * @return IUri of current request
     *------------------------------------------------*)
    function TFpwebRequest.uri() : IUri;
    begin
        result := fUri;
    end;

    (*!------------------------------------------------
     * get single param value by its name
     *-------------------------------------------------
     * @param IList src hash list instance
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TFpwebRequest.getSingleParam(
        const src : IReadOnlyList;
        const key: string;
        const defValue : string = ''
    ) : string;
    var qry : PKeyValue;
    begin
        qry := src.find(key);
        if (qry = nil) then
        begin
            result := defValue;
        end else
        begin
            result := qry^.value;
        end;
    end;

    (*!------------------------------------------------
     * get single query param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TFpwebRequest.getQueryParam(const key: string; const defValue : string = '') : string;
    begin
        result := getSingleParam(fQueryParams, key, defValue);
    end;

    (*!------------------------------------------------
     * get all request query strings data
     *-------------------------------------------------
     * @return list of request query string parameters
     *------------------------------------------------*)
    function TFpwebRequest.getQueryParams() : IReadOnlyList;
    begin
        result := fQueryParams;
    end;

    (*!------------------------------------------------
     * get single cookie param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TFpwebRequest.getCookieParam(const key: string; const defValue : string = '') : string;
    begin
        result := getSingleParam(fCookieParams, key, defValue);
    end;

    (*!------------------------------------------------
     * get all request cookie data
     *-------------------------------------------------
     * @return list of request cookies parameters
     *------------------------------------------------*)
    function TFpwebRequest.getCookieParams() : IReadOnlyList;
    begin
        result := fCookieParams;
    end;

    (*!------------------------------------------------
     * get request body data
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TFpwebRequest.getParsedBodyParam(const key: string; const defValue : string = '') : string;
    begin
        result := getSingleParam(fBodyParams, key, defValue);
    end;

    (*!------------------------------------------------
     * get all request body data
     *-------------------------------------------------
     * @return list of request body parameters
     *------------------------------------------------*)
    function TFpwebRequest.getParsedBodyParams() : IReadOnlyList;
    begin
        result := fBodyParams;
    end;

    (*!------------------------------------------------
     * get request uploaded file by name
     *-------------------------------------------------
     * @param string key name of key
     * @return instance of IUploadedFileArray or nil if is not
     *         exists
     *------------------------------------------------*)
    function TFpwebRequest.getUploadedFile(const key: string) : IUploadedFileArray;
    begin
        result := fUploadedFiles.getUploadedFile(key);
    end;

    (*!------------------------------------------------
     * get all uploaded files
     *-------------------------------------------------
     * @return IUploadedFileCollection
     *------------------------------------------------*)
    function TFpwebRequest.getUploadedFiles() : IUploadedFileCollection;
    begin
        result := fUploadedFiles;
    end;

    (*!------------------------------------------------
     * test if current request is coming from AJAX request
     *-------------------------------------------------
     * @return true if ajax request false otherwise
     *------------------------------------------------*)
    function TFpwebRequest.isXhr() : boolean;
    begin
        result := (fRequest.HTTPXRequestedWith = 'XMLHttpRequest');
    end;

    (*!------------------------------------------------
     * get request method GET, POST, HEAD, etc
     *-------------------------------------------------
     * @return string request method
     *------------------------------------------------*)
    function TFpwebRequest.getMethod() : string;
    begin
        result := fRequest.method;
    end;

    (*!------------------------------------------------
     * get CGI environment
     *-------------------------------------------------
     * @return ICGIEnvironment
     *------------------------------------------------*)
    function TFpwebRequest.getEnvironment() : ICGIEnvironment;
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
    function TFpwebRequest.getParam(const key: string; const defValue : string = '') : string;
    begin
        result := getSingleParam(fQueryAndBodyParams, key, defValue);
    end;

    (*!------------------------------------------------
     * get all request query strings or body data
     *-------------------------------------------------
     * @return list of request query string parameters
     *------------------------------------------------*)
    function TFpwebRequest.getParams() : IReadOnlyList;
    begin
        result := fQueryAndBodyParams;
    end;

end.
