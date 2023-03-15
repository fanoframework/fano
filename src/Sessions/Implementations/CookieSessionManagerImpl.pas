{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CookieSessionManagerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIntf,
    SessionIdGeneratorIntf,
    SessionManagerIntf,
    SessionFactoryIntf,
    RequestIntf,
    ListIntf,
    DecrypterIntf,
    AbstractSessionManagerImpl;

type

    (*!------------------------------------------------
     * class having capability to manage
     * session variables in encrypted cookie
     *
     * TODO: Current implementation is not thread safe.
     *       Need to rethink when dealing multiple threads
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCookieSessionManager = class(TAbstractSessionManager)
    private
        fCurrentSession : ISession;
        fSessionFactory : ISessionFactory;
        fDecrypter : IDecrypter;

        (*!------------------------------------
         * end session and remove its storage
         *-------------------------------------
         * @param session session instance
         * @return current instance
         *-------------------------------------*)
        function destroySession(
            const session : ISession
        ) : ISessionManager;

        function createNewSessionIfExpired(
            const request : IRequest;
            const lifeTimeInSec : integer;
            const encryptedSession : string
        ) : ISession;
    public

        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param sessionIdGenerator helper class
         *           which can generate session id
         * @param sessionFactory helper class
         *           which create ISession object
         * @param cookieName name of cookie to use
         * @param encrypter
         *-------------------------------------*)
        constructor create(
            const sessionIdGenerator : ISessionIdGenerator;
            const sessionFactory : ISessionFactory;
            const cookieName : string;
            const decrypter : IDecrypter
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
        ) : ISession; override;

        (*!------------------------------------
         * get session from request
         *-------------------------------------
         * @param request current request instance
         * @return session instance or nil if not found
         *-------------------------------------*)
        function getSession(const request : IRequest) : ISession; override;

        (*!------------------------------------
         * end session and save session data to
         * persistent storage
         *-------------------------------------
         * @param session session instance
         * @return current instance
         *-------------------------------------*)
        function endSession(
            const session : ISession
        ) : ISessionManager; override;

    end;

implementation

uses

    Classes,
    SysUtils,
    DateUtils,
    SessionConsts,
    HashListImpl,
    ESessionExpiredImpl,
    ESessionInvalidImpl;

    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param sessionIdGenerator helper class
     *           which can generate session id
     * @param cookieName name of cookie to use
     * @param fileReader helper class
     *           which can read file to string
     * @param baseDir base directory where
     *                session files store
     * @param decrypter decrypter instance
     *-------------------------------------*)
    constructor TCookieSessionManager.create(
        const sessionIdGenerator : ISessionIdGenerator;
        const sessionFactory : ISessionFactory;
        const cookieName : string;
        const decrypter : IDecrypter
    );
    begin
        inherited create(sessionIdGenerator, cookieName);
        fSessionFactory := sessionFactory;
        fCurrentSession := nil;
        fDecrypter := decrypter;
    end;

    (*!------------------------------------
     * destructor
     *-------------------------------------*)
    destructor TCookieSessionManager.destroy();
    begin
        fDecrypter := nil;
        fCurrentSession := nil;
        fSessionFactory := nil;
        inherited destroy();
    end;

    function TCookieSessionManager.createNewSessionIfExpired(
        const request : IRequest;
        const lifeTimeInSec : integer;
        const encryptedSession : string
    ) : ISession;
    var sessData : string;
    begin
        result := nil;
        try
            if encryptedSession = '' then
            begin
                //no cookie, just create new one
                result := fSessionFactory.createNewSession(
                    fCookieName,
                    encryptedSession,
                    incSecond(now(), lifeTimeInSec)
                );
            end else
            begin
                //session data is encrypted in cookie value
                sessData := fDecrypter.decrypt(encryptedSession);
                if sessData = '' then
                begin
                    //oops something is not right, ignore and just create new session
                    result := fSessionFactory.createNewSession(
                        fCookieName,
                        encryptedSession,
                        incSecond(now(), lifeTimeInSec)
                    );
                end else
                begin
                    result := fSessionFactory.createSession(
                        fCookieName,
                        encryptedSession,
                        sessData
                    );
                end;
            end;
        except
            on EReadError do
            begin
                //if we get here, it means decrypting encrypted session is failed
                //maybe it has been tampered. just ignore and create new session
                result := fSessionFactory.createNewSession(
                    fCookieName,
                    encryptedSession,
                    incSecond(now(), lifeTimeInSec)
                );
            end;

            on ESessionExpired do
            begin
                result := fSessionFactory.createNewSession(
                    fCookieName,
                    encryptedSession,
                    incSecond(now(), lifeTimeInSec)
                );
            end;
        end;
    end;

    (*!------------------------------------
     * create session from request
     *-------------------------------------
     * @param request current request instance
     * @param lifeTimeInSec life time of session in seconds
     * @return session instance
     *-------------------------------------*)
    function TCookieSessionManager.beginSession(
        const request : IRequest;
        const lifeTimeInSec : integer
    ) : ISession;
    var encryptedSession : string;
    begin
        encryptedSession := request.getCookieParam(fCookieName);
        result := createNewSessionIfExpired(
            request,
            lifeTimeInSec,
            encryptedSession
        );
        fCurrentSession := result;
    end;

    (*!------------------------------------
     * get session from request
     *-------------------------------------
     * @param request current request instance
     * @return session instance or nil if not found
     *-------------------------------------*)
    function TCookieSessionManager.getSession(const request : IRequest) : ISession;
    begin
        if fCurrentSession <> nil then
        begin
            result := fCurrentSession;
        end else
        begin
            raise ESessionInvalid.create('Invalid session. Cannot get valid session');
        end;
    end;

    (*!------------------------------------
     * end session and save session data to
     * persistent storage
     *-------------------------------------
     * @param session session instance
     * @return current instance
     *-------------------------------------*)
    function TCookieSessionManager.endSession(const session : ISession) : ISessionManager;
    begin
        if session.expired() then
        begin
            destroySession(session);
        end;
        fCurrentSession := nil;
        result := self;
    end;

    (*!------------------------------------
     * end session and delete session data from
     * persistent storage
     *-------------------------------------
     * @param session session instance
     * @return current instance
     *-------------------------------------*)
    function TCookieSessionManager.destroySession(const session : ISession) : ISessionManager;
    begin
        session.clear();
        result := self;
    end;
end.
