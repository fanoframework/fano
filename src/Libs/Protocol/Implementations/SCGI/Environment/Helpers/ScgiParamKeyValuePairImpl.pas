{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ScgiParamKeyValuePairImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    KeyValuePairImpl;

type
    (*!------------------------------------------------
     * key value pair class having capability
     * to retrieve SCGI environment variable
     *
     * @link https://python.ca/scgi/protocol.txt
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TScgiParamKeyValuePair = class(TKeyValuePair)
    private
        procedure readKeyValueFromString(const aStr : string);
        procedure extractKeyValue(var tmpStr : string; var akey : string; var avalue : string);
    public
        constructor create(const paramStr : string);
    end;

implementation

uses

    StrUtils;

    constructor TScgiParamKeyValuePair.create(const paramStr : string);
    begin
        inherited create();
        readKeyValueFromString(paramStr);
    end;

    procedure TScgiParamKeyValuePair.extractKeyValue(
        var tmpStr : string;
        var akey : string;
        var avalue : string
    );
    var separator0, separator1 : integer;
        lenValue : integer;
    begin
        //environment variable will be pass in tmpStr as
        //key#0value#0key#0value#0key#0value#0 ....
        separator0 := pos(#0, tmpStr);
        separator1 := posEx(#0, tmpStr, separator0 + 1);
        akey := copy(tmpStr, 1, separator0 - 1);
        lenValue := separator1 - separator0 - 1;
        if (lenValue > 0) then
        begin
            avalue := copy(tmpStr, separator0 + 1, lenValue);
        end else
        begin
            avalue := '';
        end;
        delete(tmpStr, 1, separator1);
    end;

    procedure TScgiParamKeyValuePair.readKeyValueFromString(const aStr : string);
    var akey, avalue : string;
        tmpStr : string;
    begin
        tmpStr := aStr;
        while (tmpStr <> '') do
        begin
            extractKeyValue(tmpStr, akey, avalue);
            setValue(akey, avalue);
        end;
    end;

end.
