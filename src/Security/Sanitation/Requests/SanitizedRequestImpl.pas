{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SanitizedRequestImpl;

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
    ListIntf,
    SanitizerIntf,
    DecoratorRequestImpl;

type

    (*!------------------------------------------------
     * IRequest implementation class which sanitized input
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSanitizedRequest = class(TDecoratorRequest)
    private
        fSanitizer : ISanitizer;
    public
        constructor create(const request : IRequest; const aSanitizer : ISanitizer);

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
        ) : string; override;

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
        ) : string; override;

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
         * get request query string or body data
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         *------------------------------------------------*)
        function getParam(const key: string; const defValue : string = '') : string; override;
    end;

implementation

uses

    SysUtils,
    HashListImpl,
    KeyValueTypes,
    SanitizedReadOnlyListImpl;


    constructor TSanitizedRequest.create(
        const request : IRequest;
        const aSanitizer : ISanitizer);
    begin
        inherited create(request);
        fSanitizer := aSanitizer;
    end;

    (*!------------------------------------------------
     * get single query param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TSanitizedRequest.getQueryParam(
        const key: string;
        const defValue : string = ''
    ) : string;
    begin
        result := fSanitizer.sanitize(inherited getQueryParam(key, defValue));
    end;

    (*!------------------------------------------------
     * get request body data
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TSanitizedRequest.getParsedBodyParam(const key: string; const defValue : string = '') : string;
    begin
        result := fSanitizer.sanitize(inherited getParsedBodyParam(key, defValue));
    end;

    (*!------------------------------------------------
     * get single cookie param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TSanitizedRequest.getCookieParam(const key: string; const defValue : string = '') : string;
    begin
        result := fSanitizer.sanitize(inherited getCookieParam(key, defValue));
    end;

    (*!------------------------------------------------
     * get single query param or body param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     *------------------------------------------------*)
    function TSanitizedRequest.getParam(const key: string; const defValue : string = '') : string;
    begin
        result := fSanitizer.sanitize(inherited getParam(key, defValue));
    end;

end.
