{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HandlerTypes;

interface

{$MODE OBJFPC}

uses

    RequestIntf,
    ResponseIntf,
    RouteArgsReaderIntf;

type

    (*!-------------------------------------------
     * handle request method
     *--------------------------------------------
     * @param request object represent current request
     * @param response object represent current response
     * @param args object represent current route arguments
     * @return new response
     *--------------------------------------------*)
    THandlerMethod = function (
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader
    ) : IResponse of object;

    (*!-------------------------------------------
     * handle request function
     *--------------------------------------------
     * @param request object represent current request
     * @param response object represent current response
     * @param args object represent current route arguments
     * @return new response
     *--------------------------------------------*)
    THandlerFunc = function (
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader
    ) : IResponse;

implementation

end.
