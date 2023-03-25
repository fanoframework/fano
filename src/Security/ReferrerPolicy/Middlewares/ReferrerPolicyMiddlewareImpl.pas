{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ReferrerPolicyMiddlewareImpl;

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
    ReferrerPolicyConfig;

type

    (*!------------------------------------------------
     * middleware that add Referrer-Policy header
     *-------------------------------------------------
     * https://www.w3.org/TR/referrer-policy
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TReferrerPolicyMiddleware = class(TInjectableObject, IMiddleware)
    protected
        fReferrerPolicyConfig: TReferrerPolicyConfig;
    public
        constructor create(const config: TReferrerPolicyConfig);

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

    constructor TReferrerPolicyMiddleware.create(const config: TReferrerPolicyConfig);
    begin
        fReferrerPolicyConfig := config;
        if fReferrerPolicyConfig = [] then
        begin
            raise EArgumentException.create('Referrer policy must contains at least one policy')
        end;
    end;

    function buildReferrerPolicyValue(const config: TReferrerPolicyConfig) : string;
    var rpToken: TReferrerPolicyToken;
    begin
        result:= '';
        for rpToken := noReferrer to unsafeUrl do
        begin
            if rpToken in config then
            begin
                if result = '' then
                begin
                    result := ReferrerPolicyTokenStr[rpToken];
                end else
                begin
                    result := result + ',' + ReferrerPolicyTokenStr[rpToken];
                end;
            end;
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
    function TReferrerPolicyMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    begin
        result := next.handleRequest(request, response, args);
        result.headers().setHeader('Referrer-Policy', buildReferrerPolicyValue(fReferrerPolicyConfig));
    end;

end.
