{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiRequestManagerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EnvironmentIntf,
    FcgiRecordIntf,
    StreamAdapterIntf,
    StreamAdapterCollectionFactoryIntf,
    FcgiRequestManagerIntf,
    fgl;

type

    TFcgiRecordList = specialize TFPGInterfacedObjectList<IFcgiRecord>;
    TRequestRecord = record
        used : boolean;
        keepConnection : boolean;
        //store FCGI_STDIN stream completeness
        fcgiStdInComplete : boolean;
        //store FCGI_PARAMS stream completeness
        fcgiParamsComplete : boolean;
        fcgiRecords : TFcgiRecordList;

        stdInStream : IStreamAdapter;
        env : ICGIEnvironment;
    end;

    TRequestRecordArr = array of TRequestRecord;

    (*!-----------------------------------------------
     * Basic class having capability to manage
     * FastCGI requests multiplexing
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiRequestManager = class(TInterfacedObject, IFcgiRequestManager)
    private
        fRecords : TRequestRecordArr;
        fStreamCollectionFactory : IStreamAdapterCollectionFactory;

        procedure initRecords();
        procedure initSingleRecord(const requestId : word);
        procedure clearFastCgiRecords(const indx : integer);
        procedure clearRecords();

        (*!------------------------------------------------
         * get data from all records identified by request id and type
         *-----------------------------------------------
         * @param requestId, request id
         * @param atype, record type
         * @return stream instance of all records identified by type
         *-----------------------------------------------*)
        function getStreamByType(const requestId : word; const atype: byte) : IStreamAdapter;

        (*!------------------------------------------------
         * mark request completeness
         *-----------------------------------------------
         * @param rec, record to check
         * @return true if request identified by id is complete
         *-----------------------------------------------*)
        procedure markCompleteness(const rec : IFcgiRecord);

        (*!------------------------------------------------
         * initialize get CGI Environment for request identified by request id
         *-----------------------------------------------
         * @param requestId, request id
         * @return CGI environment
         *-----------------------------------------------*)
        function initEnvironment(const requestId : word) : ICGIEnvironment;

    public

        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param initialCapacity, initial pre allocated array
         *-----------------------------------------------*)
        constructor create(
            const streamCollectionFactory : IStreamAdapterCollectionFactory;
            const initialCapacity : integer = 32
        );

        (*!------------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * test if request identified by id exist
         *-----------------------------------------------
         * @param requestId, request id to check
         * @return true if request identified by id exist
         *-----------------------------------------------*)
        function has(const requestId : word) : boolean;

        (*!------------------------------------------------
         * test if web server is done sending request
         * to us identified by id
         *-----------------------------------------------
         * @param requestId, request id to check
         * @return true if request identified by id is complete
         *-----------------------------------------------*)
        function complete(const requestId : word) : boolean;

        (*!------------------------------------------------
         * test if web server ask to keep connection open
         *-----------------------------------------------
         * @param requestId, request id to check
         * @return true if request identified by id need to be keep open
         *-----------------------------------------------*)
        function keepConnection(const requestId : word) : boolean;

        (*!------------------------------------------------
         * get data from all FCGI_STDIN identified by request id
         *-----------------------------------------------
         * @param requestId, request id
         * @return stream instance of all FCGI_STDIN records
         *-----------------------------------------------*)
        function getStdInStream(const requestId : word) : IStreamAdapter;

        (*!------------------------------------------------
         * get CGI Environment for request identified by request id
         *-----------------------------------------------
         * @param requestId, request id
         * @return CGI environment or nil if environment not ready
         *-----------------------------------------------*)
        function getEnvironment(const requestId : word) : ICGIEnvironment;

        (*!------------------------------------------------
         * add FastCGI record to manager
         *-----------------------------------------------
         * @param rec, FastCGI record to add
         * @return id of current request
         *-----------------------------------------------*)
        function add(const rec : IFcgiRecord) : IFcgiRequestManager;

        (*!------------------------------------------------
         * remove request
         *-----------------------------------------------
         * @param requestId, request id to be removed
         * @return true of request is removed
         *-----------------------------------------------*)
        function remove(const requestId : word) : boolean;
    end;

implementation

uses

    fastcgi,
    StreamAdapterAwareIntf,
    StreamAdapterCollectionIntf,
    EnvironmentFactoryIntf,
    FcgiBeginRequestIntf,
    FcgiEnvironmentFactoryImpl,
    EInvalidFcgiRequestIdImpl;

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------
     * @param initialCapacity, initial pre allocated array
     *-----------------------------------------------*)
    constructor TFcgiRequestManager.create(
        const streamCollectionFactory : IStreamAdapterCollectionFactory;
        const initialCapacity : integer = 32
    );
    begin
        fStreamCollectionFactory := streamCollectionFactory;
        setLength(fRecords, initialCapacity);
        initRecords();
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TFcgiRequestManager.destroy();
    begin
        inherited destroy();
        clearRecords();
        setLength(fRecords, 0);
        fStreamCollectionFactory := nil;
    end;

    procedure TFcgiRequestManager.initRecords();
    var i : integer;
    begin
        for i := length(fRecords) - 1 downto 0 do
        begin
            initSingleRecord(i);
        end;
    end;

    procedure TFcgiRequestManager.initSingleRecord(const requestId : word);
    begin
        fRecords[requestId].used := false;
        fRecords[requestId].keepConnection := false;
        fRecords[requestId].fcgiStdInComplete := false;
        fRecords[requestId].fcgiParamsComplete := false;
        if (assigned(fRecords[requestId].fcgiRecords)) then
        begin
            clearFastCgiRecords(requestId);
        end;
        fRecords[requestId].fcgiRecords := TFcgiRecordList.create();
    end;

    procedure TFcgiRequestManager.clearFastCgiRecords(const indx : integer);
    var j: integer;
    begin
        fRecords[indx].env := nil;
        fRecords[indx].stdInStream := nil;
        for j := fRecords[indx].fcgiRecords.count - 1 downto 0 do
        begin
            //no need to set fcgiRecords[j]:= nil because delete(j)
            //will do that, otherwise we will get access violation
            fRecords[indx].fcgiRecords.delete(j);
        end;
        fRecords[indx].fcgiRecords.free();
        fRecords[indx].fcgiRecords := nil;
    end;

    procedure TFcgiRequestManager.clearRecords();
    var i: integer;
    begin
        for i := length(fRecords) - 1 downto 0 do
        begin
            clearFastCgiRecords(i);
        end;
    end;

    (*!------------------------------------------------
     * test if request identified by id exist
     *-----------------------------------------------
     * @param requestId, request id to check
     * @return true if request identified by id exist
     *-----------------------------------------------*)
    function TFcgiRequestManager.has(const requestId : word) : boolean;
    begin
        result := (requestId < length(fRecords)) and fRecords[requestId].used;
    end;

    (*!------------------------------------------------
     * test if web server is done sending request
     * to us identified by id
     *-----------------------------------------------
     * @param requestId, request id to check
     * @return true if request identified by id is complete
     *-----------------------------------------------*)
    function TFcgiRequestManager.complete(const requestId : word) : boolean;
    begin
        result := fRecords[requestId].fcgiStdInComplete and
            fRecords[requestId].fcgiParamsComplete;
    end;

    (*!------------------------------------------------
     * test if web server ask to keep connection open
     *-----------------------------------------------
     * @param requestId, request id to check
     * @return true if request identified by id need to be keep open
     *-----------------------------------------------*)
    function TFcgiRequestManager.keepConnection(const requestId : word) : boolean;
    begin
        result := fRecords[requestId].keepConnection;
    end;

    (*!------------------------------------------------
     * get data from all records identified by request id and type
     *-----------------------------------------------
     * @param requestId, request id
     * @param atype, record type
     * @return stream instance of all records identified by type
     *-----------------------------------------------*)
    function TFcgiRequestManager.getStreamByType(const requestId : word; const atype: byte) : IStreamAdapter;
    var coll : IStreamAdapterCollection;
        i, len : integer;
        rec : IFcgiRecord;
    begin
        coll := fStreamCollectionFactory.build();
        len := fRecords[requestId].fcgiRecords.count;
        for i := 0 to len - 1 do
        begin
            rec := fRecords[requestId].fcgiRecords[i];
            if assigned(rec) and (rec.getType() = atype) then
            begin
                //add its stream to collection
                coll.add(rec.data());
            end;
        end;

        result := (coll as IStreamAdapterAware).data();
    end;

    (*!------------------------------------------------
     * get data from all FCGI_STDIN identified by request id
     *-----------------------------------------------
     * @param requestId, request id
     * @return stream instance of all FCGI_STDIN records
     *-----------------------------------------------*)
    function TFcgiRequestManager.getStdInStream(const requestId : word) : IStreamAdapter;
    begin
        result := fRecords[requestId].stdInStream;
    end;

    (*!------------------------------------------------
     * initialize CGI Environment for request identified by request id
     *-----------------------------------------------
     * @param requestId, request id
     * @return CGI environment
     *-----------------------------------------------*)
    function TFcgiRequestManager.initEnvironment(const requestId : word) : ICGIEnvironment;
    var paramStream : IStreamAdapter;
        factory : ICGIEnvironmentFactory;
    begin
        //get all FCGI_PARAMS records stream as one big stream
        paramStream := getStreamByType(requestId, FCGI_PARAMS);
        factory := TFCGIEnvironmentFactory.create(paramStream);
        result := factory.build();
    end;

    (*!------------------------------------------------
     * get CGI Environment for request identified by request id
     *-----------------------------------------------
     * @param requestId, request id
     * @return CGI environment or nil if environment not ready
     *-----------------------------------------------*)
    function TFcgiRequestManager.getEnvironment(const requestId : word) : ICGIEnvironment;
    begin
        result := fRecords[requestId].env;
    end;

    (*!------------------------------------------------
     * mark request completeness
     *-----------------------------------------------
     * @param rec, record to check
     * @return true if request identified by id is complete
     *-----------------------------------------------*)
    procedure TFcgiRequestManager.markCompleteness(const rec : IFcgiRecord);
    var recType : byte;
        requestId : word;
    begin
        recType := rec.getType();
        requestId := rec.getRequestId();

        if (recType = FCGI_BEGIN_REQUEST) then
        begin
            fRecords[requestId].fcgiStdInComplete := false;
            fRecords[requestId].fcgiParamsComplete := false;
        end;

        //if we received FCGI_PARAMS with empty data, it means web server complete
        //sending FCGI_PARAMS request data.
        if (recType = FCGI_PARAMS) and (rec.getContentLength() = 0) then
        begin
            fRecords[requestId].fcgiParamsComplete := true;
        end;

        //if we received FCGI_STDIN with empty data, it means web server complete
        //sending FCGI_STDIN request data.
        if (recType = FCGI_STDIN) and (rec.getContentLength() = 0) then
        begin
            fRecords[requestId].fcgiStdInComplete := true;
        end;

        if (complete(requestId)) then
        begin
            fRecords[requestId].env := initEnvironment(requestId);
            fRecords[requestId].stdInStream := getStreamByType(requestId, FCGI_STDIN);
        end;
    end;

    (*!------------------------------------------------
     * add FastCGI record to manager
     *-----------------------------------------------
     * @param rec, FastCGI record to add
     * @return id of current request
     *-----------------------------------------------*)
    function TFcgiRequestManager.add(const rec : IFcgiRecord) : IFcgiRequestManager;
    var requestId : word;
        totalRecord : integer;
        hasRequest : boolean;
        beginReq :IFcgiBeginRequest;
    begin
        requestId := rec.getRequestId();
        hasRequest := has(requestId);
        //if we received FCGI_BEGIN_REQUEST, do some test
        if rec.getType() = FCGI_BEGIN_REQUEST then
        begin
            beginReq := rec as IFcgiBeginRequest;
            fRecords[requestId].keepConnection := beginReq.keepConnection();
        end;

        if not hasRequest then
        begin
            totalRecord := length(fRecords);
            if (requestId >= totalRecord) then
            begin
                //increase slot to include requestId in index + 10 additional slot
                //to avoid to many setLength call
                setLength(fRecords, requestId + 1 + 10);
            end;
            initSingleRecord(requestId);
            fRecords[requestId].used := true;
        end;
        fRecords[requestId].fcgiRecords.add(rec);

        markCompleteness(rec);
        result := self;
    end;

    (*!------------------------------------------------
     * remove request
     *-----------------------------------------------
     * @param requestId, request id to be removed
     * @return true of request is removed
     *-----------------------------------------------*)
    function TFcgiRequestManager.remove(const requestId : word) : boolean;
    begin
        initSingleRecord(requestId);
        result := true;
    end;

end.
