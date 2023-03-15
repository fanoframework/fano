{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MultipartFormDataParserImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    ListIntf,
    DependencyContainerIntf,
    MultipartFormDataParserIntf,
    EnvironmentIntf,
    UploadedFileCollectionWriterIntf,
    UploadedFileCollectionWriterFactoryIntf;

type

    (*!----------------------------------------------
     * basic implementation having capability as
     * parse multipart/form-data request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMultipartFormDataParser = class(TInterfacedObject, IMultipartFormDataParser)
    private
        uploadedFilesFactory : IUploadedFileCollectionWriterFactory;

        (*!----------------------------------------------
         * extract boundary from multipart/form-data content type
         * header
         *-------- --------------------------------------
         * @param contentType content type header
         * @return boundary of multipart/form-data
         *------------------------------------------------
         * For example if we have header as follows:         *
         * Content-Type: multipart/form-data; boundary=xxx12345678
         *
         * contentType parameter will contain string
         * 'multipart/form-data; boundary=xxx12345678'
         *
         * this method will return string 'xxx12345678'
         *
         *-----------------------------------------------*)
        function getBoundary(const contentType : string) : string;

        (*!----------------------------------------
         * parse data in string store parsed data in body request parameter
         * and uploaded files (if any).
         *------------------------------------------
         * @param actualData actual data to parse
         * @param body instance of IList that will store
         *             parsed body parameter
         * @param uploadedFiles instance of uploaded file collection
         *-------------------------------------------
         * Example of actualData
         *
         * Content-Disposition: form-data; name="text"
         * \r\n
         * text default
         *------------------------------------------*)
        procedure parseData(
            const actualData : string;
            const body : IList;
            const uploadedFiles : IUploadedFileCollectionWriter
        );

        procedure splitDataByBoundaryAndParse(
            const multipartData : string;
            const boundary : string;
            const body : IList;
            const uploadedFiles : IUploadedFileCollectionWriter
        );

        (*!----------------------------------------
         * add data payload to file upload (if any)
         *------------------------------------------
         * @param headerPart header data of file upload
         * @param dataPart file upload data
         * @param varName name of file upload
         * @param originalFilename original filename as send by browser (may be empty)
         * @param uploadedFiles instance of uploaded file collection
         *------------------------------------------*)
        procedure addFileUpload(
            const headerPart : string;
            const dataPart : string;
            const varName : string;
            const originalFilename : string;
            const uploadedFiles : IUploadedFileCollectionWriter
        );

        (*!-------------------------------------------------------------
         * extract name from Content-Disposition
         *--------------------------------------------------------------
         * @param start starting index for extracting name
         * @param header header part
         * @return name
         *--------------------------------------------------------------
         * If we have header contains following line
         *
         * Content-Disposition: form-data; name="file2"; filename="a.html"
         * Content-Type: text/html
         *
         * start will contains value 32, start index of 'name="' substring
         * from pos() function
         * then this method will return string file2
         *--------------------------------------------------------------*)
        function extractName(const start: integer; const header : string) : string;

        (*!-------------------------------------------------------------
         * extract variable name from Content-Disposition
         *--------------------------------------------------------------
         * @param header header part
         * @return name
         * @throws EInvalidRequest if name is not found
         *--------------------------------------------------------------
         * If we have header contains following line
         *
         * Content-Disposition: form-data; name="file2"; filename="a.html"
         * Content-Type: text/html
         *
         * then this method will return string file2 or raise exception
         * if name is not found
         *--------------------------------------------------------------*)
        function extractVariableName(const headerPart : string) : string;
    public

        (*!----------------------------------------
         * constructor
         *------------------------------------------
         * @param factory factory instance to build uploaded file
         *        collection instance
         *------------------------------------------*)
        constructor create(
            const factory : IUploadedFileCollectionWriterFactory
        );

        (*!----------------------------------------
         * destructor
         *------------------------------------------*)
        destructor destroy(); override;

        (*!----------------------------------------
         * Read POST data and parse
         * it and store parsed data in body request parameter
         * and uploaded files (if any). If not file upload
         * then TNullUploadedFileCollection instance is return
         *------------------------------------------
         * @param contentType Content-Type request header
         * @param postData POST data from web server
         * @param body instance of IList that will store
         *             parsed body parameter
         * @param uploadedFiles instance of uploaded file collection
         * @return current instance
         *-------------------------------------------
         * Example of POST data with boundary of 'xxx12345678' s
         *
         * --xxx12345678
         * Content-Disposition: form-data; name="text"
         * \r\n
         * text default
         * --xxx12345678
         * Content-Disposition: form-data; name="file1"; filename="a.txt"
         * Content-Type: text/plain
         * \r\n
         * Content of a.txt.
         *
         * --xxx12345678
         * Content-Disposition: form-data; name="file2"; filename="a.html"
         * Content-Type: text/html
         * \r\n
         * <!DOCTYPE html><title>Content of a.html.</title>
         *
         * --xxx12345678--
         * @link : https://stackoverflow.com/questions/4238809/example-of-multipart-form-data
         *------------------------------------------*)
        function parse(
            const contentType : string;
            const postData : string;
            const body : IList;
            out uploadedFiles : IUploadedFileCollectionWriter
        ) : IMultipartFormDataParser;
    end;

implementation

uses

    sysutils,
    KeyValueTypes,
    EInvalidRequestImpl;

resourcestring

    sErrInvalidBoundary = 'Invalid multipart/form-data boundary';
    sErrInvalidMultipartFormDataName = 'Invalid multipart/form-data name';

    (*!----------------------------------------
     * constructor
     *------------------------------------------
     * @param factory factory instance to build uploaded file
     *        collection instance
     *------------------------------------------*)
    constructor TMultipartFormDataParser.create(
        const factory : IUploadedFileCollectionWriterFactory
    );
    begin
        uploadedFilesFactory := factory;
    end;

    (*!----------------------------------------
     * destructor
     *------------------------------------------*)
    destructor TMultipartFormDataParser.destroy();
    begin
        inherited destroy();
        uploadedFilesFactory := nil;
    end;

    (*!----------------------------------------------
     * extract boundary from multipart/form-data content type
     * header
     *-------- --------------------------------------
     * @param contentType content type header
     * @return boundary of multipart/form-data
     *------------------------------------------------
     * For example if we have contentType
     * 'multipart/form-data; boundary=xxx12345678'
     * it will return string 'xxx12345678'
     *-----------------------------------------------*)
    function TMultipartFormDataParser.getBoundary(const contentType : string) : string;
    const BOUNDARY = 'boundary=';
    const BOUNDARY_LEN = 9;
    var boundaryPos : integer;
    begin
        boundaryPos := pos(BOUNDARY, contentType);
        if (boundaryPos = 0) then
        begin
            //boundary string not present. Something is not right
            raise EInvalidRequest.create(sErrInvalidBoundary);
        end;

        //boundaryPos will point at beginning of 'boundary=..'
        //offset it to point to beginning of actual boundary
        boundaryPos := boundaryPos + BOUNDARY_LEN;
        //read boundary value
        result := copy(
            contentType,
            boundaryPos,
            length(contentType) - boundaryPos + 1
        );
    end;

    (*!-------------------------------------------------------------
     * extract name from Content-Disposition
     *--------------------------------------------------------------
     * @param start starting index for extracting name
     * @param header header part
     * @return name
     *--------------------------------------------------------------
     * If we have header contains following line
     *
     * Content-Disposition: form-data; name="file2"; filename="a.html"
     * Content-Type: text/html
     *
     * start will contains value 32, start index of 'name="' substring
     * from pos() function
     * then this method will return string file2
     *--------------------------------------------------------------*)
    function TMultipartFormDataParser.extractName(const start: integer; const header : string) : string;
    var i, len:integer;
    begin
        len := length(header);
        i := start;
        result := '';
        while (header[i] <> '"') and (i<len) do
        begin
            result:= result + header[i];
            inc(i);
        end;
    end;

    (*!-------------------------------------------------------------
     * extract variable name from Content-Disposition
     *--------------------------------------------------------------
     * @param header header part
     * @return name
     * @throws EInvalidRequest if name is not found
     *--------------------------------------------------------------
     * If we have header contains following line
     *
     * Content-Disposition: form-data; name="file2"; filename="a.html"
     * Content-Type: text/html
     *
     * then this method will return string file2 or raise exception
     * if name is not found
     *--------------------------------------------------------------*)
    function TMultipartFormDataParser.extractVariableName(const headerPart : string) : string;
    var posName : integer;
    begin
        posName := pos('name="', headerPart);
        if (posName = 0) then
        begin
            //name must be exists, if not, something is very wrong
            raise EInvalidRequest.create(sErrInvalidMultipartFormDataName);
        end;
        //6= length of 'name="'
        result := extractName(posName + 6, headerPart);
    end;

    (*!----------------------------------------
     * add data payload to file upload (if any)
     *------------------------------------------
     * @param headerPart header data of file upload
     * @param dataPart file upload data
     * @param varName name of file upload
     * @param originalFilename original filename as send by browser (may be empty)
     * @param uploadedFiles instance of uploaded file collection
     *------------------------------------------*)
    procedure TMultipartFormDataParser.addFileUpload(
        const headerPart : string;
        const dataPart : string;
        const varName : string;
        const originalFilename : string;
        const uploadedFiles : IUploadedFileCollectionWriter
    );
    var posContentType : int64;
        contentType : string;
    begin
        //extract contentType (if any)
        contentType := 'application/octet-stream';
        posContentType := pos('content-type:', lowerCase(headerPart));
        if (posContentType > 0) then
        begin
            //13=length of 'content-type:'
            contentType := copy(headerPart, posContentType + 13, length(headerPart));
            contentType := trim(contentType.split([';'])[0]);
        end;

        if dataPart <> '' then
        begin
            //if we get here then, form upload contain file input and
            //at least a file is uploaded
            uploadedFiles.add(
                varName,
                dataPart,
                contentType,
                originalFilename
            );
        end;
    end;

    (*!----------------------------------------
     * parse data in string store parsed data in body request parameter
     * and uploaded files (if any).
     *------------------------------------------
     * @param actualData actual data to parse
     * @param body instance of IList that will store
     *             parsed body parameter
     * @param uploadedFiles instance of uploaded file collection
     *-------------------------------------------
     * Example of actualData
     *
     * Content-Disposition: form-data; name="text"
     * \n\n
     * text default
     *
     * or
     * Content-Disposition: form-data; name="photo"; filename="shell300x300.jpg"
     * Content-Type: image/jpeg
     * \n\n
     * [binary data]
     *------------------------------------------*)
    procedure TMultipartFormDataParser.parseData(
        const actualData : string;
        const body : IList;
        const uploadedFiles : IUploadedFileCollectionWriter
    );
    var headerPart, dataPart, varName, originalFilename : string;
        crlfSeparatorPos, posFilename : integer;
        param : PKeyValue;
    begin
        //split header and data.
        //need to copy actualData because delete() replace string in place
        //which will trigger compiler error because we mark it as const
        dataPart := actualData;
        crlfSeparatorPos := pos(#13#10#13#10, dataPart);
        //copy header part and its crlf
        headerPart := copy(dataPart, 1, crlfSeparatorPos + 2);
        //remove header part including crlf that separate header and data
        //so dataPart now consist of solely data payload
        delete(dataPart, 1, crlfSeparatorPos + 2 + 1);

        //for multipart/form-data, 'Content-Disposition' always 'form-data'
        //so we can just simply read 'name'
        varName := extractVariableName(headerPart);
        posFilename := pos('filename="', headerPart);
        if (posFilename > 0) then
        begin
            //if we get here it means we handle a file upload
            //10= length of 'filename="'
            //ExtractFilename is required to strip any directory information
            //See Section 2.3 of RFC 2183
            originalFilename := extractFilename(extractName(posFilename + 10, headerPart));
            addFileUpload(headerPart, dataPart, varName, originalFilename, uploadedFiles);
        end else
        begin
            //if we get here it means we handle ordinary input
            new(param);
            param^.key := varName;
            param^.value := dataPart;
            body.add(varName, param);
        end;
    end;

    (*!----------------------------------------
     * split raw POST data by boundary and parse
     * them
     *------------------------------------------
     * @param multipartData raw POST data from client browser
     * @param boundary multipart/form-data boundary id string
     * @param body instance of IList that will store
     *             parsed body parameter
     * @param uploadedFiles instance of uploaded file collection
     *------------------------------------------*)
    procedure TMultipartFormDataParser.splitDataByBoundaryAndParse(
        const multipartData : string;
        const boundary : string;
        const body : IList;
        const uploadedFiles : IUploadedFileCollectionWriter
    );
    var payloads : TStringArray;
        indx, len : integer;
    begin
        payloads := multipartData.split(
            ['--' + boundary ],
            TStringSplitOptions.ExcludeEmpty
        );

        //RFC 7578 requires last boundary format --<boundary>-- so
        //last buffer will contain -- because we split with --<boundary>
        //as delimiter, we will ignore last array element
        len := length(payloads);
        for indx := 0 to len-2 do
        begin
            //delete first CRLF
            delete(payloads[indx], 1, 2);
            //delete Last CRLF
            delete(payloads[indx], length(payloads[indx])-1, 2);
            parseData(payloads[indx], body, uploadedFiles);
        end;
    end;

    (*!----------------------------------------
     * Read POST data in standard input and parse
     * it and store parsed data in body request parameter
     * and uploaded files (if any).
     *------------------------------------------
     * @param env CGI environment variable
     * @param body instance of IList that will store
     *             parsed body parameter
     * @param uploadedFiles instance of uploaded file collection
     * @return current instance
     *------------------------------------------
     * Example of POST data with boundary of 'xxx12345678' s
     *
     * --xxx12345678
     * Content-Disposition: form-data; name="text"
     * \r\n
     * text default
     * --xxx12345678
     * Content-Disposition: form-data; name="file1"; filename="a.txt"
     * Content-Type: text/plain
     * \r\n
     * Content of a.txt.
     *
     * --xxx12345678
     * Content-Disposition: form-data; name="file2"; filename="a.html"
     * Content-Type: text/html
     * \r\n
     * <!DOCTYPE html><title>Content of a.html.</title>
     *
     * --xxx12345678--
     * @link : https://stackoverflow.com/questions/4238809/example-of-multipart-form-data
     * @link : https://tools.ietf.org/html/rfc7578
     *------------------------------------------*)
    function TMultipartFormDataParser.parse(
        const contentType : string;
        const postData : string;
        const body : IList;
        out uploadedFiles : IUploadedFileCollectionWriter
    ) : IMultipartFormDataParser;
    begin
        uploadedFiles := uploadedFilesFactory.createCollectionWriter();
        splitDataByBoundaryAndParse(
            postData,
            getBoundary(contentType),
            body,
            uploadedFiles
        );
        result := self;
    end;
end.
