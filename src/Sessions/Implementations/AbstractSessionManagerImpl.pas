{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractSessionManagerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIntf,
    SessionIdGeneratorIntf,
    ReadOnlySessionManagerIntf,
    SessionManagerIntf,
    RequestIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * base abstract class having capability to manage
     * session variables
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractSessionManager = class(TInjectableObject, ISessionManager, IReadOnlySessionManager)
    protected

        fCookieName : string;
        fSessionIdGenerator : ISessionIdGenerator;

    public

        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param sessionIdGenerator helper class
         *           which can generate session id
         * @param cookieName name of cookie to use
         * @raise ESessionInvalid when cookie name
         *        is empty
         *-------------------------------------*)
        constructor create(
            const sessionIdGenerator : ISessionIdGenerator;
            const cookieName : string
        );

        (*!------------------------------------
         * destructor
         *-------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------
         * create session from request
         *-------------------------------------
         * @param request current request instance
         * @param lifeTimeInSec life time of session in seconds
         * @return session instance
         *-------------------------------------*)
        function beginSession(
            const request : IRequest;
            const lifeTimeInSec : integer
        ) : ISession; virtual; abstract;

        (*!------------------------------------
         * get session from request
         *-------------------------------------
         * @param request current request instance
         * @return session instance or nil if not found
         *-------------------------------------*)
        function getSession(const request : IRequest) : ISession; virtual; abstract;

        (*!------------------------------------
         * end session and save session data to
         * persistent storage
         *-------------------------------------
         * @param session session instance
         * @return current instance
         *-------------------------------------*)
        function endSession(
            const session : ISession
        ) : ISessionManager; virtual; abstract;

    end;

implementation

uses

    SessionConsts,
    ESessionInvalidImpl;

    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param sessionIdGenerator helper class
     *           which can generate session id
     * @param cookieName name of cookie to use
     * @raise ESessionInvalid when cookie name
     *        is empty
     *-------------------------------------*)
    constructor TAbstractSessionManager.create(
        const sessionIdGenerator : ISessionIdGenerator;
        const cookieName : string
    );
    begin
        inherited create();
        fSessionIdGenerator := sessionIdGenerator;
        fCookieName := cookieName;
        if fCookieName = '' then
        begin
            raise ESessionInvalid.create(rsEmptyCookieName);
        end;
    end;

    (*!------------------------------------
     * destructor
     *-------------------------------------*)
    destructor TAbstractSessionManager.destroy();
    begin
        fSessionIdGenerator := nil;
        inherited destroy();
    end;

end.
