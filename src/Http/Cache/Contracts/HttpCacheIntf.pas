{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpCacheIntf;

interface

{$MODE OBJFPC}

uses

    SerializeableIntf;

type

    TCacheControlType = (ctPublic, ctPrivate);

    (*!------------------------------------------------
     * INterface for any class having capability to setup
     * Http Cache-Control (RFC 7234).
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IHttpCache = interface(ISerializeable)
        ['{1497693F-84F8-4DD5-A5A5-2EFB2F4AF896}']

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

end.
