{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractSessionImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIntf;

const

    SESSION_VARS = 'sessionVars';

type

    (*!------------------------------------------------
     * base class having capability to manage
     * session variables
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractSession = class(TInterfacedObject, ISession)
    protected
        fSessionName : shortstring;
        fSessionId : string;

        procedure raiseExceptionIfAlreadyTerminated();
        procedure raiseExceptionIfExpired();

        (*!------------------------------------
         * set session variable
         *-------------------------------------
         * @param sessionVar name of session variable
         * @param sessionVal value of session variable
         * @return current instance
         *-------------------------------------*)
        function internalSetVar(
            const sessionVar : shortstring;
            const sessionVal : string
        ) : ISession; virtual; abstract;

        (*!------------------------------------
         * get session variable
         *-------------------------------------
         * @return session value
         *-------------------------------------*)
        function internalGetVar(const sessionVar : shortstring) : string; virtual; abstract;

        (*!------------------------------------
         * delete session variable
         *-------------------------------------
         * @param sessionVar name of session variable
         * @return current instance
         *-------------------------------------*)
        function internalDelete(const sessionVar : shortstring) : ISession; virtual; abstract;

        (*!------------------------------------
         * clear all session variables
         *-------------------------------------
         * This is only remove session data, but
         * underlying storage is kept
         *-------------------------------------
         * @return current instance
         *-------------------------------------*)
        function internalClear() : ISession; virtual; abstract;

        procedure cleanUp(); virtual; abstract;
    public

        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param sessName session name
         * @param sessId session id
         * @param sessData session data
         *-------------------------------------*)
        constructor create(
            const sessName : shortstring;
            const sessId : string
        );

        destructor destroy(); override;

        (*!------------------------------------
         * get session name
         *-------------------------------------
         * @return session name
         *-------------------------------------*)
        function name() : shortstring;

        (*!------------------------------------
         * get current session id
         *-------------------------------------
         * @return session id string
         *-------------------------------------*)
        function id() : string;

        (*!------------------------------------
         * get current session id
         *-------------------------------------
         * @return session id string
         *-------------------------------------*)
        function has(const sessionVar : shortstring) : boolean; virtual; abstract;

        (*!------------------------------------
         * set session variable
         *-------------------------------------
         * @param sessionVar name of session variable
         * @param sessionVal value of session variable
         *-------------------------------------*)
        procedure setVar(const sessionVar : shortstring; const sessionVal : string);

        (*!------------------------------------
         * get session variable
         *-------------------------------------
         * @return session value
         *-------------------------------------*)
        function getVar(const sessionVar : shortstring) : string;

        (*!------------------------------------
         * delete session variable
         *-------------------------------------
         * @param sessionVar name of session variable
         * @return current instance
         *-------------------------------------*)
        function delete(const sessionVar : shortstring) : ISession;

        (*!------------------------------------
         * clear all session variables
         *-------------------------------------
         * This is only remove session data, but
         * underlying storage is kept
         *-------------------------------------
         * @return current instance
         *-------------------------------------*)
        function clear() : ISession;

        (*!------------------------------------
         * test if current session is expired
         *-------------------------------------
         * @return true if session is expired
         *-------------------------------------*)
        function expired() : boolean; virtual;

        (*!------------------------------------
         * get session expiration date
         *-------------------------------------
         * @return date time when session is expired
         *-------------------------------------*)
        function expiresAt() : TDateTime; virtual; abstract;

        (*!------------------------------------
         * serialize session data to string
         *-------------------------------------
         * @return string of session data
         *-------------------------------------*)
        function serialize() : string; virtual; abstract;
    end;

implementation

uses

    Classes,
    SysUtils,
    DateUtils,
    SessionConsts,
    ESessionExpiredImpl;

    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param sessName session name
     * @param sessId session id
     * @param sessData session data
     *-------------------------------------*)
    constructor TAbstractSession.create(
        const sessName : shortstring;
        const sessId : string
    );
    begin
        inherited create();
        fSessionName := sessName;
        fSessionId := sessId;
    end;

    destructor TAbstractSession.destroy();
    begin
        cleanUp();
        inherited destroy();
    end;

    function TAbstractSession.name() : shortstring;
    begin
        result := fSessionName;
    end;

    (*!------------------------------------
     * get current session id
     *-------------------------------------
     * @return session id string
     *-------------------------------------*)
    function TAbstractSession.id() : string;
    begin
        result := fSessionId;
    end;

    procedure TAbstractSession.raiseExceptionIfAlreadyTerminated();
    begin
        //TODO: raise ESessionTerminated.create()
    end;

    (*!------------------------------------
     * set session variable
     *-------------------------------------
     * @param sessionVar name of session variable
     * @param sessionVal value of session variable
     *-------------------------------------*)
    procedure TAbstractSession.setVar(const sessionVar : shortstring; const sessionVal : string);
    begin
        raiseExceptionIfExpired();
        internalSetVar(sessionVar, sessionVal);
    end;

    (*!------------------------------------
     * get session variable
     *-------------------------------------
     * @return session value
     * @throws EJSON exception when not found
     *-------------------------------------*)
    function TAbstractSession.getVar(const sessionVar : shortstring) : string;
    begin
        raiseExceptionIfAlreadyTerminated();
        raiseExceptionIfExpired();
        result := internalGetVar(sessionVar);
    end;

    (*!------------------------------------
     * delete session variable
     *-------------------------------------
     * @param sessionVar name of session variable
     * @return current instance
     *-------------------------------------*)
    function TAbstractSession.delete(const sessionVar : shortstring) : ISession;
    begin
        raiseExceptionIfExpired();
        result := internalDelete(sessionVar);
    end;

    (*!------------------------------------
     * clear all session variables
     *-------------------------------------
     * This is only remove session data, but
     * underlying storage is kept
     *-------------------------------------
     * @return current instance
     *-------------------------------------*)
    function TAbstractSession.clear() : ISession;
    begin
        raiseExceptionIfExpired();
        result := internalClear();
    end;

    procedure TAbstractSession.raiseExceptionIfExpired();
    begin
        if (expired()) then
        begin
            raise ESessionExpired.createFmt(rsSessionExpired, [fSessionId]);
        end;
    end;

    (*!------------------------------------
     * test if current session is expired
     *-------------------------------------
     * @return true if session is expired
     *-------------------------------------*)
    function TAbstractSession.expired() : boolean;
    begin
        //value > 0, means now() is later than expiresAt() i.e,
        //expiresAt is in past
        result := (compareDateTime(now(), expiresAt()) > 0);
    end;

end.
