{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DbSessionManagerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIntf,
    SessionIdGeneratorIntf,
    SessionManagerIntf,
    SessionFactoryIntf,
    RequestIntf,
    RdbmsIntf,
    ListIntf,
    AbstractSessionManagerImpl;

type

    (*!------------------------------------------------
     * Data structure for session table information
     *-----------------------------------------------*)
    TSessionTableInfo = record
        //name of session table
        tableName : string;

        //name of session id column
        sessionIdColumn : string;

        //name of session data column
        dataColumn : string;

        //name of expired at column
        expiredAtColumn : string;
    end;

    (*!------------------------------------------------
     * class having capability to manage
     * session variables in RDBMS database
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDbSessionManager = class(TAbstractSessionManager)
    private
        fRdbms : IRdbms;
        fSessTableInfo : TSessionTableInfo;
        fSessionFactory : ISessionFactory;
        fCurrentSession : ISession;

        function isSessionExistDb(const sessId : string) : boolean;

        function getSessionDb(
            const sessId : string;
            out sessData : string;
            out expiredAt : TDateTime
        ) : boolean;

        function createSessionDb(
            const sessId : string;
            const sessData : string;
            const expiredAt : TDateTime
        ) : boolean;

        function updateSessionDb(
            const sessId : string;
            const sessData : string;
            const expiredAt : TDateTime
        ) : boolean;

        function deleteSessionDb(const sessId : string) : boolean;

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

    public

        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param sessionIdGenerator helper class
         *           which can generate session id
         * @param sessionFactory helper class
         *           which create ISession object
         * @param cookieName name of cookie to use
         * @param rbmds rdbms instance
         * @param sessTableInfo session table information
         *-------------------------------------*)
        constructor create(
            const sessionIdGenerator : ISessionIdGenerator;
            const sessionFactory : ISessionFactory;
            const cookieName : string;
            const rdbms : IRdbms;
            const sessTableInfo : TSessionTableInfo
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
    RdbmsStatementIntf,
    RdbmsResultSetIntf,
    ESessionExpiredImpl,
    ESessionInvalidImpl;


    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param sessionIdGenerator helper class
     *           which can generate session id
     * @param sessionFactory helper class
     *           which create ISession object
     * @param cookieName name of cookie to use
     * @param rbmds rdbms instance
     * @param sessTableInfo session table information
     *-------------------------------------*)
    constructor TDbSessionManager.create(
        const sessionIdGenerator : ISessionIdGenerator;
        const sessionFactory : ISessionFactory;
        const cookieName : string;
        const rdbms : IRdbms;
        const sessTableInfo : TSessionTableInfo
    );
    begin
        inherited create(sessionIdGenerator, cookieName);
        fSessionFactory := sessionFactory;
        fRdbms := rdbms;
        fSessTableInfo := sessTableInfo;
        fCurrentSession := nil;
    end;

    (*!------------------------------------
     * destructor
     *-------------------------------------*)
    destructor TDbSessionManager.destroy();
    begin
        fRdbms := nil;
        fSessionFactory := nil;
        fCurrentSession := nil;
        inherited destroy();
    end;

    function TDbSessionManager.isSessionExistDb(const sessId : string) : boolean;
    var sts : IRdbmsStatement;
    begin
        sts := fRdbms.prepare(
            'SELECT 1 FROM `' + fSessTableInfo.tableName + '` ' +
            'WHERE `' + fSessTableInfo.sessionIdColumn + '` = :sessId'
        );
        sts.paramStr('sessId', sessId);
        result := sts.execute().resultCount <> 0;
    end;

    function TDbSessionManager.getSessionDb(
        const sessId : string;
        out sessData : string;
        out expiredAt : TDateTime
    ) : boolean;
    var sts : IRdbmsStatement;
        res : IRdbmsResultSet;
    begin
        result := false;
        sts := fRdbms.prepare(
            'SELECT ' +
                '`' + fSessTableInfo.dataColumn + '`, ' +
                '`' +fSessTableInfo.expiredAtColumn + '`' +
            ' FROM `' + fSessTableInfo.tableName + '` ' +
            'WHERE `' + fSessTableInfo.sessionIdColumn + '` = :sessId'
        );
        sts.paramStr('sessId', sessId);
        res := sts.execute();
        if res.resultCount <> 0 then
        begin
            result := true;
            sessData := res.fields.fieldByName(fSessTableInfo.dataColumn).asString;
            expiredAt := res.fields.fieldByName(fSessTableInfo.expiredAtColumn).asDateTime;
        end;
    end;

    function TDbSessionManager.createSessionDb(
        const sessId : string;
        const sessData : string;
        const expiredAt : TDateTime
    ) : boolean;
    var sts : IRdbmsStatement;
        res : IRdbmsResultSet;
    begin
        sts := fRdbms.prepare(
            'INSERT INTO `' + fSessTableInfo.tableName + '` ' +
            '( ' +
                '`' + fSessTableInfo.sessionIdColumn + '`,' +
                '`' + fSessTableInfo.dataColumn + '`, ' +
                '`' + fSessTableInfo.expiredAtColumn + '`' +
            ') VALUES (:sessId, :sessData, :expiredAt)'
        );
        sts.paramStr('sessId', sessId);
        sts.paramDateTime('expiredAt', expiredAt);
        sts.paramStr('sessData', sessData);
        res := sts.execute();
        //SqlDb ALWAYS implicitly start transaction so commit() is required
        fRdbms.commit();
        result := res.resultCount() <> 0;
    end;

    function TDbSessionManager.updateSessionDb(
        const sessId : string;
        const sessData : string;
        const expiredAt : TDateTime
    ) : boolean;
    var sts : IRdbmsStatement;
        res : IRdbmsResultSet;
    begin
        sts := fRdbms.prepare(
            'UPDATE `' + fSessTableInfo.tableName + '` ' +
            'SET ' +
            fSessTableInfo.dataColumn + ' = :sessData, ' +
            fSessTableInfo.expiredAtColumn + '= :expiredAt ' +
            'WHERE `' + fSessTableInfo.sessionIdColumn + '` = :sessId'
        );
        sts.paramStr('sessId', sessId);
        sts.paramDateTime('expiredAt', expiredAt);
        sts.paramStr('sessData', sessData);
        res := sts.execute();
        //SqlDb ALWAYS implicitly start transaction so commit() is required
        fRdbms.commit();
        result := res.resultCount() <> 0;
    end;

    function TDbSessionManager.deleteSessionDb(const sessId : string) : boolean;
    var sts : IRdbmsStatement;
        res : IRdbmsResultSet;
    begin
        sts := fRdbms.prepare(
            'DELETE FROM `' + fSessTableInfo.tableName + '` ' +
            'WHERE ' + fSessTableInfo.sessionIdColumn + ' = :sessId'
        );
        sts.paramStr('sessId', sessId);
        res := sts.execute();
        //SqlDb ALWAYS implicitly start transaction so commit() is required
        fRdbms.commit();
        result := res.resultCount() <> 0;
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
    function TDbSessionManager.findSession(const sessionId : string) : ISession;
    var sessData : string;
        expiry : TDateTime;
    begin
        result := nil;
        if (sessionId <> '') and (getSessionDb(sessionId, sessData, expiry)) then
        begin
            try
                result := fSessionFactory.createSession(
                    fCookieName,
                    sessionId,
                    sessData
                );
            except
                on ESessionExpired do
                begin
                    freeAndNil(result);
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
    function TDbSessionManager.createSession(
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
            //this is new session, persist it first to storage
            persistSession(sess);
        end;

        result := sess;
    end;

    (*!------------------------------------
     * create session from request
     *-------------------------------------
     * @param request current request instance
     * @param lifeTimeInSec life time of session in seconds
     * @return session instansce
     *-------------------------------------*)
    function TDbSessionManager.beginSession(
        const request : IRequest;
        const lifeTimeInSec : integer
    ) : ISession;
    var sessionId : string;
    begin
        try
            sessionId := request.getCookieParam(fCookieName);
            fCurrentSession := createSession(request, sessionId, lifeTimeInSec);
            result := fCurrentSession;
        except
            on e: ESessionExpired do
            begin
                //this should not happened unless fCookieName is empty
                //which mostly due to improper configuration
                e.message := e.message +
                    ' cookie:' + fCookieName +
                    ' sessionId:' + sessionId +
                    ' (begin session)';
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
    function TDbSessionManager.getSession(const request : IRequest) : ISession;
    var sessionId : shortstring;
    begin
        result := nil;
        sessionId := request.getCookieParam(fCookieName);

        if (fCurrentSession <> nil) then
        begin
            if (sessionId = '') or (fCurrentSession.id() = sessionId) then
            begin
                //if sessionId is empty string, it means first request
                //TODO: need to re-think because in multi-threaded without proper synchronization,
                //this may cause other user's session is hijacked
                result := fCurrentSession;
            end else
            begin
                result := findSession(sessionId);
            end;
        end else
        begin
            result := findSession(sessionId);
        end;

        if result = nil then
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
    function TDbSessionManager.endSession(const session : ISession) : ISessionManager;
    begin
        if session.expired() then
        begin
            destroySession(session);
        end else
        begin
            persistSession(session);
        end;
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
    function TDbSessionManager.persistSession(const session : ISession) : ISessionManager;
    var sessId : string;
    begin
        sessId := session.id();
        if isSessionExistDb(sessId) then
        begin
            updateSessionDb(sessId, session.serialize(), session.expiresAt());
        end else
        begin
            createSessionDb(sessId, session.serialize(), session.expiresAt());
        end;
        result := self;
    end;

    (*!------------------------------------
     * end session and delete session data from
     * persistent storage
     *-------------------------------------
     * @param session session instance
     * @return current instance
     *-------------------------------------*)
    function TDbSessionManager.destroySession(const session : ISession) : ISessionManager;
    var sessId : string;
    begin
        sessId := session.id();
        if isSessionExistDb(sessId) then
        begin
            deleteSessionDb(sessId);
        end;
        result := self;
    end;
end.
