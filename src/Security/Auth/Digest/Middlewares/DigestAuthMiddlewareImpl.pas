{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DigestAuthMiddlewareImpl;

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
    AuthIntf,
    RandomIntf,
    InjectableObjectImpl,
    DigestInfoTypes,
    CredentialTypes;

type

    (*!------------------------------------------------
     * middleware implementation that authenticate using
     * Digest Authentication (RFC 2617)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TDigestAuthMiddleware = class(TInjectableObject, IMiddleware)
    private
        fRandom : IRandom;

        //basic authentication realm
        fRealm : string;

        //instance of class responsible to authenticate credential
        fAuth : IAuth;

        (*!------------------------------------------------
         * extract credential from Basic Authentatication
         *-------------------------------------------------
         * @param request current request object
         * @param foundCredential extracted credential
         * @return boolean true if credential succesfully read
         *-------------------------------------------------*)
        function getCredential(
            const request : IRequest;
            out foundCredential : TCredential
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
         * @param auth object responsible to authenticate
         * @param realm string of realm value
         *-------------------------------------------------*)
        constructor create(
            const randomObj : IRandom;
            const auth : IAuth;
            const realm : string
        );

        (*!------------------------------------------------
         * destructor
         *-------------------------------------------------*)
        destructor destroy(); override;

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
    Md5,
    HttpCodeResponseImpl,
    DigestInfoHelper;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param randomObj object responsible to generate random bytes
     * @param auth object responsible to authenticate
     * @param realm string of realm value
     *-------------------------------------------------*)
    constructor TDigestAuthMiddleware.create(
        const randomObj : IRandom;
        const auth : IAuth;
        const realm : string
    );
    begin
        inherited create();
        fRandom := randomObj;
        fAuth := auth;
        fRealm := realm;
    end;

    (*!------------------------------------------------
     * destructor
     *-------------------------------------------------*)
    destructor TDigestAuthMiddleware.destroy();
    begin
        fRandom := nil;
        fAuth := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * extract credential from Basic Authentatication
     *-------------------------------------------------
     * @param request current request object
     * @param foundCredential extracted credential
     * @return boolean true if credential succesfully read
     *-------------------------------------------------*)
    function TDigestAuthMiddleware.getCredential(
        const request : IRequest;
        out foundCredential : TCredential
    ) : boolean;
    const
        DIGEST_STR = 'digest ';
    var
        authHeaderLine : string;
        digestInfo : PDigestInfo;
    begin
        result := false;
        foundCredential.username := '';
        foundCredential.password := '';
        foundCredential.data := nil;

        if request.headers().has('Authorization') then
        begin
            authHeaderLine := request.headers().getHeader('Authorization');
            if pos(DIGEST_STR, trimLeft(lowercase(authHeaderLine))) = 1 then
            begin
                digestInfo := getDigestInfo(request.method, authHeaderLine);
                if (fRealm = digestInfo^.realm) then
                begin
                    //only continue if realm matched
                    foundCredential.username := digestInfo^.username;
                    foundCredential.password := digestInfo^.response;
                    foundCredential.data := digestInfo;
                    result := true;
                end;
            end;
        end;
    end;

    (*!------------------------------------------------
     * handle authentication
     *-------------------------------------------------
     * @param response current response object
     * @return response
    *-------------------------------------------------*)
    function TDigestAuthMiddleware.handleUnauthorized(
        const response : IResponse
    ) : IResponse;
    var nonce, opaque : string;
        rndValue : TBytes;
    begin
        rndValue := fRandom.randomBytes(32);
        nonce := MD5Print(MD5Buffer(rndValue, length(rndValue)));
        rndValue := fRandom.randomBytes(32);
        opaque := MD5Print(MD5Buffer(rndValue, length(rndValue)));

        result := THttpCodeResponse.create(
            401,
            'Unauthorized',
            response.headers()
        );
        result.headers().setHeader(
            'WWW-Authenticate',
            format(
                'Digest realm="%s", qop="auth,auth-int", nonce="%s", opaque="%s"',
                [ fRealm, nonce, opaque ]
            )
        );
    end;

    (*!------------------------------------------------
     * handle forbidden request
     *-------------------------------------------------
     * @param response current response object
     * @return 403 response
    *-------------------------------------------------*)
    function TDigestAuthMiddleware.handleForbidden(
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
    function TDigestAuthMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    var cred : TCredential;
        credentialFound : boolean;
    begin
        credentialFound := getCredential(request, cred);
        try
            if credentialFound then
            begin
                if (fAuth.auth(cred)) then
                begin
                    //continue to next middleware
                    result := next.handleRequest(request, response, args);
                end else
                begin
                    result := handleForbidden(response);
                end;
            end else
            begin
                result := handleUnauthorized(response);
            end;
        finally
            //getCredential() will allocate PDigestInfo in heap in cred.data
            //need to make sure we properly free them
            freeDigestInfo(PDigestInfo(cred.data));
        end;
    end;

end.
