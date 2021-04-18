{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullCorsImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    CorsIntf;

type

    (*!------------------------------------------------
     * basic class having capability to
     * handle CORS request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNullCors = class(TInterfacedObject, ICors)
    private
    public
        (*!------------------------------------------------
         * test of current request is allowed
         *-------------------------------------------------
         * @param request current request
         * @return true if request is allowed
         *-------------------------------------------------*)
        function isAllowed(const request : IRequest) : boolean;

        (*!------------------------------------------------
         * test of current request is CORS request
         *-------------------------------------------------
         * @param request current request
         * @return true if request is CORS request
         *-------------------------------------------------*)
        function isCorsRequest(const request : IRequest) : boolean;

        (*!------------------------------------------------
         * test of current request is preflight request
         *-------------------------------------------------
         * @param request current request
         * @return true if request is preflight request
         *-------------------------------------------------*)
        function isPreflightRequest(const request : IRequest) : boolean;

        (*!------------------------------------------------
         * handle prefight request
         *-------------------------------------------------
         * @param response current response object
         * @param request current request object
         * @return response
         *-------------------------------------------------*)
        function handlePreflightRequest(
            const request : IRequest;
            const response : IResponse
        ) : IResponse;

        (*!------------------------------------------------
         * add CORS header to response headers
         *-------------------------------------------------
         * @param request current request
         * @param response current response
         * @return response with added header
         *-------------------------------------------------*)
        function addCorsResponseHeaders(
            const request : IRequest;
            const response : IResponse
        ) : IResponse;
    end;

implementation

    (*!------------------------------------------------
     * test of current request is allowed
     *-------------------------------------------------
     * @param request current request
     * @return true if request is allowed
     *-------------------------------------------------*)
    function TNullCors.isAllowed(const request : IRequest) : boolean;
    begin
        result := true;
    end;

    (*!------------------------------------------------
     * test of current request is CORS request
     *-------------------------------------------------
     * @param requestHeaders request
     * @return true if request is CORS request
     *-------------------------------------------------*)
    function TNullCors.isCorsRequest(const request : IRequest) : boolean;
    begin
        result := false;
    end;

    (*!------------------------------------------------
     * test of current request is preflight request
     *-------------------------------------------------
     * @param requestHeaders request header
     * @return true if request is preflight request
     *-------------------------------------------------*)
    function TNullCors.isPreflightRequest(const request : IRequest) : boolean;
    begin
        result := false;
    end;

    (*!------------------------------------------------
     * handle prefight request
     *-------------------------------------------------
     * @param response current response object
     * @param request current request object
     * @return response
     *-------------------------------------------------*)
    function TNullCors.handlePreflightRequest(
        const request : IRequest;
        const response : IResponse
    ) : IResponse;
    begin
        result := response;
    end;

    (*!------------------------------------------------
     * add CORS header to response headers
     *-------------------------------------------------
     * @param request current request
     * @param response current response
     * @return response with added header
     *-------------------------------------------------*)
    function TNullCors.addCorsResponseHeaders(
        const request : IRequest;
        const response : IResponse
    ) : IResponse;
    begin
        result := response;
    end;

end.
