{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DeferExceptionRouteHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    RouteIntf,
    RouteHandlerIntf,
    RequestHandlerIntf,
    RouteArgsWriterIntf,
    RouteArgsReaderIntf,
    MiddlewareLinkListIntf;

type

    (*!------------------------------------------------
     * internal abstract class which is used in MwExecDispatcher
     * to defer raise of exception until
     * in handleRequest
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TDeferExceptionRouteHandler = class abstract (TInterfacedObject, IRouteHandler, IRequestHandler)
    protected
        fExceptionMessage : string;
    public
        constructor create(const exceptionMsg : string);

        (*!-------------------------------------------
         * get middlewares list
         *--------------------------------------------
         * @return middleware list
         *--------------------------------------------*)
        function middlewares() : IMiddlewareLinkList;

        (*!-------------------------------------------
         * get route instance
         *--------------------------------------------
         * @return route instance
         *--------------------------------------------*)
        function route() : IRoute;

        (*!-------------------------------------------
         * get request handler
         *--------------------------------------------
         * @return request handler
         *--------------------------------------------*)
        function handler() : IRequestHandler;

        (*!-------------------------------------------
         * get router arguments writer
         *--------------------------------------------
         * @return route arguments writer instance
         *--------------------------------------------*)
        function argsWriter() : IRouteArgsWriter;

        (*!-------------------------------------------
         * get router arguments reader
         *--------------------------------------------
         * @return route arguments writer instance
         *--------------------------------------------*)
        function argsReader() : IRouteArgsReader;

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

uses

    NullMiddlewareListImpl,
    NullRouteArgsImpl,
    NullRouteImpl;

    constructor TDeferExceptionRouteHandler.create(const exceptionMsg : string);
    begin
        fExceptionMessage := exceptionMsg;
    end;

    (*!-------------------------------------------
     * get middlewares list
     *--------------------------------------------
     * @return middleware list
     *--------------------------------------------*)
    function TDeferExceptionRouteHandler.middlewares() : IMiddlewareLinkList;
    begin
        //if we have to use this class it means normal route matching
        //already fails i.e route not found or method is not allowed
        //so getting middleware for route is pointless so we just return null implementation
        result := TNullMiddlewareList.create();
    end;

    (*!-------------------------------------------
     * get route instance
     *--------------------------------------------
     * @return route instance
     *--------------------------------------------*)
    function TDeferExceptionRouteHandler.route() : IRoute;
    begin
        //if we have to use this class it means normal route matching
        //already fails i.e route not found or method is not allowed
        //so getting route is pointless so we just return null implementation
        result := TNullRoute.create();
    end;

    (*!-------------------------------------------
     * get request handler
     *--------------------------------------------
     * @return request handler
     *--------------------------------------------*)
    function TDeferExceptionRouteHandler.handler() : IRequestHandler;
    begin
        result := self;
    end;

    (*!-------------------------------------------
     * get router arguments writer
     *--------------------------------------------
     * @return route arguments writer instance
     *--------------------------------------------*)
    function TDeferExceptionRouteHandler.argsWriter() : IRouteArgsWriter;
    begin
        //if we have to use this class it means normal route matching
        //already fails i.e route not found or method is not allowed
        //getting route argument is pointless, so return null implementation
        result := TNullRouteArgs.create();
    end;

    (*!-------------------------------------------
     * get router arguments reader
     *--------------------------------------------
     * @return route arguments writer instance
     *--------------------------------------------*)
    function TDeferExceptionRouteHandler.argsReader() : IRouteArgsReader;
    begin
        //if we have to use this class it means normal route matching
        //already fails i.e route not found or method is not allowed
        //getting route argument is pointless, so return null implementation
        result := TNullRouteArgs.create();
    end;

end.
