{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonSessionImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    fpjson,
    SessionIntf,
    AbstractSessionImpl;

type

    (*!------------------------------------------------
     * class having capability to manage
     * session variables in JSON file
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TJsonSession = class(TAbstractSession)
    private

        fSessionData : TJsonData;

    protected

        (*!------------------------------------
         * set session variable
         *-------------------------------------
         * @param sessionVar name of session variable
         * @param sessionVal value of session variable
         * @return current instance
         *-------------------------------------*)
        function internalSetVar(const sessionVar : shortstring; const sessionVal : string) : ISession; override;

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

    Classes,
    SysUtils,
    jsonParser,
    SessionConsts,
    ESessionExpiredImpl,
    ESessionKeyNotFoundImpl,
    ESessionInvalidImpl;

resourcestring

    sErrKeyNotFound = 'Session data "%s" not found';

    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param sessName session name
     * @param sessId session id
     * @param sessData session data
     *-------------------------------------*)
    constructor TJsonSession.create(
        const sessName : shortstring;
        const sessId : string;
        const sessData : string
    );
    begin
        inherited create(sessName, sessId);

        try
            fSessionData := getJSON(sessData);
        except
            on e: EParserError do
            begin
                //change exception to not show misleading error message
                raise ESessionInvalid.create(rsSessionInvalid);
            end;
        end;

        raiseExceptionIfExpired();
    end;

    procedure TJsonSession.cleanUp();
    begin
        fSessionData.free();
    end;

    (*!------------------------------------
     * get current session id
     *-------------------------------------
     * @return session id string
     *-------------------------------------*)
    function TJsonSession.has(const sessionVar : shortstring) : boolean;
    begin
        result := (fSessionData.findPath(SESSION_VARS + '.' + sessionVar) <> nil);
    end;

    (*!------------------------------------
     * set session variable
     *-------------------------------------
     * @param sessionVar name of session variable
     * @param sessionVal value of session variable
     * @return current instance
     *-------------------------------------*)
    function TJsonSession.internalSetVar(const sessionVar : shortstring; const sessionVal : string) : ISession;
    var sessValue : TJsonData;
        tmpObj : TJsonObject;
    begin
        sessValue := fSessionData.findPath(SESSION_VARS + '.' + sessionVar);
        if (sessValue <> nil) then
        begin
            sessValue.asString := sessionVal;
        end else
        begin
            sessValue := fSessionData.findPath(SESSION_VARS);
            if (sessValue <> nil) then
            begin
                tmpObj := TJsonObject(sessValue);
            end else
            begin
                tmpObj := TJsonObject.create();
                TJsonObject(fSessionData).add(SESSION_VARS, tmpObj);
            end;
            tmpObj.add(sessionVar, sessionVal);
        end;
        result := self;
    end;

    (*!------------------------------------
     * get session variable
     *-------------------------------------
     * @return session value
     * @throws EJSON exception when not found
     *-------------------------------------*)
    function TJsonSession.internalGetVar(const sessionVar : shortstring) : string;
    var sessValue : TJsonData;
    begin
        try
            sessValue := fSessionData.getPath(SESSION_VARS + '.' + sessionVar);
        except
            on e : EJson do
            begin
                raise ESessionKeyNotFound.createFmt(
                   sErrKeyNotFound, [ sessionVar ]
                );
            end;
        end;
        result := sessValue.asString;
    end;

    (*!------------------------------------
     * delete session variable
     *-------------------------------------
     * @param sessionVar name of session variable
     * @return current instance
     *-------------------------------------*)
    function TJsonSession.internalDelete(const sessionVar : shortstring) : ISession;
    var sessValue : TJsonData;
    begin
        sessValue := fSessionData.findPath(SESSION_VARS);
        if (sessValue <> nil) then
        begin
            TJsonObject(sessValue).delete(sessionVar);
        end;
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
    function TJsonSession.internalClear() : ISession;
    var sessValue : TJsonData;
    begin
        sessValue := fSessionData.findPath(SESSION_VARS);
        if (sessValue <> nil) then
        begin
            sessValue.clear();
        end;
        result := self;
    end;

    (*!------------------------------------
     * set expiration date
     *-------------------------------------
     * @return current session instance
     *-------------------------------------*)
    function TJsonSession.expiresAt() : TDateTime;
    begin
        result := strToDateTime(fSessionData.getPath('expire').asString);
    end;

    (*!------------------------------------
     * serialize session data to string
     *-------------------------------------
     * @return string of session data
     *-------------------------------------*)
    function TJsonSession.serialize() : string;
    begin
        result := fSessionData.asJSON;
    end;
end.
