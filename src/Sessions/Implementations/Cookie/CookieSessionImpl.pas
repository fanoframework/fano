{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CookieSessionImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIntf,
    EncrypterIntf;

type

    (*!------------------------------------------------
     * class having capability to manage encrypt
     * session variables as encrypted session id
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCookieSession = class(TInterfacedObject, ISession)
    private
        fActualSession : ISession;
        fEncrypter : IEncrypter;
    public

        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param actualSession actual session instance;
         * @param encrypter instance data encrypter
         *-------------------------------------*)
        constructor create(
            const actualSession : ISession;
            const encrypter : IEncrypter
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
        function has(const sessionVar : shortstring) : boolean;

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
        function expired() : boolean;

        (*!------------------------------------
         * get session expiration date
         *-------------------------------------
         * @return date time when session is expired
         *-------------------------------------*)
        function expiresAt() : TDateTime;

        (*!------------------------------------
         * serialize session data to string
         *-------------------------------------
         * @return string of session data
         *-------------------------------------*)
        function serialize() : string;
    end;

implementation

uses

    Classes,
    SysUtils,
    SessionConsts,
    ESessionExpiredImpl;

    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param actualSession actual session instance;
     * @param encrypter instance data encrypter
     *-------------------------------------*)
    constructor TCookieSession.create(
        const actualSession : ISession;
        const encrypter : IEncrypter
    );
    begin
        fActualSession := actualSession;
        fEncrypter := encrypter;
    end;

    destructor TCookieSession.destroy();
    begin
        fActualSession := nil;
        fEncrypter := nil;
        inherited destroy();
    end;

    function TCookieSession.name() : shortstring;
    begin
        result := fActualSession.name();
    end;

    (*!------------------------------------
     * get current session id
     *-------------------------------------
     * @return session id string
     *-------------------------------------*)
    function TCookieSession.id() : string;
    begin
        //for session data encoded in cookie, id will be encrypted session data
        //so we just call our serialize() method
        result := serialize();
    end;

    (*!------------------------------------
     * get current session id
     *-------------------------------------
     * @return session id string
     *-------------------------------------*)
    function TCookieSession.has(const sessionVar : shortstring) : boolean;
    begin
        result := fActualSession.has(sessionVar);
    end;

    (*!------------------------------------
     * set session variable
     *-------------------------------------
     * @param sessionVar name of session variable
     * @param sessionVal value of session variable
     *-------------------------------------*)
    procedure TCookieSession.setVar(const sessionVar : shortstring; const sessionVal : string);
    begin
        fActualSession.setVar(sessionVar, sessionVal);
    end;

    (*!------------------------------------
     * get session variable
     *-------------------------------------
     * @return session value
     * @throws EJSON exception when not found
     *-------------------------------------*)
    function TCookieSession.getVar(const sessionVar : shortstring) : string;
    begin
        result := fActualSession.getVar(sessionVar);
    end;

    (*!------------------------------------
     * delete session variable
     *-------------------------------------
     * @param sessionVar name of session variable
     * @return current instance
     *-------------------------------------*)
    function TCookieSession.delete(const sessionVar : shortstring) : ISession;
    begin
        fActualSession.delete(sessionVar);
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
    function TCookieSession.clear() : ISession;
    begin
        fActualSession.clear();
        result := self;
    end;

    (*!------------------------------------
     * test if current session is expired
     *-------------------------------------
     * @return true if session is expired
     *-------------------------------------*)
    function TCookieSession.expired() : boolean;
    begin
        result := fActualSession.expired();
    end;

    (*!------------------------------------
     * set expiration date
     *-------------------------------------
     * @return current session instance
     *-------------------------------------*)
    function TCookieSession.expiresAt() : TDateTime;
    begin
        result := fActualSession.expiresAt();
    end;

    (*!------------------------------------
     * serialize session data to string
     *-------------------------------------
     * @return string of session data
     *-------------------------------------*)
    function TCookieSession.serialize() : string;
    begin
        result := fEncrypter.encrypt(fActualSession.serialize());
    end;

end.
