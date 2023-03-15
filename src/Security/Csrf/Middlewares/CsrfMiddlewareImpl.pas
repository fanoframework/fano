{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CsrfMiddlewareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    MiddlewareIntf,
    RequestHandlerIntf,
    RouteArgsReaderIntf,
    CsrfIntf,
    SessionManagerIntf,
    SessionIntf,
    CsrfConsts,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * middleware that prevent Cross-Site Request Forgery
     * (CSRF) attack by checking if request has proper
     * token
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCsrfMiddleware = class(TInjectableObject, IMiddleware)
    private
        fCsrf : ICsrf;
        fSessionMgr : ISessionManager;
        fFailureHandler : IRequestHandler;
        fNameKey : shortstring;
        fValueKey : shortstring;

        function handleCsrfRequest(
            const sess : ISession;
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;

        procedure generateNewToken(const sess : ISession);

    public
        constructor create(
            const csrf : ICsrf;
            const sessionMgr : ISessionManager;
            const failureHandler : IRequestHandler;
            const nameKey : shortstring = CSRF_NAME;
            const valueKey : shortstring = CSRF_TOKEN
        );
        destructor destroy(); override;

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

    constructor TCsrfMiddleware.create(
        const csrf : ICsrf;
        const sessionMgr : ISessionManager;
        const failureHandler : IRequestHandler;
        const nameKey : shortstring = CSRF_NAME;
        const valueKey : shortstring = CSRF_TOKEN
    );
    begin
        fCsrf := csrf;
        fSessionMgr := sessionMgr;
        fFailureHandler := failureHandler;
        fNameKey := nameKey;
        fValueKey := valueKey;
    end;

    destructor TCsrfMiddleware.destroy();
    begin
        fCsrf := nil;
        fSessionMgr := nil;
        fFailureHandler := nil;
        inherited destroy();
    end;

    procedure TCsrfMiddleware.generateNewToken(const sess : ISession);
    var tokenName, tokenValue : string;
    begin
        fCsrf.generateToken(tokenName, tokenValue);
        sess[fNameKey] := tokenName;
        sess[fValueKey] := tokenValue;
    end;

    function TCsrfMiddleware.handleCsrfRequest(
        const sess : ISession;
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    begin
        if fCsrf.hasValidToken(request, sess, fNameKey, fValueKey)  then
        begin
            generateNewToken(sess);
            result := next.handleRequest(request, response, args);
        end else
        begin
            generateNewToken(sess);
            result := fFailureHandler.handleRequest(request, response, args);
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
    function TCsrfMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    var isCsrfMethod : boolean;
        sess : ISession;
    begin
        sess := fSessionMgr[request];
        isCsrfMethod := (request.method = 'POST') or
            (request.method = 'PUT') or
            (request.method = 'DELETE') or
            (request.method = 'PATCH');

        if isCsrfMethod then
        begin
            result := handleCsrfRequest(sess, request, response, args, next);
        end else
        begin
            generateNewToken(sess);
            result := next.handleRequest(request, response, args);
        end;
    end;

end.
