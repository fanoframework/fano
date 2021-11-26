(*!------------------------------------------------------------
 * Fano Web Framework Skeleton Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-session
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-app-middleware/blob/master/LICENSE (GPL 3.0)
 *------------------------------------------------------------- *)
unit SessionResponseImpl;

interface

uses

    ResponseIntf,
    SessionIntf,
    HeadersIntf,
    CookieIntf,
    CookieFactoryIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * Response implementation which add headers for
     * session data as cookie
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TSessionResponse = class(TInjectableObject, IResponse)
    private
        fResponse : IResponse;

        function addHeaders(
            const hdrs : IHeaders;
            const sess : ISession;
            const cookieFactory : ICookieFactory
        ) : IResponse;
    public
        constructor create(
            const aResponse : IResponse;
            const aSession : ISession;
            const cookieFactory : ICookieFactory
        );
        destructor destroy(); override;

        property response : IResponse read fResponse implements IResponse;
    end;

implementation

    constructor TSessionResponse.create(
        const aResponse : IResponse;
        const aSession : ISession;
        const cookieFactory : ICookieFactory
    );
    begin
        inherited create();
        fResponse := aResponse;
        addHeaders(fResponse.headers(), aSession, cookieFactory);
    end;

    destructor TSessionResponse.destroy();
    begin
        fResponse := nil;
        inherited destroy();
    end;

    function TSessionResponse.addHeaders(
        const hdrs : IHeaders;
        const sess : ISession;
        const cookieFactory : ICookieFactory
    ) : IResponse;
    var cookie : ICookie;
    begin
        cookie := cookieFactory.name(sess.name()).value(sess.id()).build();
        try
            hdrs.setHeader('Set-Cookie', cookie.serialize());
            result := self;
        finally
            cookie := nil;
        end;
    end;

end.
