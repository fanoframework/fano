{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RequestImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EnvironmentIntf,
    RequestIntf,
    ReadOnlyListIntf,
    ListIntf,
    MultipartFormDataParserIntf,
    KeyValueTypes,
    UploadedFileIntf,
    UploadedFileCollectionIntf,
    UploadedFileCollectionWriterIntf,
    StdInIntf,
    ReadOnlyHeadersIntf,
    UriIntf;

const

    DEFAULT_MAX_POST_SIZE = 8 * 1024 * 1024;
    DEFAULT_MAX_UPLOAD_SIZE = 2 * 1024 * 1024;

type

    (*!------------------------------------------------
     * basic class having capability as
     * HTTP request
     *-------------------------------------------------
     * TODO: refactor
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TRequest = class(TInterfacedObject, IRequest)
    private
        fUri : IUri;
        fHeaders : IReadOnlyHeaders;
        webEnvironment : ICGIEnvironment;
        queryParams : IList;
        cookieParams : IList;
        bodyParams : IList;
        queryAndBodyParams : IList;
        uploadedFiles: IUploadedFileCollection;
        uploadedFilesWriter: IUploadedFileCollectionWriter;
        multipartFormDataParser : IMultipartFormDataParser;
        stdInReader : IStdIn;

        (*!------------------------------------------------
         * maximum POST data size in bytes
         *-------------------------------------------------*)
        maximumPostSize : int64;

        (*!------------------------------------------------
         * maximum single uploaded file size in bytes
         *-------------------------------------------------*)
        maximumUploadedFileSize : int64;

        procedure raiseExceptionIfPostDataTooBig(const contentLength : int64);

        procedure clearParams(const aparams : IList);

        procedure initParamsFromString(
            const data : string;
            const body : IList;
            const separatorChar : char = '&'
        );

        procedure initPostBodyParamsFromStdInput(
            const env : ICGIEnvironment;
            const body : IList
        );

        procedure initBodyParamsFromStdInput(
            const env : ICGIEnvironment;
            const body : IList
        );

        procedure initQueryParamsFromEnvironment(
            const env : ICGIEnvironment;
            const query : IList
        );

        procedure initCookieParamsFromEnvironment(
            const env : ICGIEnvironment;
            const cookies : IList
        );

        procedure initParamsFromEnvironment(
            const env : ICGIEnvironment;
            const query : IList;
            const cookies : IList;
            const body : IList
        );

        (*!------------------------------------------------
         * get single query param value by its name
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getSingleParam(
            const src :IReadOnlyList;
            const key: string;
            const defValue : string = ''
        ) : string;

    public
        constructor create(
            const anUri : IUri;
            const aheaders : IReadOnlyHeaders;
            const env : ICGIEnvironment;
            const query : IList;
            const cookies : IList;
            const body : IList;
            const multipartFormDataParserInst : IMultipartFormDataParser;
            const stdInputReader : IStdIn;
            const maxPostSize : int64 = DEFAULT_MAX_POST_SIZE;
            const maxUploadSize : int64 = DEFAULT_MAX_UPLOAD_SIZE
        );
        destructor destroy(); override;

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
         * @return array of TKeyValue
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
         * get all query params
         *-------------------------------------------------
         * @return array of TKeyValue
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
         * @return array of TKeyValue
         *------------------------------------------------*)
        function getParsedBodyParams() : IReadOnlyList;

        (*!------------------------------------------------
         * get request uploaded file by name
         *-------------------------------------------------
         * @param string key name of key
         * @return instance of IUploadedFile or nil if is not
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

uses

    sysutils,
    UrlHelpersImpl,
    EInvalidRequestImpl,
    CompositeListImpl;

resourcestring

    sErrExceedMaxPostSize = 'POST size (%d) exceeds maximum allowable POST size (%d)';

    constructor TRequest.create(
        const anUri : IUri;
        const aheaders : IReadOnlyHeaders;
        const env : ICGIEnvironment;
        const query : IList;
        const cookies : IList;
        const body : IList;
        const multipartFormDataParserInst : IMultipartFormDataParser;
        const stdInputReader : IStdIn;
        const maxPostSize : int64 = DEFAULT_MAX_POST_SIZE;
        const maxUploadSize : int64 = DEFAULT_MAX_UPLOAD_SIZE
    );
    begin
        inherited create();
        fUri := anUri;
        fHeaders := aheaders;
        webEnvironment := env;
        queryParams := query;
        cookieParams := cookies;
        bodyParams := body;
        multipartFormDataParser := multipartFormDataParserInst;
        stdInReader := stdInputReader;
        uploadedFiles := nil;
        uploadedFilesWriter := nil;

        maximumPostSize := maxPostSize;
        maximumUploadedFileSize := maxUploadSize;

        initParamsFromEnvironment(
            webEnvironment,
            queryParams,
            cookieParams,
            bodyParams
        );
        queryAndBodyParams := TCompositeList.create(queryParams, bodyParams);
    end;

    destructor TRequest.destroy();
    begin
        clearParams(queryParams);
        clearParams(cookieParams);
        clearParams(bodyParams);
        webEnvironment := nil;
        queryParams := nil;
        cookieParams := nil;
        bodyParams := nil;
        queryAndBodyParams := nil;
        uploadedFiles := nil;
        uploadedFilesWriter := nil;
        multipartFormDataParser := nil;
        stdInReader := nil;
        fHeaders := nil;
        fUri := nil;
        inherited destroy();
    end;

    (*!------------------------------------
     * get http headers instance
     *-------------------------------------
     * @return header instance
     *-------------------------------------*)
    function TRequest.headers() : IReadOnlyHeaders;
    begin
        result := fHeaders;
    end;

    (*!------------------------------------------------
     * get request URI
     *-------------------------------------------------
     * @return IUri of current request
     *------------------------------------------------*)
    function TRequest.uri() : IUri;
    begin
        result := fUri;
    end;

    procedure TRequest.clearParams(const aparams : IList);
    var i, len : integer;
        param : PKeyValue;
    begin
        len := aparams.count();
        for i:= len-1 downto 0 do
        begin
            param := aparams.get(i);
            dispose(param);
            aparams.delete(i);
        end;
    end;

    procedure TRequest.initParamsFromString(
        const data : string;
        const body : IList;
        const separatorChar : char = '&'
    );
    var arrOfQryStr, keyvalue : TStringArray;
        i, len, lenKeyValue : integer;
        param : PKeyValue;
    begin
        arrOfQryStr := data.split([separatorChar]);
        len := length(arrOfQryStr);
        for i:= 0 to len-1 do
        begin
            keyvalue := arrOfQryStr[i].split('=');
            lenKeyValue := length(keyvalue);
            if (lenKeyValue > 0) then
            begin
                new(param);
                param^.key := trim(keyvalue[0]);
                if (lenKeyValue = 2) then
                begin
                    param^.value := (keyvalue[1]).urlDecode();
                end else
                begin
                    //if we get here then we have query parameter with empty data
                    //such as 'id='
                    param^.value := '';
                end;
                body.add(param^.key, param);
            end;
        end;
    end;

    procedure TRequest.initQueryParamsFromEnvironment(
        const env : ICGIEnvironment;
        const query : IList
    );
    begin
        initParamsFromString(env.queryString(), query);
    end;

    procedure TRequest.initCookieParamsFromEnvironment(
        const env : ICGIEnvironment;
        const cookies : IList
    );
    begin
        initParamsFromString(env.httpCookie(), cookies, ';');
    end;

    procedure TRequest.raiseExceptionIfPostDataTooBig(const contentLength : int64);
    begin
        if (contentLength > maximumPostSize) then
        begin
            raise EInvalidRequest.createFmt(
                sErrExceedMaxPostSize,
                [ contentLength, maximumPostSize ]
            );
        end;
    end;

    procedure TRequest.initPostBodyParamsFromStdInput(
        const env : ICGIEnvironment;
        const body : IList
    );
    var contentLength : int64;
        contentType, bodyStr : string;
        param : PKeyValue;
    begin
        contentLength := env.intContentLength();
        //read STDIN
        bodyStr := stdInReader.readStdIn(contentLength);
        {---------------------------------------------------
        exception can be be thrown AFTER we read all STDIN.
        Apache requires app to read ALL POST data or close STDIN file
        handle eventhough not using it. Otherwise in Apache
        we will get AH00574 error. Here we read and discard
        -----------------------------------------------------}
        raiseExceptionIfPostDataTooBig(contentLength);

        contentType := lowerCase(env.contentType());
        if (contentType = 'application/x-www-form-urlencoded') then
        begin
            initParamsFromString(bodyStr, body);
        end
        else if (pos('multipart/form-data', contentType) > 0) then
        begin
            multipartFormDataParser.parse(contentType, bodyStr, body, uploadedFilesWriter);
            uploadedFiles := uploadedFilesWriter as IUploadedFileCollection;
        end else
        begin
            //if POST/PUT/PATCH but different contentType such as 'application/json'
            //save it as it is with its contentType as key and let developer deals with it
            new(param);
            param^.key := contentType;
            param^.value := bodyStr;
            body.add(param^.key, param);
        end;
    end;

    procedure TRequest.initBodyParamsFromStdInput(
        const env : ICGIEnvironment;
        const body : IList
    );
    var amethod : string;
    begin
        amethod := env.requestMethod();
        if (amethod = 'POST') or (amethod = 'PUT') or (amethod = 'PATCH') then
        begin
            initPostBodyParamsFromStdInput(env, body);
        end;
    end;

    procedure TRequest.initParamsFromEnvironment(
        const env : ICGIEnvironment;
        const query : IList;
        const cookies : IList;
        const body : IList
    );
    begin
        initQueryParamsFromEnvironment(env, query);
        initCookieParamsFromEnvironment(env, cookies);
        initBodyParamsFromStdInput(env, body);
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
    function TRequest.getSingleParam(
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
    function TRequest.getQueryParam(const key: string; const defValue : string = '') : string;
    begin
        result := getSingleParam(queryParams, key, defValue);
    end;

    (*!------------------------------------------------
     * get all request query strings data
     *-------------------------------------------------
     * @return list of request query string parameters
     *------------------------------------------------*)
    function TRequest.getQueryParams() : IReadOnlyList;
    begin
        result := queryParams;
    end;

    (*!------------------------------------------------
     * get single cookie param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TRequest.getCookieParam(const key: string; const defValue : string = '') : string;
    begin
        result := getSingleParam(cookieParams, key, defValue);
    end;

    (*!------------------------------------------------
     * get all request cookie data
     *-------------------------------------------------
     * @return list of request cookies parameters
     *------------------------------------------------*)
    function TRequest.getCookieParams() : IReadOnlyList;
    begin
        result := cookieParams;
    end;

    (*!------------------------------------------------
     * get request body data
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TRequest.getParsedBodyParam(const key: string; const defValue : string = '') : string;
    begin
        result := getSingleParam(bodyParams, key, defValue);
    end;

    (*!------------------------------------------------
     * get all request body data
     *-------------------------------------------------
     * @return list of request body parameters
     *------------------------------------------------*)
    function TRequest.getParsedBodyParams() : IReadOnlyList;
    begin
        result := bodyParams;
    end;

    (*!------------------------------------------------
     * get request uploaded file by name
     *-------------------------------------------------
     * @param string key name of key
     * @return instance of IUploadedFileArray or nil if is not
     *         exists
     *------------------------------------------------*)
    function TRequest.getUploadedFile(const key: string) : IUploadedFileArray;
    begin
        result := uploadedFiles.getUploadedFile(key);
    end;

    (*!------------------------------------------------
     * get all uploaded files
     *-------------------------------------------------
     * @return IUploadedFileCollection
     *------------------------------------------------*)
    function TRequest.getUploadedFiles() : IUploadedFileCollection;
    begin
        result := uploadedFiles;
    end;

    (*!------------------------------------------------
     * test if current request is coming from AJAX request
     *-------------------------------------------------
     * @return true if ajax request false otherwise
     *------------------------------------------------*)
    function TRequest.isXhr() : boolean;
    begin
        result := (webEnvironment.env('HTTP_X_REQUESTED_WITH') = 'XMLHttpRequest');
    end;

    (*!------------------------------------------------
     * get request method GET, POST, HEAD, etc
     *-------------------------------------------------
     * @return string request method
     *------------------------------------------------*)
    function TRequest.getMethod() : string;
    begin
        result := webEnvironment.requestMethod();
    end;

    (*!------------------------------------------------
     * get CGI environment
     *-------------------------------------------------
     * @return ICGIEnvironment
     *------------------------------------------------*)
    function TRequest.getEnvironment() : ICGIEnvironment;
    begin
        result := webEnvironment;
    end;

    (*!------------------------------------------------
     * get single query param or body param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TRequest.getParam(const key: string; const defValue : string = '') : string;
    begin
        result := getSingleParam(queryAndBodyParams, key, defValue);
    end;

    (*!------------------------------------------------
     * get all request query strings or body data
     *-------------------------------------------------
     * @return list of request query string parameters
     *------------------------------------------------*)
    function TRequest.getParams() : IReadOnlyList;
    begin
        result := queryAndBodyParams;
    end;
end.
