{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BaseCorsMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    FactoryImpl,
    DependencyContainerIntf,
    DependencyIntf,
    SysUtils;

type

    (*!------------------------------------------------
     * basic abstract class having capability to create
     * middleware chain instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TBaseCorsMiddlewareFactory = class(TFactory)
    protected
        fAllowedOrigins : TStringArray;
        fAllowedOriginsPatterns : TStringArray;
        fAllowedMethods : TStringArray;
        fAllowedHeaders : TStringArray;
        fExposedHeaders : TStringArray;
        fSupportsCredentials : boolean;
        fMaxAge : integer;
    public
        function allowedOrigins(const allowedOriginArr : array of string) : TBaseCorsMiddlewareFactory;
        function allowedOriginsPatterns(const patternArr : array of string) : TBaseCorsMiddlewareFactory;
        function allowedMethods(const methods : array of string) : TBaseCorsMiddlewareFactory;
        function allowedHeaders(const hdrs : array of string) : TBaseCorsMiddlewareFactory;
        function exposedHeaders(const hdrs : array of string) : TBaseCorsMiddlewareFactory;
        function maxAge(const age : integer) : TBaseCorsMiddlewareFactory;
        function supportsCredentials(const supportCred : boolean) : TBaseCorsMiddlewareFactory;
    end;

implementation

    (*!------------------------------------------------
     * make TStringArray from open array
     *
     * @author Fungus
     * @credit https://forum.lazarus.freepascal.org/index.php/topic,34601.msg227098.html#msg227098
     *-------------------------------------------------*)
    function makeStringArray(const arr : array of string) : TStringArray;
    var i, len: Integer;
    begin
        result := default(TStringArray);
        len := high(arr) - low(arr) + 1;
        setLength(result, len);
        for i:= 0 to len - 1 do
        begin
            result[i] := arr[i];
        end;
    end;

    function TBaseCorsMiddlewareFactory.allowedOrigins(
        const allowedOriginArr : array of string
    ) : TBaseCorsMiddlewareFactory;
    begin
        fAllowedOrigins := makeStringArray(allowedOriginArr);
        result := self;
    end;

    function TBaseCorsMiddlewareFactory.allowedOriginsPatterns(
        const patternArr : array of string
    ) : TBaseCorsMiddlewareFactory;
    begin
        fAllowedOriginsPatterns := makeStringArray(patternArr);
        result := self;
    end;

    function TBaseCorsMiddlewareFactory.allowedMethods(
        const methods : array of string
    ) : TBaseCorsMiddlewareFactory;
    begin
        fAllowedMethods := makeStringArray(methods);
        result := self;
    end;

    function TBaseCorsMiddlewareFactory.allowedHeaders(
        const hdrs : array of string
    ) : TBaseCorsMiddlewareFactory;
    begin
        fAllowedHeaders := makeStringArray(hdrs);
        result := self;
    end;

    function TBaseCorsMiddlewareFactory.exposedHeaders(
        const hdrs : array of string
    ) : TBaseCorsMiddlewareFactory;
    begin
        fExposedHeaders := makeStringArray(hdrs);
        result := self;
    end;

    function TBaseCorsMiddlewareFactory.maxAge(const age : integer) : TBaseCorsMiddlewareFactory;
    begin
        fMaxAge := age;
        result := self;
    end;

    function TBaseCorsMiddlewareFactory.supportsCredentials(
        const supportCred : boolean
    ) : TBaseCorsMiddlewareFactory;
    begin
        fSupportsCredentials := supportCred;
        result := self;
    end;

end.
