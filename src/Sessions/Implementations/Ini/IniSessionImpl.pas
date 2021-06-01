{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IniSessionImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    IniFiles,
    SessionIntf,
    AbstractSessionImpl;

type

    (*!------------------------------------------------
     * class having capability to manage
     * session variables in INI file
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TIniSession = class(TAbstractSession)
    private
        fSessionData : TIniFile;
        fSessionStream : TStringStream;

    protected

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
        ) : ISession; override;

        (*!------------------------------------
         * get session variable
         *-------------------------------------
         * @return session value
         *-------------------------------------*)
        function internalGetVar(const sessionVar : shortstring) : string; override;

        (*!------------------------------------
         * delete session variable
         *-------------------------------------
         * @param sessionVar name of session variable
         * @return current instance
         *-------------------------------------*)
        function internalDelete(const sessionVar : shortstring) : ISession; override;

        (*!------------------------------------
         * clear all session variables
         *-------------------------------------
         * This is only remove session data, but
         * underlying storage is kept
         *-------------------------------------
         * @return current instance
         *-------------------------------------*)
        function internalClear() : ISession; override;

        procedure cleanUp(); override;
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
            const sessId : string;
            const sessData : string
        );

        (*!------------------------------------
         * get current session id
         *-------------------------------------
         * @return session id string
         *-------------------------------------*)
        function has(const sessionVar : shortstring) : boolean; override;

        (*!------------------------------------
         * get session expiration date
         *-------------------------------------
         * @return date time when session is expired
         *-------------------------------------*)
        function expiresAt() : TDateTime; override;

        (*!------------------------------------
         * serialize session data to string
         *-------------------------------------
         * @return string of session data
         *-------------------------------------*)
        function serialize() : string; override;
    end;

implementation

uses

    SysUtils,
    SessionConsts,
    ESessionExpiredImpl;

    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param sessName session name
     * @param sessId session id
     * @param sessData session data
     *-------------------------------------*)
    constructor TIniSession.create(
        const sessName : shortstring;
        const sessId : string;
        const sessData : string
    );
    begin
        inherited create(sessName, sessId);
        fSessionStream := TStringStream.create(sessData);
        fSessionData := TIniFile.create(fSessionStream);
        raiseExceptionIfExpired();
    end;

    procedure TIniSession.cleanUp();
    begin
        fSessionStream.free();
        fSessionData.free();
    end;

    (*!------------------------------------
     * get current session id
     *-------------------------------------
     * @return session id string
     *-------------------------------------*)
    function TIniSession.has(const sessionVar : shortstring) : boolean;
    begin
        result := (fSessionData.readString(SESSION_VARS, sessionVar, '') <> '');
    end;

    (*!------------------------------------
     * set session variable
     *-------------------------------------
     * @param sessionVar name of session variable
     * @param sessionVal value of session variable
     * @return current instance
     *-------------------------------------*)
    function TIniSession.internalSetVar(const sessionVar : shortstring; const sessionVal : string) : ISession;
    begin
        fSessionData.writeString(SESSION_VARS, sessionVar, sessionVal);
        result := self;
    end;

    (*!------------------------------------
     * get session variable
     *-------------------------------------
     * @return session value or empty string
     *        when not found
     *-------------------------------------*)
    function TIniSession.internalGetVar(const sessionVar : shortstring) : string;
    begin
        result := fSessionData.readString(SESSION_VARS, sessionVar, '');
    end;

    (*!------------------------------------
     * delete session variable
     *-------------------------------------
     * @param sessionVar name of session variable
     * @return current instance
     *-------------------------------------*)
    function TIniSession.internalDelete(const sessionVar : shortstring) : ISession;
    begin
        fSessionData.deleteKey(SESSION_VARS, sessionVar);
        result := self;
    end;

    (*!------------------------------------
     * clear all session variables
     *-------------------------------------
     * This is only remove session data, but
     * underlying storage is kept
     *-------------------------------------
     * @return current instance
     *-------------------------------------*)
    function TIniSession.internalClear() : ISession;
    begin
        fSessionData.eraseSection(SESSION_VARS);
        result := self;
    end;

    (*!------------------------------------
     * get expiration date
     *-------------------------------------
     * @return current session instance
     *-------------------------------------*)
    function TIniSession.expiresAt() : TDateTime;
    begin
        result := strToDateTime(fSessionData.readString('expiry', 'expire', '01-01-1970 00:00:00'));
    end;

    (*!------------------------------------
     * serialize session data to string
     *-------------------------------------
     * @return string of session data
     *-------------------------------------*)
    function TIniSession.serialize() : string;
    begin
        fSessionData.updateFile();
        result := fSessionStream.dataString;
    end;
end.
