{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HeadersImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    CloneableIntf,
    ListIntf,
    HeadersIntf;

type

    (*!------------------------------------------------
     * basic class having capability to
     * set and write HTTP headers
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THeaders = class(TInterfacedObject, IHeaders, IDependency, ICloneable)
    private
        headerList : IList;
        procedure clearHeaders(const hdrList : IList);
    public
        constructor create(const hdrList : IList);
        destructor destroy(); override;

        (*!------------------------------------
         * set http header
         *-------------------------------------
         * @param headerline key:value of header
         * @return header instance
         *-------------------------------------*)
        function setHeaderLine(const headerline : string) : IHeaders;

        (*!------------------------------------
         * set http header
         *-------------------------------------
         * @param key name  of http header to set
         * @param value value of header
         * @return header instance
         *-------------------------------------*)
        function setHeader(const key : shortstring; const value : string) : IHeaders;

        (*!------------------------------------
         * add http header
         *-------------------------------------
         * @param key name  of http header to set
         * @param value value of header
         * @return header instance
         *-------------------------------------*)
        function addHeader(const key : shortstring; const value : string) : IHeaders;

        (*!------------------------------------
         * set http header
         *-------------------------------------
         * @param headerline key:value of header
         * @return header instance
         *-------------------------------------*)
        function addHeaderLine(const headerline : string) : IHeaders;

        (*!------------------------------------
         * remove http header
         *-------------------------------------
         * @param key name  of http header to set
         * @return header instance
         *-------------------------------------*)
        function removeHeader(const key : shortstring) : IHeaders;

        (*!------------------------------------
         * remove multiple http headers
         *-------------------------------------
         * @param keys name of http headers to remove
         * @return header instance
         *-------------------------------------*)
        function removeHeaders(const keys : array of shortstring) : IHeaders;

        (*!------------------------------------
         * get http header
         *-------------------------------------
         * @param key name  of http header to get
         * @return header value
         * @throws EHeaderNotSet
         *-------------------------------------*)
        function getHeader(const key : shortstring) : string;

        (*!------------------------------------
         * test if http header already been set
         *-------------------------------------
         * @param key name  of http header to test
         * @return boolean true if header is set
         *-------------------------------------*)
        function has(const key : shortstring) : boolean;

        (*!------------------------------------
         * output http headers to STDIN
         *-------------------------------------
         * @return header instance
         *-------------------------------------*)
        function writeHeaders() : IHeaders;

        function clone() : ICloneable;
    end;

implementation

uses

    sysutils,
    HashListImpl,
    HeaderConsts,
    EHeaderNotSetImpl,
    EInvalidHeaderImpl;

type

    THeaderRec = record
        key : string;
        value : string;
    end;
    PHeaderRec = ^THeaderRec;

    constructor THeaders.create(const hdrList : IList);
    begin
        headerList := hdrList;
    end;

    destructor THeaders.destroy();
    begin
        inherited destroy();
        clearHeaders(headerList);
        headerList := nil;
    end;

    procedure THeaders.clearHeaders(const hdrList : IList);
    var i, len : integer;
        hdr : PHeaderRec;
    begin
        len := hdrList.count();
        for i := len-1 downto 0 do
        begin
            hdr := hdrList.get(i);
            setLength(hdr^.key, 0);
            setLength(hdr^.value, 0);
            dispose(hdr);
            hdrList.delete(i);
        end;
    end;

    (*!------------------------------------
     * set http header
     *-------------------------------------
     * @param key name  of http header to set
     * @param value value of header
     * @return header instance
     *-------------------------------------*)
    function THeaders.setHeader(const key : shortstring; const value : string) : IHeaders;
    var hdr : PHeaderRec;
    begin
        hdr := headerList.find(key);
        if (hdr = nil) then
        begin
            new(hdr);
            headerList.add(key, hdr);
        end;
        hdr^.key := key;
        hdr^.value := value;
        result := self;
    end;

    function parseHeaderLine(
        const headerline : string;
        out key : shortstring;
        out value : string
    ) : boolean;
    var colonPos: integer;
    begin
        colonPos := pos(':', headerline);
        if (colonPos > 0) then
        begin
            key := copy(headerline, 1, colonPos - 1);
            value := trim(copy(headerline, colonPos + 1, length(headerline) - colonpos));
            result := true;
        end else
        begin
            result := false;
        end;
    end;

    (*!------------------------------------
     * set http header
     *-------------------------------------
     * @param headerline key:value of header
     * @return header instance
     *-------------------------------------*)
    function THeaders.setHeaderLine(const headerline : string) : IHeaders;
    var key : shortstring;
        value : string;
    begin
        if (parseHeaderLine(headerline, key, value)) then
        begin
            result := setHeader(key, value);
        end else
        begin
            raise EInvalidHeader.createFmt(sErrInvalidHeader, [headerline]);
        end;
    end;

    (*!------------------------------------
     * add http header
     *-------------------------------------
     * @param key name  of http header to set
     * @param value value of header
     * @return header instance
     *-------------------------------------*)
    function THeaders.addHeader(const key : shortstring; const value : string) : IHeaders;
    var hdr : PHeaderRec;
    begin
        new(hdr);
        hdr^.key := key;
        hdr^.value := value;
        headerList.add(key, hdr);
        result := self;
    end;

    (*!------------------------------------
     * add http header
     *-------------------------------------
     * @param headerline key:value of header
     * @return header instance
     *-------------------------------------*)
    function THeaders.addHeaderLine(const headerline : string) : IHeaders;
    var key : shortstring;
        value : string;
    begin
        if (parseHeaderLine(headerline, key, value)) then
        begin
            result := addHeader(key, value);
        end else
        begin
            raise EInvalidHeader.createFmt(sErrInvalidHeader, [headerline]);
        end;
    end;

    (*!------------------------------------
     * remove http header
     *-------------------------------------
     * @param key name of http header to remove
     * @return header instance
     *-------------------------------------*)
    function THeaders.removeHeader(const key : shortstring) : IHeaders;
    var hdr : PHeaderRec;
    begin
        hdr := headerList.remove(key);
        if assigned(hdr) then
        begin
            dispose(hdr);
        end;
        result := self;
    end;

    (*!------------------------------------
     * remove multiple http headers
     *-------------------------------------
     * @param keys name of http headers to remove
     * @return header instance
     *-------------------------------------*)
    function THeaders.removeHeaders(const keys : array of shortstring) : IHeaders;
    var i:integer;
    begin
        for i := low(keys) to high(keys) do
        begin
            removeHeader(keys[i]);
        end;
        result := self;
    end;

    (*!------------------------------------
     * get http header
     *-------------------------------------
     * @param key name  of http header to get
     * @return header value
     * @throws EHeaderNotSet
     *-------------------------------------*)
    function THeaders.getHeader(const key : shortstring) : string;
    var hdr : PHeaderRec;
    begin
        hdr := headerList.find(key);
        if (hdr = nil) then
        begin
            raise EHeaderNotSet.createFmt(sErrHeaderNotSet, [key]);
        end;
        result := hdr^.value;
    end;

    (*!------------------------------------
     * test if http header already been set
     *-------------------------------------
     * @param key name  of http header to test
     * @return boolean true if header is set
     *-------------------------------------*)
    function THeaders.has(const key : shortstring) : boolean;
    begin
        result := (headerList.find(key) <> nil);
    end;

    (*!------------------------------------
     * output http headers to STDOUT
     *-------------------------------------
     * @return header instance
     *-------------------------------------*)
    function THeaders.writeHeaders() : IHeaders;
    var i, len : integer;
        hdr : PHeaderRec;
    begin
        len := headerList.count();
        for i :=0 to len-1 do
        begin
            hdr := headerList.get(i);
            writeln(hdr^.key, ': ', hdr^.value);
        end;

        //CGI protocol requires that header and body are separated by blank line
        writeln();
        result := self;
    end;

    function THeaders.clone() : ICloneable;
    var i, len : integer;
        srcHdr, dstHdr : PHeaderRec;
        newHashList : IList;
    begin
        newHashList := THashList.create();
        len := headerList.count();
        for i :=0 to len-1 do
        begin
            srcHdr := headerList.get(i);
            new(dstHdr);
            dstHdr^.key := srcHdr^.key;
            dstHdr^.value := srcHdr^.value;
            newHashList.add(dstHdr^.key, dstHdr);
        end;
        result := THeaders.create(newHashList);
    end;

end.
