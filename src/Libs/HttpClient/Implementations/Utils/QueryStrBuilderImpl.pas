{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit QueryStrBuilderImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    QueryStrBuilderIntf,
    SerializeableIntf;

type

    (*!------------------------------------------------
     * class that having capability to build
     * url with query string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TQueryStrBuilder = class(TInterfacedObject, IQueryStrBuilder)
    private
        (*!------------------------------------------------
         * append query params
         *-----------------------------------------------
         * @param url url to send request
         * @param params query string
         * @return url with query string appended
         *-----------------------------------------------*)
        function appendQueryParams(
            const url : string;
            const params : string
        ) : string;

    public

        (*!------------------------------------------------
         * build URL with query string appended
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return url with query string appended
         *-----------------------------------------------*)
        function buildUrlWithQueryParams(
            const url : string;
            const data : ISerializeable = nil
        ) : string;

    end;

implementation

    (*!------------------------------------------------
     * append query params
     *-----------------------------------------------
     * @param url url to send request
     * @param params query string
     * @return url with query string appended
     *-----------------------------------------------*)
    function TQueryStrBuilder.appendQueryParams(
        const url : string;
        const params : string
    ) : string;
    begin
        if (pos('?', url) > 0) then
        begin
            //if we get here URL already contains query parameters
            result := url + params;
        end else
        begin
            //if we get here, URL has no query parameters
            result := url + '?' + params;
        end;
    end;

    (*!------------------------------------------------
     * build URL with query string appended
     *-----------------------------------------------
     * @param url url to send request
     * @param data data related to this request
     * @return url with query string appended
     *-----------------------------------------------*)
    function TQueryStrBuilder.buildUrlWithQueryParams(
        const url : string;
        const data : ISerializeable = nil
    ) : string;
    var params : string;
    begin
        result := url;
        if (data <> nil) then
        begin
            params := data.serialize();
            if (params <> '') then
            begin
                result := appendQueryParams(result, params);
            end;
        end;
    end;
end.
