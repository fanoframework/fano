{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CorsIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * handle Cross-Origin Resource Sharing request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ICors = interface
        ['{E491F183-82E4-4A46-8B5E-38A965CC44B3}']

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
         * @param request current request object
         * @param response current response object
         * @return response with added header
         *-------------------------------------------------*)
        function addCorsResponseHeaders(
            const request : IRequest;
            const response : IResponse
        ) : IResponse;
    end;

implementation

end.
