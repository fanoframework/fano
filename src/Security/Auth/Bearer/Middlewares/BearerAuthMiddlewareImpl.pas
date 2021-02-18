{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit BearerAuthMiddlewareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    MiddlewareIntf,
    RequestIntf,
    ResponseIntf,
    HeadersIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    TokenVerifierIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * middleware implementation that authenticate using
     * Bearer Authentication (RFC 6750)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TBearerAuthMiddleware = class(TInjectableObject, IMiddleware)
    private
        //bearer authentication realm
        fRealm : string;

        //key to use to store found credential name in request
        fCredentialKey : shortstring;

        //instance of class responsible to verify token
        fTokenVerifier : ITokenVerifier;

        (*!------------------------------------------------
         * extract credential from Bearer Authentatication
         *-------------------------------------------------
         * @param request current request object
         * @param foundToken extracted token
         * @return boolean true if credential succesfully read
         *-------------------------------------------------*)
        function extractTokenFromRequest(
            const request : IRequest;
            out foundToken : string
        ) : boolean;

        (*!------------------------------------------------
         * handle unauthorized request
         *-------------------------------------------------
         * @param response current response object
         * @return 401 response
         *-------------------------------------------------*)
        function handleUnauthorized(const response : IResponse) : IResponse;

        (*!------------------------------------------------
         * handle forbidden request
         *-------------------------------------------------
         * @param response current response object
         * @return 403 response
         *-------------------------------------------------*)
        function handleForbidden(const response : IResponse) : IResponse;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param auth object responsible to verify token
         * @param realm string of realm value
         * @param credentialKey name of the key to use to store
         *      verified credential in request object
         *-------------------------------------------------*)
        constructor create(
            const tokenVerifier : ITokenVerifier;
            const realm : string;
            const credentialKey : shortstring
        );

        (*!------------------------------------------------
         * handle authentication
         *-------------------------------------------------
         * @param request current request object
         * @param response current response object
         * @param args route argument reader
         * @param next next middleware to run
         * @return response
         *-------------------------------------------------*)
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;
    end;

implementation

uses

    SysUtils,
    Base64,
    CredentialRequestImpl,
    HttpCodeResponseImpl,
    VerificationResultTypes;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param tokenVerifier object responsible to verify token
     * @param realm string of realm value
     * @param credentialKey name of the key to use to store
     *      verified credential in request object
     *-------------------------------------------------*)
    constructor TBearerAuthMiddleware.create(
        const tokenVerifier : ITokenVerifier;
        const realm : string;
        const credentialKey : shortstring
    );
    begin
        inherited create();
        fTokenVerifier := tokenVerifier;
        fRealm := realm;
        fCredentialKey := credentialKey;
    end;

    (*!------------------------------------------------
     * extract credential from Bearer Authentatication
     *-------------------------------------------------
     * @param request current request object
     * @param foundToken extracted token
     * @return boolean true if credential succesfully read
     *-------------------------------------------------*)
    function TBearerAuthMiddleware.extractTokenFromRequest(
        const request : IRequest;
        out foundToken : string
    ) : boolean;
    const
        BEARER_STR = 'bearer';
        BEARER_STR_LEN = length(BEARER_STR);
    var
        authHeaderLine : string;
    begin
        result := false;

        if request.headers().has('Authorization') then
        begin
            authHeaderLine := request.headers().getHeader('Authorization');
            if pos(BEARER_STR, trimLeft(lowercase(authHeaderLine))) = 1 then
            begin
                foundToken := trim(copy(
                    authHeaderLine,
                    BEARER_STR_LEN + 1,
                    length(authHeaderLine) - BEARER_STR_LEN
                ));

                result := true;
            end;
        end;
    end;

    (*!------------------------------------------------
     * handle authentication
     *-------------------------------------------------
     * @param response current response object
     * @return response
    *-------------------------------------------------*)
    function TBearerAuthMiddleware.handleUnauthorized(
        const response : IResponse
    ) : IResponse;
    begin
        result := THttpCodeResponse.create(
            401,
            'Unauthorized',
            response.headers()
        );
        result.headers().setHeader(
            'WWW-Authenticate',
            'Bearer realm="' + fRealm + '"'
        );
    end;

    (*!------------------------------------------------
     * handle forbidden request
     *-------------------------------------------------
     * @param response current response object
     * @return 403 response
     *-------------------------------------------------*)
    function TBearerAuthMiddleware.handleForbidden(
        const response : IResponse
    ) : IResponse;
    begin
        result := THttpCodeResponse.create(
            403,
            'Forbidden',
            response.headers()
        );
    end;

    (*!------------------------------------------------
     * handle authentication
     *-------------------------------------------------
     * @param request current request object
     * @param response current response object
     * @param args route argument reader
     * @param next next middleware to run
     * @return response
     *-------------------------------------------------*)
    function TBearerAuthMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    var token : string;
        verifyRes : TVerificationResult;
        credentialRequest : IRequest;
    begin
        if extractTokenFromRequest(request, token) then
        begin
            verifyRes := fTokenVerifier.verify(token);
            if (verifyRes.verified) then
            begin
                //store credential info in request
                credentialRequest := TCredentialRequest.create(
                    request,
                    fCredentialKey,
                    verifyRes.credential
                );
                //continue to next middleware
                result := next.handleRequest(credentialRequest, response, args);
            end else
            begin
                result := handleForbidden(response);
            end;
        end else
        begin
            result := handleUnauthorized(response);
        end;
    end;

end.
