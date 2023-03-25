{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HstsMiddlewareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    MiddlewareIntf,
    RequestHandlerIntf,
    RouteArgsReaderIntf,
    InjectableObjectImpl,
    HstsConfig;

type

    (*!------------------------------------------------
     * middleware that add HTTP Strict Transport Security
     * header (RFC 6797)
     *-------------------------------------------------
     * https://www.rfc-editor.org/rfc/rfc6797
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    THstsMiddleware = class(TInjectableObject, IMiddleware)
    protected
        fHstsConfig: THtstConfig;
    public
        constructor create(const config: THtstConfig);

        (*!---------------------------------------
         * handle request and validate request
         *----------------------------------------
         * @param request request instance
         * @param response response instance
         * @param route arguments
         * @param next next middleware to execute
         * @return response
         *----------------------------------------*)
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;

    end;

implementation

uses

    SysUtils;

    constructor THstsMiddleware.create(const config: THtstConfig);
    begin
        fHstsConfig := config;
        if fHstsConfig.maxAge < 0 then
        begin
            raise EArgumentException.createFmt(
                'Max age must be positive integer but got %d',
                [ fHstsConfig.maxAge ]
            )
        end;
    end;

    function buildHstsValue(const config: THtstConfig) : string;
    begin
        result:= 'max-age=' + IntToStr(config.maxAge);
        if config.includeSubDomains then
        begin
            result:= result + '; includeSubDomains';
        end;
    end;

    (*!---------------------------------------
     * handle request
     *----------------------------------------
     * @param request request instance
     * @param response response instance
     * @param route arguments
     * @param next next middleware to execute
     * @return response
     *----------------------------------------*)
    function THstsMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    begin
        result := next.handleRequest(request, response, args);
        result.headers().setHeader('Strict-Transport-Security', buildHstsValue(fHstsConfig));
    end;

end.
