{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractControllerImpl;

interface

{$MODE OBJFPC}

uses

    ResponseIntf,
    RequestIntf,
    RequestHandlerIntf,
    RouteArgsReaderIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * abstract controller implementation class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractController = class abstract (TInjectableObject, IRequestHandler)
    public
        (*!-------------------------------------------
         * handle request
         *--------------------------------------------
         * @param request object represent current request
         * @param response object represent current response
         * @param args object represent current route arguments
         * @return new response
         *--------------------------------------------*)
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader
        ) : IResponse; virtual; abstract;
    end;

implementation
end.
