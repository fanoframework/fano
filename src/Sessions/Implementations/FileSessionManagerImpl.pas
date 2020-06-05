{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FileSessionManagerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    SessionIntf,
    SessionIdGeneratorIntf,
    SessionManagerIntf,
    SessionFactoryIntf,
    RequestIntf,
    FileReaderIntf,
    ListIntf,
    AbstractSessionManagerImpl;

type

    (*!------------------------------------------------
     * class having capability to manage
     * session variables in file
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFileSessionManager = class(TAbstractSessionManager)
    private
        fSessionFilename : string;
        fFileReader : IFileReader;
        fSessionList : IList;
        fCurrentSession : ISession;
        fSessionFactory : ISessionFactory;

        procedure writeSessionFile(const sessFile : string; const sessData : string);

        (*!------------------------------------
         * create session from session id
         *-------------------------------------
         * @param sessionId session id
         * @return session instance or nil if not found
         *-------------------------------------
         * if sessionId point to valid session id in storage,
         * then new ISession is created with is data populated
         * from storage.
         *
         * if sessionId is empty string or invalid
         * or expired, returns nil
         *-------------------------------------*)
        function findSession(const sessionId : string) : ISession;

        (*!------------------------------------
         * create session from session id
         *-------------------------------------
         * @param sessionId session id
         * @param lifeTimeInSec life time of session in seconds
         * @return session instance
         *-------------------------------------
         * if sessionId point to valid session id in storage,
         * then new ISession is created with is data populated
         * from storage. lifeTimeInSec parameter is ignored
         *
         * if sessionId is empty string or invalid
         * or expired, new ISession is created with empty
         * data, session life time is set to lifeTime value
         *-------------------------------------*)
        function createSession(
            const request : IRequest;
            const sessionId : string;
            const lifeTimeInSec : integer
        ) : ISession;

        (*!------------------------------------
         * end session and persist to storage
         *-------------------------------------
         * @param session session instance
         * @return current instance
         *-------------------------------------*)
        function persistSession(
            const session : ISession
        ) : ISessionManager;

        (*!------------------------------------
         * end session and remove its storage
         *-------------------------------------
         * @param session session instance
         * @return current instance
         *-------------------------------------*)
        function destroySession(
            const session : ISession
        ) : ISessionManager;

        procedure cleanUpSessionList();
    public

        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param sessionIdGenerator helper class
         *           which can generate session id
         * @param sessionFactory helper class
         *           which create ISession object
         * @param cookieName name of cookie to use
         * @param fileReader helper class
         *           which can read file to string
         * @param baseDir base directory where
         *                session files store
         * @param prefix string to be prefix to
         *                session filename
         *-------------------------------------*)
        constructor create(
            const sessionIdGenerator : ISessionIdGenerator;
            const sessionFactory : ISessionFactory;
            const cookieName : string;
            const fileReader : IFileReader;
            const baseDir : string;
            const prefix : string
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

    SysUtils,
    DateUtils,
    SessionConsts,
    HashListImpl,
    ESessionExpiredImpl,
    ESessionInvalidImpl;

type

    TSessionItem = record
        sessionObj : ISession;
    end;
    PSessionItem = ^TSessionItem;

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
     * @param prefix strung to be prefix to
     *                session filename
     *-------------------------------------*)
    constructor TFileSessionManager.create(
        const sessionIdGenerator : ISessionIdGenerator;
        const sessionFactory : ISessionFactory;
        const cookieName : string;
        const fileReader : IFileReader;
        const baseDir : string;
        const prefix : string
    );
    begin
        inherited create(sessionIdGenerator, cookieName);
        fSessionFactory := sessionFactory;
        fSessionFilename := baseDir + prefix;
        fFileReader := fileReader;
        fSessionList := THashList.create();
        fCurrentSession := nil;
    end;

    (*!------------------------------------
     * destructor
     *-------------------------------------*)
    destructor TFileSessionManager.destroy();
    begin
        fCurrentSession := nil;
        cleanUpSessionList();
        fFileReader := nil;
        fSessionList := nil;
        fSessionFactory := nil;
        inherited destroy();
    end;

    procedure TFileSessionManager.cleanUpSessionList();
    var indx : integer;
        item : PSessionItem;
    begin
        for indx := fSessionList.count()-1  downto 0 do
        begin
            item := fSessionList.get(indx);
            item^.sessionObj := nil;
            dispose(item);
            fSessionList.delete(indx);
        end;
    end;

    procedure TFileSessionManager.writeSessionFile(const sessFile : string; const sessData : string);
    var fs : TFileStream;
    begin
        fs := TFileStream.create(sessFile, fmCreate);
        try
            fs.seek(0, soFromBeginning);
            fs.writeBuffer(sessData[1], length(sessData));
        finally
            fs.free();
        end;
    end;

    (*!------------------------------------
     * find session from session id
     *-------------------------------------
     * @param sessionId session id
     * @return session instance or nil if not found
     *-------------------------------------
     * if sessionId point to valid session id in storage,
     * then new ISession is created with is data populated
     * from storage. lifeTimeInSec parameter is ignored
     *
     * if sessionId is empty string or invalid
     * or expired, return nil
     *-------------------------------------*)
    function TFileSessionManager.findSession(const sessionId : string) : ISession;
    var sessFile : string;
    begin
        result := nil;
        sessFile := fSessionFilename + sessionId;
        if (sessionId <> '') and (fileExists(sessFile)) then
        begin
            try
                result := fSessionFactory.createSession(
                    fCookieName,
                    sessionId,
                    fFileReader.readFile(sessFile)
                );
            except
                on ESessionExpired do
                begin
                    freeAndNil(result);
                    deleteFile(sessFile);
                end;
            end;
        end;
    end;

    (*!------------------------------------
     * create session from session id
     *-------------------------------------
     * @param sessionId session id
     * @param lifeTimeInSec life time of session in seconds
     * @return session instance
     *-------------------------------------
     * if sessionId point to valid session id in storage,
     * then new ISession is created with is data populated
     * from storage. lifeTimeInSec parameter is ignored
     *
     * if sessionId is empty string or invalid
     * or expired, new ISession is created with empty
     * data, session life time is set to lifeTime value
     *-------------------------------------*)
    function TFileSessionManager.createSession(
        const request : IRequest;
        const sessionId : string;
        const lifeTimeInSec : integer
    ) : ISession;
    var sess : ISession;
    begin
        sess := findSession(sessionId);

        if sess = nil then
        begin
            sess := fSessionFactory.createNewSession(
                fCookieName,
                fSessionIdGenerator.getSessionId(request),
                incSecond(now(), lifeTimeInSec)
            );
        end;

        result := sess;
    end;

    (*!------------------------------------
     * create session from request
     *-------------------------------------
     * @param request current request instance
     * @param lifeTimeInSec life time of session in seconds
     * @return session instance
     *-------------------------------------*)
    function TFileSessionManager.beginSession(
        const request : IRequest;
        const lifeTimeInSec : integer
    ) : ISession;
    var sessionId : string;
        sess : ISession;
        item : PSessionItem;
    begin
        try
            sessionId := request.getCookieParam(fCookieName);
            sess := createSession(request, sessionId, lifeTimeInSec);

            new(item);
            item^.sessionObj := sess;
            fSessionList.add(sess.id(), item);

            fCurrentSession := sess;
            result := sess;
        except
            on e: ESessionExpired do
            begin
                e.message := e.message + ' at begin session';
                raise;
            end;
        end;
    end;

    (*!------------------------------------
     * get session from request
     *-------------------------------------
     * @param request current request instance
     * @return session instance or nil if not found
     *-------------------------------------*)
    function TFileSessionManager.getSession(const request : IRequest) : ISession;
    var sessionId : shortstring;
        item : PSessionItem;
    begin
        sessionId := request.getCookieParam(fCookieName);
        item := fSessionList.find(sessionId);
        //it is assumed that getSession will be called between
        //beginSession() and endSession()
        //so fCurrentSession MUST NOT nil
        if (item = nil) and (fCurrentSession <> nil) then
        begin
            //if we get here, it means, this is the first request
            //so cookie is not yet set but it is initialized
            result := fCurrentSession;
        end else
        if (item <> nil) then
        begin
            result := item^.sessionObj;
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
    function TFileSessionManager.endSession(const session : ISession) : ISessionManager;
    var indx : integer;
        item : PSessionItem;
    begin
        if session.expired() then
        begin
            destroySession(session);
        end else
        begin
            persistSession(session);
        end;

        indx := fSessionList.indexOf(session.id());
        item := fSessionList.get(indx);
        item^.sessionObj := nil;
        dispose(item);
        fSessionList.delete(indx);

        fCurrentSession := nil;

        result := self;
    end;

    (*!------------------------------------
     * end session and save session data to
     * persistent storage
     *-------------------------------------
     * @param session session instance
     * @return current instance
     *-------------------------------------*)
    function TFileSessionManager.persistSession(const session : ISession) : ISessionManager;
    var sessFilename : string;
    begin
        sessFilename := fSessionFilename + session.id();
        writeSessionFile(sessFilename, session.serialize());
        session.clear();
        result := self;
    end;

    (*!------------------------------------
     * end session and delete session data from
     * persistent storage
     *-------------------------------------
     * @param session session instance
     * @return current instance
     *-------------------------------------*)
    function TFileSessionManager.destroySession(const session : ISession) : ISessionManager;
    var sessFilename : string;
    begin
        session.clear();
        sessFilename := fSessionFilename + session.id();
        if (fileExists(sessFilename)) then
        begin
            deleteFile(sessFilename);
        end;
        result := self;
    end;
end.
