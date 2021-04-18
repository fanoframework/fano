{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpCacheImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    HttpCacheIntf;

const

    MAX_AGE_1_DAY = 60 * 60 * 24;

type

    (*!------------------------------------------------
     * Http Cache-Control (RFC 7234).
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    THttpCache = class(TInterfacedObject, IHttpCache)
    private
        fCacheType : TCacheControlType;
        fMaxAge : integer;
        fMustRevalidate : boolean;
        fNoStore : boolean;
        fUseETag : boolean;
        function getCacheTypeStr(const aType : TCacheControlType) : string;
        function serializeNoCache() : string;
        function serializeCache() : string;
        function serializeNoStore() : string;
    public
        constructor create(
            const ctype : TCacheControlType = ctPrivate;
            const age : integer = MAX_AGE_1_DAY;
            const must_revalidate : boolean = false
        );
        function serialize() : string;

        procedure setType(const ctype : TCacheControlType);
        function getType() : TCacheControlType;
        property cacheType : TCacheControlType read getType write setType;

        procedure setMaxAge(const age : integer);
        function getMaxAge() : integer;
        property maxAge : integer read getMaxAge write setMaxAge;

        procedure setMustRevalidate(const mrevalidate : boolean);
        function getMustRevalidate() : boolean;
        property mustRevalidate : boolean read getMustRevalidate write setMustRevalidate;

        procedure setNoStore(const donotstore : boolean);
        function getNoStore() : boolean;
        property noStore : boolean read getNoStore write setNoStore;

        procedure setUseETag(const use_etag : boolean);
        function getUseETag() : boolean;
        property useETag : boolean read getUseETag write setUseETag;

    end;

implementation

uses

    SysUtils,
    httpprotocol;

const

    NO_STORE = HeaderCacheControl + ':  no-store';

    constructor THttpCache.create(
        const ctype : TCacheControlType = ctPrivate;
        const age : integer = MAX_AGE_1_DAY;
        const must_revalidate : boolean = false
    );
    begin
        fNoStore := false;
        fCacheType := ctype;
        fMaxAge := age;
        fMustRevalidate := must_revalidate;
        fUseETag := false;
    end;

    procedure THttpCache.setNoStore(const donotstore : boolean);
    begin
        fNoStore := donotstore;
    end;

    function THttpCache.getNoStore() : boolean;
    begin
        result := fNoStore;
    end;

    procedure THttpCache.setType(const ctype : TCacheControlType);
    begin
        fCacheType := ctype;
    end;

    function THttpCache.getType() : TCacheControlType;
    begin
        result := fCacheType;
    end;

    procedure THttpCache.setMaxAge(const age : integer);
    begin
        fMaxAge := age;
    end;

    function THttpCache.getMaxAge() : integer;
    begin
        result := fMaxAge;
    end;

    procedure THttpCache.setMustRevalidate(const mrevalidate : boolean);
    begin
        fMustRevalidate := mrevalidate;
    end;

    function THttpCache.getMustRevalidate() : boolean;
    begin
        result := fMustRevalidate;
    end;

    procedure THttpCache.setUseETag(const use_etag : boolean);
    begin
        fUseETag := use_etag;
    end;

    function THttpCache.getUseETag() : boolean;
    begin
        result := fUseETag;
    end;

    function THttpCache.getCacheTypeStr(const aType : TCacheControlType) : string;
    begin
        if aType = ctPublic then
        begin
            result := 'public';
        end else
        begin
            result := 'private';
        end;
    end;

    function THttpCache.serializeNoCache() : string;
    begin
        result := HeaderCacheControl + ': ' + getCacheTypeStr(fCacheType) + ', no-cache';
        if fMustRevalidate then
        begin
            result := result + ', must-revalidate';
        end;
    end;

    function THttpCache.serializeNoStore() : string;
    begin
        result := NO_STORE;
    end;

    function THttpCache.serializeCache() : string;
    begin
        result := HeaderCacheControl + ': ' + getCacheTypeStr(fCacheType) +
            ', max-age=' + intToStr(fMaxAge);
        if fMustRevalidate then
        begin
            result := result + ', must-revalidate';
        end;
    end;

    function THttpCache.serialize() : string;
    begin
        if fNoStore then
        begin
            result := serializeNoStore();
        end else
        begin
            if fMaxAge = 0 then
            begin
                result := serializeNoCache();
            end else
            begin
                result := serializeCache();
            end;
        end;
    end;

end.
