{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonRequestImpl;

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
    UriIntf,
    fpjson,
    ListIntf,
    DecoratorRequestImpl;

type

    (*!------------------------------------------------
     * IRequest implementation class having capability as
     * HTTP request with Content-Type: application/json
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TJsonRequest = class(TDecoratorRequest)
    private
        fBodyJson : TJsonData;
        fBodyList : IList;

        procedure buildObjectFlatList(
            const bodyJson : TJsonData;
            const bodyList : IList;
            const currentKey : string
        );

        procedure buildFlatList(
            const bodyJson : TJsonData;
            const bodyList : IList;
            const currentKey : string
        );
        procedure init(const respBody : string);
        procedure freeData(const bodyList : IList);
    public
        constructor create(const request : IRequest);
        destructor destroy(); override;

        (*!------------------------------------------------
         * get request body data
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getParsedBodyParam(const key: string; const defValue : string = '') : string; override;

        (*!------------------------------------------------
         * get all request body data
         *-------------------------------------------------
         * @return array of parsed body params
         *------------------------------------------------*)
        function getParsedBodyParams() : IReadOnlyList; override;

        (*!------------------------------------------------
         * get request query string or body data
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getParam(const key: string; const defValue : string = '') : string; override;

        (*!------------------------------------------------
         * get all request query string body data
         *-------------------------------------------------
         * @return array of query string and parsed body params
         *------------------------------------------------*)
        function getParams() : IReadOnlyList; override;
    end;

implementation

uses

    SysUtils,
    jsonparser,
    HashListImpl,
    KeyValueTypes,
    CompositeReadOnlyListImpl;

    procedure TJsonRequest.buildObjectFlatList(
        const bodyJson : TJsonData;
        const bodyList : IList;
        const currentKey : string
    );
    var i : integer;
        key : string;
    begin
        for i := 0 to bodyJson.count - 1 do
        begin
            if (bodyJson.JSONType = jtArray) then
            begin
                key := inttoStr(i);
            end else
            begin
                key := TJsonObject(bodyJson).names[i];
            end;

            if (currentKey <> '') then
            begin
                key := currentKey + '.' + key
            end;

            buildFlatList(bodyJson.items[i], bodyList, key);
        end;
    end;

    procedure TJsonRequest.buildFlatList(
        const bodyJson : TJsonData;
        const bodyList : IList;
        const currentKey : string
    );
    var keyval : PKeyValue;
    begin
        if not assigned(bodyJson) then
        begin
            exit();
        end;

        case bodyJson.JSONType of
            jtArray, jtObject :
                begin
                    buildObjectFlatList(bodyJson, bodyList, currentKey);
                end;
            jtNull:
                begin
                    bodyList.add(currentKey, nil);
                end;
            else
                begin
                    new(keyval);
                    keyval^.key := currentKey;
                    keyval^.value := bodyJson.asString;
                    bodyList.add(currentKey, keyval);
                end;
        end;
    end;

    procedure TJsonRequest.freeData(const bodyList : IList);
    var i: integer;
        keyval : PKeyValue;
    begin
        for i:= bodyList.count-1 downto 0 do
        begin
            keyval := bodyList.get(i);
            dispose(keyval);
            bodyList.delete(i);
        end;
    end;

    procedure TJsonRequest.init(const respBody : string);
    begin
        //TODO: Should we decouple this?
        fBodyList := THashList.create();
        try
            fBodyJson := getJSON(respBody);
            buildFlatList(fBodyJson, fBodyList, '');
        except
            freeData(fBodyList);
            fBodyJson.free();
            fBodyJson := nil;
            fBodyList := nil;
            raise;
        end;
    end;

    constructor TJsonRequest.create(const request : IRequest);
    begin
        inherited create(request);
        init(request.getParsedBodyParam('application/json'));
    end;

    destructor TJsonRequest.destroy();
    begin
        freeData(fBodyList);
        fBodyJson.free();
        fBodyList := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * get request body data
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TJsonRequest.getParsedBodyParam(const key: string; const defValue : string = '') : string;
    var data : TJSONData;
    begin
        result := defValue;
        data := fBodyJson.findPath(key);
        if (data <> nil) then
        begin
            if data.count > 0 then
            begin
                //it is data having child just return is as JSON string
                result := data.asJSON;
            end else
            begin
                result := data.asString;
            end;
        end;
    end;

    (*!------------------------------------------------
     * get all request body data
     *-------------------------------------------------
     * @return list of request body parameters
     *------------------------------------------------*)
    function TJsonRequest.getParsedBodyParams() : IReadOnlyList;
    begin
        result := fBodyList;
    end;

    (*!------------------------------------------------
     * get single query param or body param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TJsonRequest.getParam(const key: string; const defValue : string = '') : string;
    begin
        result := inherited getParam(key, defValue);
        if (result = defValue) then
        begin
            //if we get here, key not found, try JSON body
            result := getParsedBodyParam(key, defValue);
        end;
    end;

    (*!------------------------------------------------
     * get all request query strings or body data
     *-------------------------------------------------
     * @return list of request query string parameters
     *------------------------------------------------*)
    function TJsonRequest.getParams() : IReadOnlyList;
    begin
        result := TCompositeReadOnlyList.create(fActualRequest.getParams(), fBodyList);
    end;


end.
