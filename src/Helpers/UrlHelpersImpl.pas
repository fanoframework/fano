{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UrlHelpersImpl;

interface

{$MODE OBJFPC}
{$MODESWITCH TYPEHELPERS}
{$H+}

uses

    sysutils;

type

    (*!------------------------------------------------
     * Type helper for url string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUrlHelper = type helper(TStringHelper) for string
    public

        (*!------------------------------------------------
         * url encode
         *-----------------------------------------------*)
        function urlEncode() : string;

        (*!------------------------------------------------
         * url decode
         *-----------------------------------------------*)
        function urlDecode() : string;

        (*!------------------------------------------------
         * remove query string part from URL
         *-------------------------------------------------
         * @return url without query string
         *-----------------------------------------------
         * Example:
         * url := 'http://fanoframework.github.io?id=1'
         * strippedUrl := url.stripQueryString();
         *
         * strippedUrl will contains
         * 'http://fanoframework.github.io'
         *-----------------------------------------------*)
        function stripQueryString() : string;
    end;

implementation

uses

    httpprotocol;

    (*!------------------------------------------------
     * url encode
     *-----------------------------------------------*)
    function TUrlHelper.urlEncode() : string;
    begin
        result := httpEncode(self);
    end;

    (*!------------------------------------------------
     * url decode
     *-----------------------------------------------*)
    function TUrlHelper.urlDecode() : string;
    begin
        result := httpDecode(self);
    end;


    (*!------------------------------------------------
     * remove query string part from URL
     *-------------------------------------------------
     * @return url without query string
     *-----------------------------------------------
     * Example:
     * url := 'http://abc.io?id=1'
     * strippedUrl := url.stripQueryString();
     *
     * strippedUrl will contains
     * 'http://abc.io'
     *-----------------------------------------------*)
    function TUrlHelper.stripQueryString() : string;
    var queryStrPos : integer;
    begin
        queryStrPos := pos('?', self);
        if (queryStrPos = 0) then
        begin
            //no query string
            result := self;
        end else
        begin
            result := system.copy(self, 1, queryStrPos - 1);
        end;
    end;

end.
